select distinct
	a.cd_usu_cadsus,
	a.dt_atendimento::date
from
	atendimento a 
	join empresa e on e.empresa = a.empresa 
	join item_conta_paciente icp on a.nr_atendimento = icp.nr_atendimento
where 
	a.dt_atendimento >= date_trunc('month', current_date) - interval '18 months'
	and a.dt_atendimento < date_trunc('month', current_date)
	and a.status = 4 -- Finalizados
	and e.cod_atv = 2
	and icp.cd_procedimento in (1281)
group by 1, 2