-- VERIFICAR A RELAÇÃO DAS TABELAS E POR QUE O EXAME NÃO APARECE TAMBÉM COMO PROCEDIMENTO EM ICP


select 
	em.descricao,
	extract('month' from atd.dt_atendimento) as mes,
	--ep.ds_procedimento as exame_pro,
	--pro.ds_procedimento as proced_pro,
	ta.ds_tipo_atendimento as tipo_atendimento,
	count(atd.nr_atendimento) as quant_atendimentos
from 
	atendimento atd
	left join item_conta_paciente icp on atd.nr_atendimento = icp.nr_atendimento  
	left join empresa em on atd.empresa = em.empresa 
--	left join exame_procedimento ep on icp.cd_exame_procedimento = ep.cd_exame_procedimento 
--	left join procedimento pro on pro.cd_procedimento = icp.cd_procedimento 
	left join natureza_procura_tp_atendimento npta on atd.cd_nat_proc_tp_atendimento = npta.cd_nat_proc_tp_atendimento
    left join tipo_atendimento ta on npta.cd_tp_atendimento = ta.cd_tp_atendimento	
where 
	--em.cnpj = '82892282000143'
	atd.dt_atendimento::date between '2022-01-01'::date and '2022-12-31'::date
	--and ep.ds_procedimento like '%ELETROENC%'
--	(ep.cd_exame_procedimento in (334677,334682,334695,334748,334743,334708,334750,117925,337750,334650,117911,117913,117915,117917,117937,4476921)
--	or 
--	pro.ds_procedimento like '%ENCEFALOG%'
--	or 
	and ta.cd_tp_atendimento in (334566,433370713)
group by 1,2,3
order by 1,2