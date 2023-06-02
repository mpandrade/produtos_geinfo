
-- ATENDIMENTOS

select
	em.descricao,
	count(*) as quant
from 
	atendimento atd 
	join empresa em on em.empresa = atd.empresa
where 
	atd.dt_atendimento::date between '2023-01-01'::date and '2023-01-31'::date
	and atd.status = 4 -- Finalizados
	and em.cod_atv = 2 -- APS
group by 1
order by 1


--------------------------------------------------------------------------------

-- APLICAÇÕES DE VACINA

select 
	em.descricao as unidade,
	count(*) as quant
from
    vac_aplicacao va
    join empresa em on va.empresa = em.empresa
    join tipo_vacina tv on tv.cd_vacina = va.cd_vacina
where
    va.dt_aplicacao::date between '2023-01-01'::date and '2023-01-31'::date
    and tv.tipo_esus in (85, 86, 87, 88) -- Covid
    and va.flag_historico = 0 -- Seleciona somente vacinas aplicadas na rede
group by 1
order by 1

--------------------------------------------------------------------------------

-- DISPENSAÇÕES DE MEDICAMENTO

select 
	em.descricao as unidade,
	count(*) as quant
from
    dispensacao_medicamento dm    
    join empresa em on em.empresa = dm.empresa
where
 	dt_dispensacao::date between '2023-01-01'::date and '2023-01-31'::date
group by 1
order by 1
