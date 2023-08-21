with
	receitas as (
		select 
			date_trunc('month', r.dt_receituario) as mes_referencia,
			em.descricao as unidade,
			count(distinct r.cd_receituario) as receitas
		from 
			receituario r 
			join empresa em on r.empresa = em.empresa 
		where
			em.empresa in (259033,4272619,259035)					-- UPA Continente
			and r.dt_receituario::date between date_trunc('month', current_date) - interval '1 year'
				and date_trunc('month', current_date) - interval '1 day'
			and (extract(hour from r.dt_receituario) >= 17 			-- após às 17
				 or extract(hour from r.dt_receituario) < 7 		-- antes das 7
				 or extract(dow from r.dt_receituario) in (0,6)) 	-- sábado ou domingo
			and r.cd_receita = 4402315 								-- tipo_receita = Antimicrobiano
		group by 1, 2
	),
	dispensacoes as (
		select 
			date_trunc('month', dm.dt_dispensacao) as mes_referencia,
			em.descricao as unidade,
			count(distinct dm.nr_dispensacao) as dispensacoes
		from 
			dispensacao_medicamento dm
			join dispensacao_medicamento_item dmi on dmi.nr_dispensacao = dm.nr_dispensacao 
			join produtos p on p.cod_pro = dmi.cod_pro 
			join empresa em on dm.empresa = em.empresa 
		where
			em.empresa in (259033,4272619,259035)					-- UPA Continente
			and dm.dt_dispensacao::date between date_trunc('month', current_date) - interval '1 year'
				and date_trunc('month', current_date) - interval '1 day'
			and (extract(hour from dm.dt_dispensacao) >= 17 		-- após às 17
				 or extract(hour from dm.dt_dispensacao) < 7 		-- antes das 7
				 or extract(dow from dm.dt_dispensacao) in (0,6)) 	-- sábado ou domingo
			and p.cd_receita = 4402315 								-- tipo_receita = Antimicrobiano
		group by 1, 2
	)
select 
	r.mes_referencia,
	r.unidade,
	r.receitas,
	coalesce(d.dispensacoes, 0) as dispensacoes
from 
	receitas r
	left join dispensacoes d on d.mes_referencia = r.mes_referencia
		and d.unidade = r.unidade