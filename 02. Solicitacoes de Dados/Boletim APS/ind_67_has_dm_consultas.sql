select distinct
	a.cd_usu_cadsus,
	a.dt_atendimento::date,
	max(case when a.cd_cid_principal similar to '(I1|O10|O11)%'
			or a.cd_cid_secundario similar to '(I1|O10|O11)%'
			or a.cd_ciap in (248,249) then 1 else 0 end) as fl_cons_has,
	max(case when a.cd_cid_principal ~ 'E1[0-5]|O24(?![4-9])|P702'
			or a.cd_cid_secundario ~ 'E1[0-5]|O24(?![4-9])|P702'
			or a.cd_ciap in (514, 515) then 1 else 0 end) as fl_cons_dm
from
	atendimento a 
	join empresa e on e.empresa = a.empresa 
where 
	a.dt_atendimento >= date_trunc('month', current_date) - interval '18 months'
	and a.dt_atendimento < date_trunc('month', current_date)
	and a.status = 4 -- Finalizados
	and e.cod_atv = 2
	and ((a.cd_cid_principal similar to '(I1|O10|O11)%'
			or a.cd_cid_secundario similar to '(I1|O10|O11)%'
			or a.cd_ciap in (248,249))
		or (a.cd_cid_principal ~ 'E1[0-5]|O24(?![4-9])|P702'
			or a.cd_cid_secundario ~ 'E1[0-5]|O24(?![4-9])|P702'
			or a.cd_ciap in (514, 515)))
group by 1, 2