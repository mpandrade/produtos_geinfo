-- QUERY PARA ALIMENTAR O PAINEL DA ODONTOLOGIA
with
    table_lotacao as ( -- CTE DA LOTAÇÃO PROFISSIONAL NAS EQUIPES DE SAÚDE BUCAL
        select
            ep.cd_profissional,
            eqp.empresa,
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
    table_procs as (
        select
            t1.cd_profissional,
            t1.empresa,
            t1.mes_ano,
            sum(t1.qnt_exodontia) as qnt_exodontia,
            sum(t1.prim_cons_prog) as prim_cons_prog,
            sum(t1.qnt_urgencia) as qnt_urgencia,
            sum(t1.qnt_completo) as qnt_completo,
            sum(t1.qnt_procedimentos) as qnt_procedimentos
        from (

            -- CONTABILIZA PROCEDIMENTOS SELECIONADOS POR MES
            select
                icp.cd_profissional,
                icp.empresa_faturamento as empresa,
                date_trunc('month', icp.data_lancamento)::date as mes_ano,
                sum(case when icp.cd_procedimento in (3351,3352,3353,4901) then icp.quantidade end) as qnt_exodontia,
                0 as prim_cons_prog,
                max(case when icp.cd_procedimento in (1219,1222) then 1 else 0 end) as qnt_urgencia,
                0 as qnt_completo,
                sum(case when icp.cd_procedimento not in (1219,1161,4753,4755,1222) then icp.quantidade end) as qnt_procedimentos
            from
                item_conta_paciente icp
                join empresa e1 on icp.empresa_faturamento = e1.empresa
            where
                date_trunc('month', icp.data_lancamento)::date = date_trunc('month', current_date - '1 month'::interval)::date
                --date_trunc('month', icp.data_lancamento)::date between '2020-01-01'::date and '2022-01-31'::date
                and icp.cd_cbo like '2232%'
                and icp.cd_procedimento not in ('4745','1161','4753','4755','1152','1158','1149','1155')
                and e1.cod_atv = 2
            group by 1,2,3

            union all

            -- CONTABILIZA AS PRIMEIRAS CONSULTAS A PARTIR DA DATA DE ABERTURA DA FICHA ODONTOLÓGICA
            select
                a1.cd_profissional,
                a1.empresa,
                date_trunc('month', dt_inicio_tratamento)::date as mes_ano,
                0 as qnt_exodontia,
                1 as prim_cons_prog,
                0 as qnt_urgencia,
                0 as qnt_completo,
                0 as qnt_procedimentos
            from 
                atendimento_odonto_ficha af
                join atendimento a1 on af.nr_atendimento = a1.nr_atendimento
                join empresa e1 on a1.empresa = e1.empresa
            where
                date_trunc('month', dt_inicio_tratamento)::date = date_trunc('month', current_date - '1 month'::interval)::date
                --date_trunc('month', dt_inicio_tratamento)::date between '2020-01-01'::date and '2022-01-31'::date
                and e1.cod_atv = 2
            
            union all

            -- CONTABILIZA AS PRIMEIRAS CONSULTAS A PARTIR DA DATA DE FECHAEMNTO DA FICHA ODONTOLÓGICA
            select
                a1.cd_profissional,
                a1.empresa,
                date_trunc('month', dt_conclusao)::date as mes_ano,
                0 as qnt_exodontia,
                0 as prim_cons_prog,
                0 as qnt_urgencia,
                1 as qnt_completo,
                0 as qnt_procedimentos
            from 
                atendimento_odonto_ficha af
                join atendimento a1 on af.nr_atendimento = a1.nr_atendimento
                join empresa e1 on a1.empresa = e1.empresa
            where
                date_trunc('month', dt_conclusao)::date = date_trunc('month', current_date - '1 month'::interval)::date
                --date_trunc('month', dt_conclusao)::date between '2020-01-01'::date and '2022-01-31'::date
                and e1.cod_atv = 2
        ) t1
        group by
            1,2,3
    ),
    table_encs as ( -- CTE PARA CONTABILIZAR OS ENCAMINHAMENTOS
        select
            cd_profissional,
            empresa,
            mes_ano,
            count(*) as qnt_encaminhamento
        from (
            select 
                emc.cd_profissional,
                emc.empresa,
                date_trunc('month', emc.dt_cadastro)::date as mes_ano
            from 
                encaminhamento emc
                left join tipo_encaminhamento te on te.cd_tp_encaminhamento = emc.cd_tp_encaminhamento
                left join empresa e1 on emc.empresa = e1.empresa
            where 
                te.cd_tp_encaminhamento in ('289182519','253147742','337714','334278','334281','334283','4142439','303490707','334282','334279','4414100','4414102','334277')
                --and date_trunc('month', emc.dt_cadastro)::date between '2020-01-01'::date and '2022-01-31'::date
                and date_trunc('month', emc.dt_cadastro)::date = date_trunc('month', current_date - '1 month'::interval)::date
                and e1.cod_atv = 2
        ) t1
        group by
            1,2,3
    ),
    table_atend as ( -- CTE PARA CONTABILIZAR ATENDIMENTOS
        select
            cd_profissional,
            empresa,
            mes_ano,
            sum(
                case
                    when agend_espont = 'espontanea'
                        then 1
                    else 0
                end
            ) as cons_espontanea,
            sum(
                case
                    when agend_espont = 'agendada'
                        then 1
                    else 0
                end
            ) as cons_agendada,
            count(*) as consultas
        from (
            select
                a1.cd_profissional,
                a1.empresa,
                date_trunc('month', a1.dt_atendimento)::date as  mes_ano,
                case
                    when agd.dt_cadastro < a1.dt_atendimento
                        then 'agendada'
                    else 'espontanea'
                end as agend_espont,
                a1.nr_atendimento as id_atendimento,
                agd.dt_cadastro::date as dt_cadastro,
                a1.dt_atendimento::date as dt_atendimento
            from
                atendimento a1
                left join agenda_gra_ate_horario agd on agd.nr_atendimento = a1.nr_atendimento 
                join empresa e1 on a1.empresa = e1.empresa
            where
                a1.status = 4
                and date_trunc('month', a1.dt_atendimento)::date = date_trunc('month', current_date - '1 month'::interval)::date
                --and date_trunc('month', a1.dt_atendimento)::date between '2020-01-01'::date and '2022-01-31'::date
                and a1.cd_cbo like '2232%'
                and e1.cod_atv = 2
        ) t1
        group by
            1,2,3
    ),
    table_results as ( -- JUNTA TUDO
        select
            ta.mes_ano,
            eed.descricao as distrito,
            e1.descricao as unidade,
            coalesce(tl.equipe::text, 'SEM EQUIPE') as equipe,
            pf.nm_profissional,
            coalesce(ta.cons_espontanea, 0) cons_espontanea,
            coalesce(ta.cons_agendada, 0) cons_agendada,
            coalesce(ta.consultas, 0) as consultas,
            coalesce(tp.prim_cons_prog, 0) as qnt_prim_cons,
            coalesce(tp.qnt_urgencia, 0) as qnt_urge,
            coalesce(tp.qnt_completo, 0) as qnt_tto_comp,
            coalesce(tp.qnt_procedimentos, 0) as qnt_proced,
            coalesce(tp.qnt_exodontia, 0) as qnt_exodontia,
            coalesce(te.qnt_encaminhamento, 0) as qnt_encam
        from 
            table_atend ta
            left join table_encs te on ta.mes_ano = te.mes_ano
                and ta.empresa = te.empresa
                and ta.cd_profissional = te.cd_profissional
            left join table_procs tp on ta.mes_ano = tp.mes_ano
                and ta.empresa = tp.empresa
                and ta.cd_profissional = tp.cd_profissional
            left join table_lotacao tl on ta.cd_profissional = tl.cd_profissional
                and ta.empresa = tl.empresa
                and ta.mes_ano between tl.dt_entrada and tl.dt_desligamento
            join empresa e1 on ta.empresa = e1.empresa
            left join end_estruturado_distrito eed on e1.cd_end_estruturado_distrito = eed.cd_end_estruturado_distrito
            join profissional pf on ta.cd_profissional = pf.cd_profissional
    )
select
    *
from
    table_results

union all

-- CRIA RESULTADOS PARA O DISTRITO PARA PODER EXIBIR JUNTO COM AS UNIDADES NO PAINEL
select
    mes_ano,
    distrito,
    concat('DISTRITO - ',distrito) as unidade,
    concat('DISTRITO - ',distrito) as equipe,
    concat('DISTRITO - ',distrito) as profissional,
    sum(cons_espontanea) cons_espontanea,
    sum(cons_agendada) cons_agendada,
    sum(consultas) as consultas,
    sum(qnt_prim_cons) as qnt_prim_cons,
    sum(qnt_urge) as qnt_urge,
    sum(qnt_tto_comp) as qnt_tto_comp,
    sum(qnt_proced) as qnt_proced,
    sum(qnt_exodontia) as qnt_exodontia,
    sum(qnt_encam) as qnt_encam
from
    table_results
group by
    1,2,3,4,5

union all

-- CRIA RESULTADOS PARA TODA A APS PARA PODER EXIBIR JUNTO COM AS UNIDADES NO PAINEL
select
    mes_ano,
    'TODA APS' as distrito,
    'TODA APS' as unidade,
    'TODA APS' as equipe,
    'TODA APS' as profissional,
    sum(cons_espontanea) cons_espontanea,
    sum(cons_agendada) cons_agendada,
    sum(consultas) as consultas,
    sum(qnt_prim_cons) as qnt_prim_cons,
    sum(qnt_urge) as qnt_urge,
    sum(qnt_tto_comp) as qnt_tto_comp,
    sum(qnt_proced) as qnt_proced,
    sum(qnt_exodontia) as qnt_exodontia,
    sum(qnt_encam) as qnt_encam
from
    table_results
group by
    1,2,3,4,5