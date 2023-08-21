select 
	a.cd_usu_cadsus,
	min(a.dt_atendimento)::date as dt_inicial,
	max(case when a.cd_cid_principal similar to '(I1|O10|O11)%'
		or a.cd_cid_secundario similar to '(I1|O10|O11)%'
		or a.cd_ciap in (248, 249) then 1 else 0 end) as fl_has,
	max(case when a.cd_cid_principal ~ 'E1[0-5]|O24(?![4-9])|P702'
			or a.cd_cid_secundario ~ 'E1[0-5]|O24(?![4-9])|P702'
			or a.cd_ciap in (514, 515) then 1 else 0 end) as fl_dm
from 
	atendimento a 
where 
	((a.cd_cid_principal similar to '(I1|O10|O11)%'
		or a.cd_cid_secundario similar to '(I1|O10|O11)%'
		or a.cd_ciap in (248, 249))
		or (a.cd_cid_principal ~ 'E1[0-5]|O24(?![4-9])|P702'
			or a.cd_cid_secundario ~ 'E1[0-5]|O24(?![4-9])|P702'
			or a.cd_ciap in (514, 515)))
	and a.status = 4
group by 1