-- Identificação gestantes
select
			pn.cd_usu_cadsus,
			pn.cd_prenatal,
			pn.dt_ult_menst,
			(pn.dt_ult_menst + interval '12 weeks')::date as dt_t1,
			coalesce(pn.dt_parto, pn.dt_fechamento, pn.dt_prov_parto + interval '2 weeks', pn.dt_ult_menst + interval '42 weeks')::date as dt_fechamento
		from 
			prenatal pn
			join usuario_cadsus uc ON pn.cd_usu_cadsus = uc.cd_usu_cadsus
		where 
			pn.dt_ult_menst >= date_trunc('month', current_date) - interval '1 year'
			and uc.st_vivo = 1
			and uc.st_excluido = 0
			and uc.cd_municipio_residencia = 420540
			and uc.flag_unificado = 0
			and uc.situacao in (0, 1)