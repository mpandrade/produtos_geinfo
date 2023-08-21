-- eventos
select distinct
	atd.cd_usu_cadsus,
    atd.cd_usu_cadsus::varchar || '|' || atd.dt_chegada::date as id_atendimento,
    min(atd.dt_atendimento)
    	over (partition by atd.cd_usu_cadsus::varchar || '|' || atd.dt_chegada::date) as dt_atendimento,
    em.empresa,
    em.cod_atv,
    first_value(atd.cd_cid_principal)
    	over (partition by atd.cd_usu_cadsus::varchar || '|' || atd.dt_chegada::date
    		order by case when atd.cd_cid_principal is not null then 0 else 1 end, atd.dt_atendimento
    		rows between unbounded preceding and unbounded following) as cid_principal,
    first_value(atd.cd_cid_secundario)
    	over (partition by atd.cd_usu_cadsus::varchar || '|' || atd.dt_chegada::date
    		order by case when atd.cd_cid_secundario is not null then 0 else 1 end, atd.dt_atendimento
    		rows between unbounded preceding and unbounded following) as cid_secundario,
    atd.cd_cid_secundario, 
    max(case when atd.cd_cbo similar to '(225|2231)%' then 1 else 0 end) 
    	over (partition by atd.cd_usu_cadsus::varchar || '|' || atd.dt_chegada::date) as fl_med,
    max(case when atd.cd_cbo similar to '(2235)%' then 1 else 0 end) 
    	over (partition by atd.cd_usu_cadsus::varchar || '|' || atd.dt_chegada::date) as fl_enf,
    max(case when atd.cd_cbo similar to '(322245|322250)' then 1 else 0 end) 
    	over (partition by atd.cd_usu_cadsus::varchar || '|' || atd.dt_chegada::date) as fl_tenf,
    max(case when atd.cd_cbo similar to '(2232)%' then 1 else 0 end) 
    	over (partition by atd.cd_usu_cadsus::varchar || '|' || atd.dt_chegada::date) as fl_odo,
	max(case when atd.cd_cid_principal similar to '(I1|O10|O11)%'
			or atd.cd_cid_secundario similar to '(I1|O10|O11)%'
			or atd.cd_ciap in (248,249) then 1 else 0 end)
    	over (partition by atd.cd_usu_cadsus::varchar || '|' || atd.dt_chegada::date) as fl_cons_has,
	max(case when atd.cd_cid_principal ~ 'E1[0-5]|O24(?![4-9])|P702'
			or atd.cd_cid_secundario ~ 'E1[0-5]|O24(?![4-9])|P702'
			or atd.cd_ciap in (514, 515) then 1 else 0 end)
    	over (partition by atd.cd_usu_cadsus::varchar || '|' || atd.dt_chegada::date) as fl_cons_dm,
	max(case when (eproc.cd_procedimento in (1140,1141,315,340,341,412,417) and (er.dt_resultado is not null or er.ds_resultado is not null or er.status = 0))
			or icp.cd_procedimento in (1140,1141,315,340,341,412,417) 
			or trt.tp_teste = 0 then 1 else 0 end)
    	over (partition by atd.cd_usu_cadsus::varchar || '|' || atd.dt_chegada::date) as fl_ex_hiv,
	max(case when (eproc.cd_procedimento in (1143,1144,419,421,422,423,426) and (er.dt_resultado is not null or er.ds_resultado is not null or er.status = 2))
			or icp.cd_procedimento in (1143,1144,419,421,422,423,426) 
			or trt.tp_teste = 2 then 1 else 0 end)
    	over (partition by atd.cd_usu_cadsus::varchar || '|' || atd.dt_chegada::date) as fl_ex_sif,
	max(case when icp.cd_procedimento in (177) then 1 else 0 end)
    	over (partition by atd.cd_usu_cadsus::varchar || '|' || atd.dt_chegada::date) as fl_coleta_cp,
	max(case when icp.cd_procedimento in (1281) then 1 else 0 end)
    	over (partition by atd.cd_usu_cadsus::varchar || '|' || atd.dt_chegada::date) as fl_afericao_pa,
	max(case when eproc.cd_procedimento in (229) then 1 else 0 end)
    	over (partition by atd.cd_usu_cadsus::varchar || '|' || atd.dt_chegada::date) as fl_ex_a1c
from 
	atendimento atd 
	join usuario_cadsus uc on uc.cd_usu_cadsus = atd.cd_usu_cadsus
	join empresa em on em.empresa = atd.empresa
    left join encaminhamento en on en.nr_atendimento = atd.nr_atendimento
    left join tipo_encaminhamento te on te.cd_tp_encaminhamento = en.cd_tp_encaminhamento
    left join exame ex on ex.nr_atendimento = atd.nr_atendimento
	left join exame_requisicao er on er.cd_exame = ex.cd_exame
	left join exame_procedimento eproc on er.cd_exame_procedimento = eproc.cd_exame_procedimento
	left join item_conta_paciente icp on atd.nr_atendimento = icp.nr_atendimento
	left join teste_rapido tr on tr.nr_atendimento = atd.nr_atendimento
	left join teste_rapido_realizado trr on trr.cd_teste_rapido = tr.cd_teste_rapido
	left join teste_rapido_tipo trt on trt.cd_tp_teste = trr.cd_tp_teste 
where 
	atd.dt_atendimento >= date_trunc('month', current_date) - interval '2 year'
	and atd.dt_atendimento  < date_trunc('month', current_date)
	and atd.status = 4 -- Finalizados
	and em.cod_atv in (2, 73)
	and uc.st_vivo = 1
	and uc.st_excluido = 0
	and uc.cd_municipio_residencia = 420540
	and uc.flag_unificado = 0
	and uc.situacao in (0,1)
	and atd.cd_cbo similar to '(225|2231|2235|2232|322245|322250)%'
;