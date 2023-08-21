-- Identificação gestantes
with
	gestantes as (select
			pn.cd_usu_cadsus,
			pn.cd_prenatal,
			pn.dt_ult_menst,
			(pn.dt_ult_menst + interval '12 weeks')::date as dt_t1,
			coalesce(pn.dt_parto, pn.dt_fechamento, pn.dt_prov_parto + interval '2 weeks', pn.dt_ult_menst + interval '42 weeks')::date as dt_fechamento
		from 
			prenatal pn
			join usuario_cadsus uc ON pn.cd_usu_cadsus = uc.cd_usu_cadsus
		where 
			pn.dt_ult_menst >= date_trunc('month', current_date) - interval '2 year'
			and uc.st_vivo = 1
			and uc.st_excluido = 0
			and uc.cd_municipio_residencia = 420540
			and uc.flag_unificado = 0
			and uc.situacao in (0, 1)) 
select
	g.cd_usu_cadsus,
	g.cd_prenatal,
	date_trunc('month', g.dt_fechamento)::date as mes_fechamento,
	max(case when (eproc.cd_procedimento in (1140,1141,315,340,341,412,417) and (er.dt_resultado is not null or er.ds_resultado is not null or er.status = 2)) then 1 else 0 end) as fl_ex_hiv,
	max(case when (eproc.cd_procedimento in (1143,1144,419,421,422,423,426) and (er.dt_resultado is not null or er.ds_resultado is not null or er.status = 2)) then 1 else 0 end) as fl_ex_sif
from 
	gestantes g
	left join exame ex on ex.cd_usu_cadsus = g.cd_usu_cadsus
		and ex.dt_solicitacao between g.dt_ult_menst and g.dt_fechamento
	left join exame_requisicao er on er.cd_exame = ex.cd_exame
	left join exame_procedimento eproc on er.cd_exame_procedimento = eproc.cd_exame_procedimento
where 
	(eproc.cd_procedimento in (1140,1141,315,340,341,412,417) and (er.dt_resultado is not null or er.ds_resultado is not null or er.status = 2))
	or (eproc.cd_procedimento in (1143,1144,419,421,422,423,426) and (er.dt_resultado is not null or er.ds_resultado is not null or er.status = 2))
group by 1, 2, 3