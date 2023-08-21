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
	g.dt_fechamento,
	date_trunc('month', g.dt_fechamento)::date as mes_fechamento,
	count(distinct case when a.cd_cbo similar to '(225|2231|2235)%' and a.dt_atendimento <= dt_t1 then a.dt_atendimento::date end) as consultas_12s,
	count(distinct case when a.cd_cbo similar to '(225|2231|2235)%' then a.dt_atendimento::date end) as consultas_ges,
	count(distinct case when a.cd_cbo like '2232%' then a.dt_atendimento::date end) as consultas_odo
--	max(case when (eproc.cd_procedimento in (1140,1141,315,340,341,412,417) and (er.dt_resultado is not null or er.ds_resultado is not null or er.status = 2))
--			or icp.cd_procedimento in (1140,1141,315,340,341,412,417) 
--			or trt.tp_teste = 0 then 1 else 0 end) as fl_ex_hiv,
--	max(case when (eproc.cd_procedimento in (1143,1144,419,421,422,423,426) and (er.dt_resultado is not null or er.ds_resultado is not null or er.status = 2))
--			or icp.cd_procedimento in (1143,1144,419,421,422,423,426) 
--			or trt.tp_teste = 2 then 1 else 0 end) as fl_ex_sif
from 
	gestantes g
	left join atendimento a on a.cd_usu_cadsus = g.cd_usu_cadsus
		and a.dt_atendimento between g.dt_ult_menst and g.dt_fechamento
		and a.cd_cbo similar to '(225|2231|2232|2235)%'
	left join empresa e on e.empresa = a.empresa
--  left join exame ex on ex.nr_atendimento = a.nr_atendimento
--	left join exame_requisicao er on er.cd_exame = ex.cd_exame
--	left join exame_procedimento eproc on er.cd_exame_procedimento = eproc.cd_exame_procedimento
--	left join item_conta_paciente icp on a.nr_atendimento = icp.nr_atendimento
--	left join teste_rapido tr on tr.nr_atendimento = a.nr_atendimento
--	left join teste_rapido_realizado trr on trr.cd_teste_rapido = tr.cd_teste_rapido
--	left join teste_rapido_tipo trt on trt.cd_tp_teste = trr.cd_tp_teste 
where 
	a.status = 4
	and (e.cod_atv is null or e.cod_atv = 2)
group by 1, 2, 3, 4