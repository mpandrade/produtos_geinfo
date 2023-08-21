select
	uc.cd_usu_cadsus,
	va.dt_aplicacao::date as dt_aplicacao,
	tv.ds_vacina,
	case
        when va.cd_doses = 9 then 'Dose Única'
        when va.cd_doses = 8 then 'Dose nao especificada'
        when va.cd_doses = 10 then 'Revacinação'
        when va.cd_doses = 7 then '2o. Reforço'
        when va.cd_doses = 6 then '1o. Reforço'
        when va.cd_doses = 38 then 'Reforço'
        when va.cd_doses = 36 then 'Dose Inicial'
        when va.cd_doses = 37 then 'Dose Adicional'
        when va.cd_doses between 1 and 5 then va.cd_doses::text || 'a. Dose'
        else 'Dose nao especificada' end as nu_dose
from 
	vac_aplicacao va
	join tipo_vacina tv on tv.cd_vacina = va.cd_vacina
	join usuario_cadsus uc on uc.cd_usu_cadsus = va.cd_usu_cadsus 
where 
	va.status = 1
	and uc.st_vivo = 1
	and uc.st_excluido = 0
	and uc.cd_municipio_residencia = 420540
	and uc.flag_unificado = 0
	and uc.situacao in (0,1)
	and va.dt_aplicacao >= date_trunc('month', current_date) - interval '1 years'