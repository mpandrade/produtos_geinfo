WITH
    atd_base as (select
            atd.cd_usu_cadsus,
            atd.dt_chegada,
            atd.dt_fechamento,
            atd.cd_usu_cadsus::varchar || atd.dt_chegada::date as id_atendimento,
            atd.cd_profissional,
            e.descricao as unidade,
            e.cod_atv,
            count(distinct en.cd_encaminhamento) as qt_encaminhamentos
        from
            atendimento atd
            join empresa e on e.empresa = atd.empresa
            left join encaminhamento en on en.nr_atendimento = atd.nr_atendimento
            left join tipo_encaminhamento te on te.cd_tp_encaminhamento = en.cd_tp_encaminhamento
        where 
            atd.dt_chegada >= date_trunc('month', current_date) - interval '1 year'
            and atd.dt_chegada < date_trunc('month', current_date)
            and atd.status = 4 -- Finalizados
            and e.cod_atv in (2, 73)
            and atd.cd_cbo similar to '(225|2231)%'
        group by 1, 2, 3, 4, 5, 6, 7),
    atd_rich as (SELECT
            unidade,
            cd_profissional,
            cd_usu_cadsus,
            id_atendimento,
            dt_chegada,
            dt_fechamento,
            qt_encaminhamentos,
            lead(dt_chegada) over (partition by cd_usu_cadsus order by dt_chegada) as dt_atendimento_next,
            lead(cod_atv) over (partition by cd_usu_cadsus order by dt_chegada) as cod_atv_next
        FROM
            atd_base ab
        WHERE
        	cod_atv = 2),
    atd_agg as (SELECT
		    unidade,
		    cd_profissional,
		    date_trunc('month', dt_chegada) as mes,
		    count(distinct id_atendimento) as consultas,
		    count(distinct case
		        when (dt_atendimento_next <= dt_fechamento + interval '72 hours' AND cod_atv_next = 73)
		            or qt_encaminhamentos > 0 then id_atendimento end) as consultas_nr
		from
		    atd_rich
		group by 1, 2, 3)
select
	*
from
	atd_agg