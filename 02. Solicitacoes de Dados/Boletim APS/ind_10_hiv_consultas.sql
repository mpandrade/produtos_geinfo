with
	hiv_id as (select 
			a.cd_usu_cadsus,
			min(a.dt_atendimento)::date as dt_inicial
		from 
			atendimento a 
			join usuario_cadsus uc on uc.cd_usu_cadsus = a.cd_usu_cadsus 
		where 
			(a.cd_cid_principal ~ 'B2[0-4]|Z21|F024|R75'
				or a.cd_cid_secundario ~ 'B2[0-4]|Z21|F024|R75'
				or a.cd_ciap in (87))
			and uc.st_vivo = 1
			and uc.st_excluido = 0
			and uc.cd_municipio_residencia = 420540
			and uc.flag_unificado = 0
			and uc.situacao in (0,1)
			and a.status = 4
			and a.dt_atendimento >= '2019-01-01'::date
		group by 1)
select
	hiv.cd_usu_cadsus,
	hiv.dt_inicial,
	date_trunc('month', a.dt_atendimento)::date as mes_atd,
	count(distinct a.cd_usu_cadsus::varchar || '|' || a.dt_chegada::date) as consultas
from 
	atendimento a
	join hiv_id hiv on hiv.cd_usu_cadsus = a.cd_usu_cadsus 
	join empresa e on e.empresa = a.empresa 
where 
	e.cod_atv = 2
	and a.dt_atendimento between date_trunc('month', current_date) - interval '2 years' and date_trunc('month', current_date)
	and a.dt_atendimento >= hiv.dt_inicial
	and a.status = 4
	and a.cd_cbo similar to '(225|2231)%'
group by 1, 2, 3