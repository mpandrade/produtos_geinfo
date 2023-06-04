select 
	to_char(atd.dt_atendimento::date, 'MM-YYYY') as mes,
	pro.ds_procedimento as tipo_atendimento,
	replace(em.descricao, 'UNIDADE DE PRONTO ATENDIMENTO - ', '') as unidade,
	case 
		when atd.cd_cbo similar to '(225|2231)%' then 'MEDICO'
		when atd.cd_cbo similar to '(2235)%' then 'ENFERMEIRO'
		when atd.cd_cbo similar to '(2232)%' then 'DENTISTA'
		when atd.cd_cbo similar to '(3222)%' then 'TECNICO DE ENFERMAGEM'
		else 'OUTROS PROFISSIONAIS'	
	end as profissional,
	count(atd.nr_atendimento) as quant_atd,
	count(distinct(atd.cd_usu_cadsus)) as quant_usuarios
from
	atendimento atd
	join empresa em on atd.empresa = em.empresa 
	left join procedimento pro on atd.cd_procedimento = pro.cd_procedimento
	left join natureza_procura_tp_atendimento npta on atd.cd_nat_proc_tp_atendimento = npta.cd_nat_proc_tp_atendimento 
	left join tipo_atendimento ta on npta.cd_tp_atendimento = ta.cd_tp_atendimento  
where 
	atd.empresa in (259033,4272619,259035)
	--and atd.cd_cbo similar to '(225|2231|2235|2232|3222)%'
	and atd.dt_atendimento::date between '2022-01-01'::date and '2023-04-30'::date
	and atd.status = 4
group by 1,2,3,4
order by 3,4


