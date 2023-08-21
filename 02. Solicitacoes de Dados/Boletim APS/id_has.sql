-- Identificação HAS
select 
	a.cd_usu_cadsus,
	min(a.dt_atendimento)::date as dt_inicial
from 
	atendimento a 
	join usuario_cadsus uc on uc.cd_usu_cadsus = a.cd_usu_cadsus 
where 
	(a.cd_cid_principal similar to '(I1|O10|O11)%'
		or a.cd_cid_secundario similar to '(I1|O10|O11)%'
		or a.cd_ciap in (248,249))
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
	(gpc.cd_cid similar to '(I1|O10|O11)%'
		or gpc.cd_ciap in (248, 249))
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
	ri.cod_pro in ('4142716', '4143515', '4142717', '4144807', '4146748', '4143447', '4143446', '4144638', '4142882', '4142937', '4143714', '4144825', '4143806')
	and dias_tratamento > 90
	and uc.st_excluido = 0
    and uc.st_vivo = 1
    and uc.situacao in (0,1)
	and uc.flag_unificado = 0 
	and r.cd_receita = 1
	and r.dt_receituario >= '2019-01-01'::date
group by 1
;