select 
	case 
		when em.cod_atv = 2 then 'Centro de Saúde'
		when em.descricao like 'POLICL_NICA %' then 'Policlínica'
		when em.descricao like 'CAPS%' then 'CAPS'
		when em.descricao like 'UNIDADE DE PRONTO AT%' then 'UPA'			
		else 'Outros serviços' 
		end as unidade_responsavel,
	extract('year' from atd.dt_atendimento) as ano,
	uc.sg_sexo as sexo,
	case 
		when extract('year' from age(atd.dt_atendimento,uc.dt_nascimento)) between 0 and 14 then 'Faixa etária 1'	
		when extract('year' from age(atd.dt_atendimento,uc.dt_nascimento)) between 15 and 17 then 'Faixa etária 2'
	end as faixa_etaria,
	count(atd.nr_atendimento) as quant_atendimentos_cid_f,
	count(distinct(atd.cd_usu_cadsus)) as quant_pessoas_cid_f
from 
	atendimento atd
	join empresa em on atd.empresa = em.empresa 
	join usuario_cadsus uc on uc.cd_usu_cadsus = atd.cd_usu_cadsus
where 
	atd.dt_atendimento::date between '2018-01-01'::date and '2022-12-31'::date
	and (atd.cd_cid_principal like 'F%' or atd.cd_cid_secundario like 'F%')
	and extract('year' from age(atd.dt_atendimento,uc.dt_nascimento)) < 18
group by 1,2,3,4