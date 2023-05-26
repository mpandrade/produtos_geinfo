select 
	em.descricao as unidade,
	to_char(atd.dt_atendimento, 'MM/YYYY') as mes_ano,
	count(atd.nr_atendimento) as n_atendim_psiquiatra
from 
	atendimento atd 
	join empresa em on atd.empresa = em.empresa 
where 
	atd.cd_cbo = '225133'
	and atd.dt_atendimento::date between '2022-01-01'::date and '2023-04-30'::date
	and atd.status = 4
group by 1,2
order by 1,2
