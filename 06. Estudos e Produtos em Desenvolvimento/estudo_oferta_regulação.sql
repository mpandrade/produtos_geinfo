select 
	em.descricao as unidade,
	case 
		when agah.status = 1 then 'agendado'
		when agah.status = 2 then 'concluído'
		when agah.status = 3 then 'cancelado'
		when agah.status = 4 then 'não compareceu'
		end as status,
	count(agah.cd_ag_gra_ate_hor) as quant_vagas
from 
	agenda_gra_ate_horario agah
    left join tipo_procedimento tp on agah.cd_tp_procedimento = tp.cd_tp_procedimento	
	left join solicitacao_agendamento sa on agah.cd_solicitacao = sa.cd_solicitacao
	left join empresa em on agah.local_agendamento = em.empresa  
where 
	sa.cd_tp_procedimento = 334286
	and agah.dt_agendamento::date between '2023-02-01'::date and '2023-02-28'::date
	and agah.status <> 5 -- remanejamentos
group by 1,2

union all 

select 
	sum(case when agah.cd_ag_gra_ate_hor is not null then 1 else 0 end) vaga_usada
from 
	agenda ag
    left join agenda_grade agr on ag.cd_agenda = agr.cd_agenda
    left join agenda_grade_atendimento aga on aga.cd_ag_grade = agr.cd_ag_grade
    left join agenda_gra_ate_horario agah on agah.cd_ag_gra_atendimento = aga.cd_ag_gra_atendimento
where 
	agr."data"::date between '2023-02-01'::date and '2023-02-28'::date
	and ag.cd_tp_procedimento = 334286