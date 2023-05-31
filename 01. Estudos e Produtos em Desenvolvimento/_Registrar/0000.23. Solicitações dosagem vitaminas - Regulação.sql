select	
	upper(pro.nm_profissional) as profissional,
	pro.cd_profissional,
	pch.cd_cbo,
	sum(case when p.referencia = '0202010767' then 1 else 0 end) as solicit_vit_d,
	sum(case when p.referencia = '0202010708' then 1 else 0 end) as solicit_vit_b12	
from
	solicitacao_agendamento sa 
	join profissional pro on sa.cd_profissional = pro.cd_profissional
	join solicitacao_agendamento_exame sae on sae.cd_solicitacao = sa.cd_solicitacao
	join exame_procedimento ep on sae.cd_exame_procedimento = ep.cd_exame_procedimento 
	join procedimento p on ep.cd_procedimento = p.cd_procedimento
	join (
		select *
		from profissional_carga_horaria
		where dt_desativacao is null and
			  cd_cbo is not null and
		      cd_prof_carga_horaria in (
			select min(cd_prof_carga_horaria)
			from profissional_carga_horaria
			
			group by cd_profissional
		      )
	) pch on pch.cd_profissional = pro.cd_profissional
where 
  	p.referencia in ('0202010767','0202010708')
  	and extract('year' from sa.dt_solicitacao) = 2022
  	and sa.status <> 6
group by 1,2,3
order by 1
