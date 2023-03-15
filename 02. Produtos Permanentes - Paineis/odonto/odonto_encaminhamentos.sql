-- QUERY PARA PEGAR OS ENCAMINHAMENTOS DA ODONTO

with
    table_lotacao as ( -- CTE DA LOTAÇÃO PROFISSIONAL NAS EQUIPES DE SAÚDE BUCAL
        select
            ep.cd_profissional,
            eqp.empresa,
            e1.descricao as  unidade,
            ep.dt_entrada::date as dt_entrada,
            to_date(coalesce(ep.dt_desligamento::text, current_date::text), 'yyyy-mm-dd')::date as dt_desligamento,
            eqap.cd_area::int as equipe
        from
            equipe_profissional ep
            join equipe eqp on eqp.cd_equipe = ep.cd_equipe 
            join empresa e1 on eqp.empresa = e1.empresa
            join equipe_area eqap on eqap.cd_equipe_area = eqp.cd_equipe_area
        where
            eqp.cd_tp_equipe in ('02','03','10','11','13','15','19','20','21','25','26','28','29','31','32','34','35','37','38','39','43','44','71')
            and e1.cod_atv = 2
    ),
    table_encs as ( -- CTE PARA CONTABILIZAR OS ENCAMINHAMENTOS
        select
            cd_profissional,
            empresa,
            unidade,
            distrito,
            mes_ano,
            especialidade,
            count(*) as qnt_encaminhamento
        from (
            select 
                emc.cd_profissional,
                emc.empresa,
                e1.descricao  as unidade,
                eed.descricao as distrito,
                upper(te.ds_encaminhamento) as especialidade,
                date_trunc('month', emc.dt_cadastro)::date as mes_ano
            from 
                encaminhamento emc
                left join tipo_encaminhamento te on te.cd_tp_encaminhamento = emc.cd_tp_encaminhamento
                left join empresa e1 on emc.empresa = e1.empresa
                left join end_estruturado_distrito eed on e1.cd_end_estruturado_distrito = eed.cd_end_estruturado_distrito
            where 
                te.cd_tp_encaminhamento in ('289182519','253147742','337714','334278','334281','334283','4142439','303490707','334282','334279','4414100','4414102','334277')
                --and date_trunc('month', emc.dt_cadastro)::date between '2020-01-01'::date and '2022-01-31'::date
                and date_trunc('month', emc.dt_cadastro)::date = date_trunc('month', current_date - '1 month'::interval)::date
                and e1.cod_atv = 2
        ) t1
        group by
            1,2,3,4,5,6
    )
select
    te.mes_ano,
    te.distrito,
    te.unidade,
    coalesce(tl.equipe::text, 'SEM EQUIPE') as equipe,
    upper(pro.nm_profissional) as profissional,
    te.especialidade,
    te.qnt_encaminhamento
from
    table_encs te
    left join table_lotacao tl on te.cd_profissional = tl.cd_profissional
        and tl.empresa = te.empresa
        and te.mes_ano between tl.dt_entrada and tl.dt_desligamento 
    left join profissional pro on te.cd_profissional = pro.cd_profissional
order by
    5,1,2,3,4