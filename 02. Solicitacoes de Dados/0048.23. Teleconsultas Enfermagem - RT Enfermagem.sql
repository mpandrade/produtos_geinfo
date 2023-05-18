select 
	extract('year' from atd.dt_atendimento) as ano,
	case 
		when em.cod_atv = 2 then 'CS' 
		when em.descricao like 'POLICLINICA%' then 'POLICLINICA'
		when em.descricao like 'UNIDADE DE PRONTO%' then 'UPA'
		when em.descricao like '%CAPS%' then 'CAPS'
		when em.descricao like '%TRANS' then 'AMBULATORIO TRANS'
		when em.descricao like '%RUA' then 'CONSULTORIO NA RUA'
		when em.descricao like 'ALÔ%' then 'ALO SAUDE'
		when em.descricao like 'SERVICO DE VIGI%' then 'VIGILANCIA EPIDEMIOLOGICA'
		else 'OUTROS' end as unidade,
	case when atd.cd_cla_atendimento = 320082004 or atd.cd_procedimento in (4871,4847,4929) then 'Teleconsulta' else 'Presencial' end as tipo_atendimento,
	count(atd.nr_atendimento) as num_atendimentos
from 
	atendimento atd
	left join classificacao_atendimento ca on atd.cd_cla_atendimento = ca.cd_cla_atendimento 
	join empresa em on atd.empresa = em.empresa  
where 
	atd.cd_cbo like '2235%'
	and atd.status = 4
	and atd.dt_atendimento::date >= '2020-01-01'::date
	and em.cnpj = '82892282000143'
group by 1,2,3
order by 1,2