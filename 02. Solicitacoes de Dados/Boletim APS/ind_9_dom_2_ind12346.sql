select
	a.cd_usu_cadsus,
	a.cd_profissional,
	a.cd_cbo,
	date_trunc('month', a.dt_atendimento)::date as mes,
	count(distinct a.dt_atendimento::date) as consultas,
	count(distinct icp.cd_it_conta_paciente) as procedimentos
from
	atendimento a 
	join empresa e on e.empresa = a.empresa 
	join item_conta_paciente icp on icp.nr_atendimento = a.nr_atendimento
where 
	a.dt_atendimento >= date_trunc('month', current_date) - interval '2 year'
	and a.dt_atendimento < date_trunc('month', current_date)
	and a.status = 4 -- Finalizados
	and e.cod_atv = 2
	and a.cd_cbo similar to '(225|2231|2235|2232|322245|322250)%'
	and a.cd_procedimento not in (4740, 4745)
group by 1, 2, 3, 4