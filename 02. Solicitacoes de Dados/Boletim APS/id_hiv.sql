-- Identificação HIV
select 
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
group by 1
