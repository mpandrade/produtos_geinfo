with
	base as (select 
			em.descricao as unidade,
			rec.cd_usu_cadsus as cod_usuario,
			rec.dt_cadastro::date as data_prescricao,
			rec.cd_receituario as cod_receita,
			ri.nm_produto as medicamento,
			dm.dt_dispensacao::date as data_dispensacao,
			dm.nr_dispensacao as cod_dispensacao
		from
			receituario rec 
			left join dispensacao_medicamento dm on rec.cd_receituario = dm.cd_receituario 
			join receituario_item ri on rec.cd_receituario = ri.cd_receituario 
			join empresa em on rec.empresa = em.empresa 
		where 
			rec.dt_receituario::date between date_trunc('month', current_date) - interval '1 year'
				and date_trunc('month', current_date) - interval '1 day'
			and rec.cd_receita = 4402315
			and rec.empresa in (259033,4272619,259035)
			and ri.cod_pro is not null
			and (extract(hour from rec.dt_receituario) >= 17 			-- após às 17
				 or extract(hour from rec.dt_receituario) < 7 		-- antes das 7
				 or extract(dow from rec.dt_receituario) in (0,6)))
select 
	unidade,
	date_trunc('month', data_prescricao) as mes_referencia,
	count(1) as receitados,
	sum(case when data_dispensacao is not null then 1 end) as dispensados
from
	base
group by 1, 2