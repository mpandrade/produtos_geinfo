select 
	pre.cd_prenatal,
	uc.cd_usu_cadsus as cod_usuario,
	uc.nm_usuario,
	uc.dt_nascimento,
	pre.dt_ult_menst,
	pre.dt_prov_parto,
	pre.dt_parto,
	case when uc.cd_municipio_residencia = 420540 then 'Florianópolis' else 'Outros' end as municipio_residencia,
	max(case when 
		p1.cd_procedimento in (1143,1144,419,421,422,423,426)
		or p2.cd_procedimento in (1143,1144,419,421,422,423,426) 
		or trt.tp_teste = 2
		then 1 else 0 end) 
		as ex_sifilis,
	max(case when
		p1.cd_procedimento in (1140,1141,315,340,341,412,417)
		or p2.cd_procedimento in (1140,1141,315,340,341,412,417) 
		or trt.tp_teste = 0
		then 1 else 0 end) 
		as ex_hiv
from 
	prenatal pre
	join usuario_cadsus uc on pre.cd_usu_cadsus = uc.cd_usu_cadsus 
	left join atendimento atd on pre.cd_usu_cadsus = atd.cd_usu_cadsus
	left join item_conta_paciente icp on atd.nr_atendimento = icp.nr_atendimento
	left join procedimento p2 on icp.cd_procedimento = p2.cd_procedimento
	left join teste_rapido tr on tr.nr_atendimento = atd.nr_atendimento
	left join teste_rapido_realizado trr on trr.cd_teste_rapido = tr.cd_teste_rapido
	left join teste_rapido_tipo trt on trt.cd_tp_teste = trr.cd_tp_teste 
	left join exame ex on atd.nr_atendimento = ex.nr_atendimento
	left join exame_requisicao er on er.cd_exame = ex.cd_exame
	left join exame_procedimento ep on er.cd_exame_procedimento = ep.cd_exame_procedimento
	left join procedimento p1 on ep.cd_procedimento = p1.cd_procedimento
where 
	extract('year' from pre.dt_ult_menst) in (2020, 2021, 2022)
	and atd.dt_atendimento::date between pre.dt_ult_menst::date and least(pre.dt_prov_parto, pre.dt_parto)::date
group by 1,2,3,4,5,6,7,8
order by 3