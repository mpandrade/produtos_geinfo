select 
	tp.ds_tp_procedimento as especialidade,
	extract('month' from agr."data") as mes,
	sum(aga.qtdade_atendimento) as quant_vagas
from 
	agenda ag
    left join agenda_grade agr on ag.cd_agenda = agr.cd_agenda
    left join agenda_grade_atendimento aga on aga.cd_ag_grade = agr.cd_ag_grade
    left join tipo_procedimento tp on ag.cd_tp_procedimento = tp.cd_tp_procedimento 
where 
	agr."data"::date between '2023-02-01'::date and '2023-03-31'::date
	and ag.cd_tp_procedimento in (334286,334304)
group by 1,2
	
	
	
