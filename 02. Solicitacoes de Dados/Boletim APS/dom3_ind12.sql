select 
	a.cd_profissional,
	a.cd_cid_principal as cid_principal,
	date_trunc('month', a.dt_atendimento)::date as mes,
	count(distinct a.cd_usu_cadsus::varchar || '|' || a.dt_chegada::date) as atendimentos
from 
	atendimento a 
	join empresa e on e.empresa = a.empresa 
where 
	a.dt_atendimento between date_trunc('month', current_date) - interval '2 years' and date_trunc('month', current_date)
	and a.status = 4
	and e.cod_atv = 2
	and a.cd_cbo similar to '(225|2231)%'
	and a.cd_cid_principal is not null
group by 1, 2, 3