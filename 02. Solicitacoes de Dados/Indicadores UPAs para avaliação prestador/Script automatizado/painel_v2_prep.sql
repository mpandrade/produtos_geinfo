select 
    date_trunc('month', dm.dt_dispensacao) as mes_referencia,
    em.descricao as unidade,
    count(distinct dm.nr_dispensacao) as dispensacoes
from 
    dispensacao_medicamento dm
    join dispensacao_medicamento_item dmi on dmi.nr_dispensacao = dm.nr_dispensacao 
    join produtos p on p.cod_pro = dmi.cod_pro 
    join empresa em on dm.empresa = em.empresa 
where
    em.empresa in (259033,4272619,259035)
    and dm.dt_dispensacao::date between date_trunc('month', current_date) - interval '1 year'
        and date_trunc('month', current_date) - interval '1 day'
    and dmi.cod_pro in ('3446', '3655')
group by 1, 2