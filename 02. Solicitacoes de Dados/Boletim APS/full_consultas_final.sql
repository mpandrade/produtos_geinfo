with
	total as (select distinct
			a.cd_usu_cadsus,
			a.dt_chegada::date as dt_ref,
		    e.empresa,
		    e.cod_atv,
		    min(a.dt_chegada)
		    	over (partition by a.cd_usu_cadsus, a.dt_chegada::date) as dt_chegada,
		    min(a.dt_atendimento)
		    	over (partition by a.cd_usu_cadsus, a.dt_chegada::date) as dt_atendimento,
		    max(a.dt_fechamento)
		    	over (partition by a.cd_usu_cadsus, a.dt_chegada::date) as dt_fechamento,
		    first_value(a.cd_cid_principal)
		    	over (partition by a.cd_usu_cadsus, a.dt_chegada::date
		    		order by case when a.cd_cid_principal is not null then 0 else 1 end, a.dt_atendimento
		    		rows between unbounded preceding and unbounded following) as cid_principal,
		    first_value(a.cd_cid_secundario)
		    	over (partition by a.cd_usu_cadsus, a.dt_chegada::date
		    		order by case when a.cd_cid_principal is not null then 0 else 1 end, a.dt_atendimento
		    		rows between unbounded preceding and unbounded following) as cid_secundario,
			first_value(case when a.cd_cbo similar to '(225|2231)%' then a.cd_profissional end)
		    	over (partition by a.cd_usu_cadsus, a.dt_chegada::date
		    		order by case when a.cd_cbo similar to '(225|2231)%' then 0 else 1 end, a.dt_atendimento
		    		rows between unbounded preceding and unbounded following) as cd_prof_med,
			first_value(case when a.cd_cbo similar to '(2235)%' then a.cd_profissional end)
		    	over (partition by a.cd_usu_cadsus, a.dt_chegada::date
		    		order by case when a.cd_cbo similar to '(2235)%' then 0 else 1 end, a.dt_atendimento
		    		rows between unbounded preceding and unbounded following) as cd_prof_enf,
			first_value(case when a.cd_cbo similar to '(2232)%' then a.cd_profissional end)
		    	over (partition by a.cd_usu_cadsus, a.dt_chegada::date
		    		order by case when a.cd_cbo similar to '(2232)%' then 0 else 1 end, a.dt_atendimento
		    		rows between unbounded preceding and unbounded following) as cd_prof_odo,
			first_value(case when a.cd_cbo in ('322245', '322250') then a.cd_profissional end)
		    	over (partition by a.cd_usu_cadsus, a.dt_chegada::date
		    		order by case when a.cd_cbo in ('322245', '322250') then 0 else 1 end, a.dt_atendimento
		    		rows between unbounded preceding and unbounded following) as cd_prof_tenf,
			max(case when a.cd_cid_principal similar to '(I1|O10|O11)%'
					or a.cd_cid_secundario similar to '(I1|O10|O11)%'
					or a.cd_ciap in (248,249) then 1 else 0 end)
		    	over (partition by a.cd_usu_cadsus, a.dt_chegada::date) as fl_cons_has,
			max(case when a.cd_cid_principal ~ 'E1[0-5]|O24(?![4-9])|P702'
					or a.cd_cid_secundario ~ 'E1[0-5]|O24(?![4-9])|P702'
					or a.cd_ciap in (514, 515) then 1 else 0 end)
		    	over (partition by a.cd_usu_cadsus, a.dt_chegada::date) as fl_cons_dm
		from
			atendimento a 
			join empresa e on e.empresa = a.empresa 
			join usuario_cadsus uc on uc.cd_usu_cadsus = a.cd_usu_cadsus
		where 
			a.dt_atendimento >= date_trunc('month', current_date) - interval '1 year'
			and a.dt_atendimento < date_trunc('month', current_date)
			and a.status = 4 -- Finalizados
			and e.cod_atv in (2, 73)),
	proxima as (select distinct
			*,
			lead(dt_chegada) over (partition by cd_usu_cadsus order by dt_ref) as proxima_dt,
			lead(cod_atv) over (partition by cd_usu_cadsus order by dt_ref) as proxima_atv
		from 
			total)
select
	*
from 
	proxima
where 
	cod_atv = 2