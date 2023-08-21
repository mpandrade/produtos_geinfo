select 
	a.cd_usu_cadsus,
	a.dt_chegada::date as dt_chegada,
    em.empresa,
	max(case when (eproc.cd_procedimento in (1140,1141,315,340,341,412,417) and (er.dt_resultado is not null or er.ds_resultado is not null or er.status = 2))
			or icp.cd_procedimento in (1140,1141,315,340,341,412,417) 
			or trt.tp_teste = 0 then 1 else 0 end) as fl_ex_hiv,
	max(case when (eproc.cd_procedimento in (1143,1144,419,421,422,423,426) and (er.dt_resultado is not null or er.ds_resultado is not null or er.status = 2))
			or icp.cd_procedimento in (1143,1144,419,421,422,423,426) 
			or trt.tp_teste = 2 then 1 else 0 end) as fl_ex_sif,
	max(case when icp.cd_procedimento in (177) then 1 else 0 end) as fl_coleta_cp,
	max(case when icp.cd_procedimento in (1281) then 1 else 0 end) as fl_afericao_pa,
	max(case when eproc.cd_procedimento in (229) then 1 else 0 end) as fl_ex_a1c
from 
	atendimento a 
	join empresa em on em.empresa = a.empresa
    left join exame ex on ex.nr_atendimento = a.nr_atendimento
	left join exame_requisicao er on er.cd_exame = ex.cd_exame
	left join exame_procedimento eproc on er.cd_exame_procedimento = eproc.cd_exame_procedimento
	left join item_conta_paciente icp on a.nr_atendimento = icp.nr_atendimento
	left join teste_rapido tr on tr.nr_atendimento = a.nr_atendimento
	left join teste_rapido_realizado trr on trr.cd_teste_rapido = tr.cd_teste_rapido
	left join teste_rapido_tipo trt on trt.cd_tp_teste = trr.cd_tp_teste 
where 
	a.dt_atendimento >= date_trunc('month', current_date) - interval '4 years'
	and a.dt_atendimento  < date_trunc('month', current_date)
	and a.status = 4 -- Finalizados
	and em.cod_atv = 2
	and (icp.cd_procedimento in (177, 1281, 1140, 1141, 315, 340, 341, 412, 417, 1143, 1144, 419, 421, 422, 423, 426) 
		or eproc.cd_procedimento in (229)
		or (eproc.cd_procedimento in (1140, 1141, 315, 340, 341, 412, 417, 1143, 1144, 419, 421, 422, 423, 426)
			and (er.dt_resultado is not null or er.ds_resultado is not null or er.status = 2)))
group by 1, 2, 3