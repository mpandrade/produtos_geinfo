select
	a.cd_usu_cadsus,
	a.dt_atendimento::date as dt_cp
from 
	atendimento a
	join item_conta_paciente icp on a.nr_atendimento = icp.nr_atendimento
where 
	a.dt_atendimento between date_trunc('month', current_date) - interval '4 years' and date_trunc('month', current_date)
	and icp.cd_procedimento = 177
	and a.status = 4