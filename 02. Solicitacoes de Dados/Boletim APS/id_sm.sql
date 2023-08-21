-- Identificação episódio depressivo
with
	cid_f as (select 
			a.cd_usu_cadsus,
			case when a.cd_cid_principal like 'F%' then a.cd_cid_principal else a.cd_cid_secundario end as cid,
			min(a.dt_atendimento)::date as dt_inicial
		from 
			atendimento a 
			join usuario_cadsus uc on uc.cd_usu_cadsus = a.cd_usu_cadsus 
		where 
			(a.cd_cid_principal like 'F%'
				or a.cd_cid_secundario like 'F%')
			and uc.st_vivo = 1
			and uc.st_excluido = 0
			and uc.cd_municipio_residencia = 420540
			and uc.flag_unificado = 0
			and uc.situacao in (0,1)
			and a.status = 4
			and a.dt_atendimento >= '2019-01-01'::date
		group by 1, 2),
	depressao as (select 
			cd_usu_cadsus,
			max(case when cid not like 'F32%' then 1 else 0 end) as fl_remover,
			min(dt_inicial) as dt_inicial
		from 
			cid_f
		group by 1)
select
	d.cd_usu_cadsus,
	d.dt_inicial,
	count(distinct case when e.cod_atv = 2 then a.cd_usu_cadsus::varchar || a.dt_chegada::date end) as consultas_aps,
	count(distinct case when e.cod_atv in (4, 70) then a.cd_usu_cadsus::varchar || a.dt_chegada::date end) as consultas_nao_aps
from 
	depressao d
	left join atendimento a on a.cd_usu_cadsus = d.cd_usu_cadsus
		and a.dt_atendimento >= d.dt_inicial
		and a.status = 4
		and a.dt_atendimento >= date_trunc('month', current_date) - interval '1 year'
		and a.dt_atendimento < date_trunc('month', current_date)
		and (a.cd_cid_principal like 'F%'
			or a.cd_cid_secundario like 'F%')
	left join empresa e on e.empresa = a.empresa 
where 
	fl_remover = 0
group by 1, 2