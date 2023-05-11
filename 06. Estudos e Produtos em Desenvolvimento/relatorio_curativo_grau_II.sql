select 
 	extract('year' from atd.dt_atendimento) as ano,
	em.descricao as unidade,
	count(atd.nr_atendimento)
from 
	item_conta_paciente icp
	join atendimento atd on icp.nr_atendimento = atd.nr_atendimento
	join procedimento pro on icp.cd_procedimento = pro.cd_procedimento
	join tipo_procedimento tp on tp.cd_procedimento = pro.cd_procedimento 
	join empresa em on atd.empresa = em.empresa 
where 
	tp.cd_tp_procedimento = 335481
	and atd.dt_atendimento::date >= '2019-01-01'::date
group by 1,2