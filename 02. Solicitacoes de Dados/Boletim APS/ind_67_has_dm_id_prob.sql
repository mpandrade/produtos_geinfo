select distinct
	gpc.cd_usu_cadsus,
	min(gpc.dt_inicial)::date as dt_inicial,
	max(case when gpc.cd_cid similar to '(I1|O10|O11)%'
		or gpc.cd_ciap in (248, 249) then 1 else 0 end) as fl_has,
	max(case when gpc.cd_cid ~ 'E1[0-5]|O24(?![4-9])|P702'
		or gpc.cd_ciap in (514, 515) then 1 else 0 end) as fl_dm
from 
	grupo_problemas_condicoes gpc
where 
	(gpc.cd_cid similar to '(I1|O10|O11)%'
		or gpc.cd_ciap in (248, 249))
	or (gpc.cd_cid ~ 'E1[0-5]|O24(?![4-9])|P702'
		or gpc.cd_ciap in (514, 515))
group by 1