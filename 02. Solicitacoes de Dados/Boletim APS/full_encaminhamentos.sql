select 
	a.cd_usu_cadsus,
	a.dt_chegada::date as dt_chegada,
    em.empresa,
    count(distinct en.cd_encaminhamento) as qt_encaminhamentos
from 
	atendimento a 
	join empresa em on em.empresa = a.empresa
	join encaminhamento en on en.nr_atendimento = a.nr_atendimento
where 
	a.dt_atendimento >= date_trunc('month', current_date) - interval '1 year'
	and a.dt_atendimento  < date_trunc('month', current_date)
	and a.status = 4 -- Finalizados
	and em.cod_atv = 2
group by 1, 2, 3