select 
	replace(em.descricao, 'UNIDADE DE PRONTO ATENDIMENTO - ', '') as unidade,
	case 
		when atd.cd_cbo similar to '(225|2231)%' then 'MEDICO'
		when atd.cd_cbo similar to '(2235)%' then 'ENFERMEIRO'
		when atd.cd_cbo similar to '(2232)%' then 'DENTISTA'
		when atd.cd_cbo similar to '(3222)%' then 'TECNICO DE ENFERMAGEM'
	end as profissional,
	cr.descricao,
	count(atd.nr_atendimento) as quant
from
	atendimento atd
	join empresa em on atd.empresa = em.empresa 
	left join natureza_procura_tp_atendimento npta on atd.cd_nat_proc_tp_atendimento = npta.cd_nat_proc_tp_atendimento 
	left join tipo_atendimento ta on npta.cd_tp_atendimento = ta.cd_tp_atendimento 
	left join classificacao_risco cr on atd.classificacao_risco = cr.cd_classificacao_risco 
where 
	atd.empresa in (259033,4272619,259035)
	and atd.cd_cbo similar to '(225|2231|2235|2232|3222)%'
	and atd.dt_atendimento::date between '2022-01-01'::date and '2022-12-31'::date
	and atd.status = 4
group by 1,2,3


