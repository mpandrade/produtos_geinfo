-- Identificação DM
select 
	a.cd_usu_cadsus,
	min(a.dt_atendimento)::date as dt_inicial
from 
	atendimento a 
	join usuario_cadsus uc on uc.cd_usu_cadsus = a.cd_usu_cadsus 
where 
	(a.cd_cid_principal ~ 'E1[0-5]|O24(?![4-9])|P702'
		or a.cd_cid_secundario ~ 'E1[0-5]|O24(?![4-9])|P702'
		or a.cd_ciap in (514, 515))
	and uc.st_vivo = 1
	and uc.st_excluido = 0
	and uc.cd_municipio_residencia = 420540
	and uc.flag_unificado = 0
	and uc.situacao in (0,1)
	and a.status = 4
	and a.dt_atendimento >= '2019-01-01'::date
group by 1
union all
select distinct
	gpc.cd_usu_cadsus,
	min(coalesce(gpc.dt_inicial, '2019-01-01'::date))::date as dt_inicial
from 
	grupo_problemas_condicoes gpc
	join usuario_cadsus uc on uc.cd_usu_cadsus = gpc.cd_usu_cadsus 
where 
	(gpc.cd_cid ~ 'E1[0-5]|O24(?![4-9])|P702'
		or gpc.cd_ciap in (514, 515))
	and uc.st_vivo = 1
	and uc.st_excluido = 0
	and uc.cd_municipio_residencia = 420540
	and uc.flag_unificado = 0
	and uc.situacao in (0,1)
group by 1
union all
select 
	r.cd_usu_cadsus,
	min(r.dt_receituario)::date as dt_inicial
from 
	receituario r 
	join receituario_item ri on ri.cd_receituario = r.cd_receituario 
	join usuario_cadsus uc on uc.cd_usu_cadsus = r.cd_usu_cadsus 
where 
	ri.cod_pro in ('4034', '3657', '4148079', '4144307', '4144659', '4146882', '4146884', '4142996', '4144657', '4144658',
				   '4143614', '4143613', '3656', '4144660', '4142994', '4142995', '4144656', '4144717', '4144816', '4144730',
				   '4143329', '4144810')
	and dias_tratamento > 90
	and uc.st_excluido = 0
    and uc.st_vivo = 1
    and uc.situacao in (0,1)
	and uc.flag_unificado = 0 
	and r.cd_receita = 1
	and r.dt_receituario >= '2019-01-01'::date
group by 1
;