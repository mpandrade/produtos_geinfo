with
    devolvidos as (
        select
            sa.cd_solicitacao as nr_solicitacao,
            tc.ds_tp_pro_cla as tipo_procedimento,
            tp.ds_tp_procedimento as nome_procedimento,
            em2.descricao as unidade_origem_pedido,
            em.descricao as unidade_solicitante,
            case
                when em.cnpj = '82892282000143'
                    then 'propria'
                else 'externa'
            end as unidade_propria,
            first_value(eqpf.equipe) over (
                partition by sa.cd_solicitacao 
                order by case when eqpf.equipe is not null then 0 else 1 end + 
                    case when eqpf.dt_desligamento is not null then 0 else 1 end asc, 
                    eqpf.dt_entrada rows between unbounded preceding and unbounded following) as equipe_solicitante,
            first_value(pch.cd_cbo) over (
                partition by sa.cd_solicitacao 
                order by case when pch.dt_desativacao is not null then 0 else 1 end asc, 
                eqpf.dt_entrada rows between unbounded preceding and unbounded following) as cbo_pch,
            a1.cd_cbo as cbo_atd,
            coalesce(pro.nm_profissional, sa.nm_profissional_origem||' (EXTERNO)') as profissional_solicitante,
            sa.dt_cadastro::date as data_solicitacao,
            sa.dt_autorizador::date as data_regulacao,
            usu.nm_usuario as regulador,
            case
                when sa.tp_consulta = 0 then '1a_vez'
                when sa.tp_consulta = 1 then 'retorno'
                end as retorno_1a_cons,
            case
                when cr.descricao is null then 'Sem classificacao'
                else cr.descricao
                end as classificacao_risco,
            sa.cd_usu_cadsus
        from
            solicitacao_agendamento sa
            left join atendimento a1 on sa.nr_atendimento_origem = a1.nr_atendimento
            left join tipo_procedimento tp on sa.cd_tp_procedimento = tp.cd_tp_procedimento
            left join procedimento pc on tp.cd_procedimento = pc.cd_procedimento
            left join tipo_procedimento_cla tc on tp.cd_tp_pro_cla = tc.cd_tp_pro_cla
            left join empresa em on sa.unidade = em.empresa
            left join empresa em2 on sa.empresa_origem = em2.empresa
            left join usuarios usu on sa.cd_usu_autorizador = usu.cd_usuario
            left join classificacao_risco cr on sa.classificacao_risco = cr.cd_classificacao_risco
            left join profissional pro on sa.cd_profissional = pro.cd_profissional
            left join (
                select
                    eqp.cd_profissional,
                    em.descricao,
                    eqa.cd_area as equipe,
                    eqp.dt_entrada,
                    eqp.dt_desligamento
                from equipe_profissional eqp
                    left join equipe eq on eqp.cd_equipe = eq.cd_equipe
                    left join empresa em on eq.empresa = em.empresa
                    left join equipe_area eqa on eq.cd_equipe_area = eqa.cd_equipe_area
            ) eqpf on pro.cd_profissional = eqpf.cd_profissional
                and eqpf.dt_entrada <= sa.dt_solicitacao::date
                and (eqpf.dt_desligamento >= sa.dt_solicitacao::date or eqpf.dt_desligamento is null)
                and em.descricao = eqpf.descricao
            left join profissional_carga_horaria pch on pro.cd_profissional = pch.cd_profissional
                and sa.dt_solicitacao >= pch.dt_ativacao
                and (sa.dt_solicitacao <= pch.dt_desativacao or pch.dt_desativacao is null)
                and em.empresa = pch.empresa
        where
            date_trunc('month', sa.dt_cadastro)::date <= date_trunc('month', current_date - interval '1 month')::date
            and sa.status = 4
            and sa.tp_fila = 2
    ),
    devolvidos_c_referencia as (
        select
            dev.*,
            uc.nm_usuario,
            uc.dt_nascimento,
            uc.nm_mae,
            uc.cd_usu_cadsus,
            coalesce(em_lst.descricao, em_terr.descricao, first_value(em_atd.descricao) over (partition by uc.cd_usu_cadsus order by a1.dt_atendimento desc)) as unidade_referencia,
            coalesce(ea_lst.cd_area, ea_terr.cd_area, first_value(eqap_atd.cd_area) over (partition by uc.cd_usu_cadsus order by a1.dt_atendimento desc)) as equipe_referencia
        from
            devolvidos dev
            left join usuario_cadsus uc on dev.cd_usu_cadsus = uc.cd_usu_cadsus
            left join endereco_usuario_cadsus euc on euc.cd_endereco = uc.cd_endereco
            left join tipo_logradouro_cadsus tlc on tlc.cd_tipo_logradouro = euc.cd_tipo_logradouro
            left join cidade c on c.cod_cid = euc.cod_cid
            -- endereco estruturado
            left join endereco_estruturado ee on ee.cd_endereco_estruturado = euc.cd_endereco_estruturado
            left join equipe_micro_area ema on ema.cd_eqp_micro_area = ee.cd_eqp_micro_area
            left join equipe e_terr on e_terr.cd_equipe_area = ema.cd_equipe_area
                and e_terr.cd_tp_equipe in ('70','76')
            left join equipe_area ea_terr on ea_terr.cd_equipe_area = e_terr.cd_equipe_area
            left join empresa em_terr on em_terr.empresa = e_terr.empresa
                and em_terr.cod_atv in (1,2,4,70,73)
                and em_terr.cnpj = '82892282000143'
            -- equipe lista
            left join equipe e_lst on e_lst.cd_equipe_area = uc.cd_equipe
                and e_lst.cd_tp_equipe in ('70','76')
            left join equipe_area ea_lst on ea_lst.cd_equipe_area = e_lst.cd_equipe_area
            left join empresa em_lst on em_lst.empresa = e_lst.empresa
                and em_lst.cod_atv in (1,2,4,70,73)
                and em_lst.cnpj = '82892282000143'
            -- atendimento
            left join atendimento a1 on a1.cd_usu_cadsus = uc.cd_usu_cadsus
                and a1.dt_atendimento::date >= date_trunc('month', current_date - interval '2 years')
                and a1.cd_cbo similar to '(225|2231|2235)%'
            left join empresa em_atd on a1.empresa = em_atd.empresa
                and em_atd.cod_atv in (1,2,4,70,73)
                and em_atd.cnpj = '82892282000143'
            left join equipe_profissional e_atd on e_atd.cd_profissional = a1.cd_profissional
                and e_atd.dt_entrada <= a1.dt_atendimento
                and (e_atd.dt_desligamento is null or e_atd.dt_desligamento >= a1.dt_atendimento)
            left join equipe eqp_atd on eqp_atd.cd_equipe = e_atd.cd_equipe 
                and eqp_atd.empresa = a1.empresa
                and eqp_atd.cd_tp_equipe in ('70','76')
            left join equipe_area eqap_atd on eqap_atd.cd_equipe_area = eqp_atd.cd_equipe_area
    ),
    analise_unidade_referencia as (
        select
            distinct
            nr_solicitacao,
            --tipo_procedimento,
            nome_procedimento,
            data_solicitacao,
            data_regulacao,
            regulador,
            --retorno_1a_cons,
            classificacao_risco,
            unidade_propria,
            upper(unidade_origem_pedido) as unidade_origem_pedido,
            upper(unidade_solicitante) as unidade_solicitante,
            coalesce(equipe_solicitante::text, 'Sem equipe') as equipe_solicitante,
            upper(unidade_referencia) as unidade_referencia,
            coalesce(equipe_referencia::text, 'Sem equipe') as equipe_referencia,
            upper(profissional_solicitante) as profissional_solicitante,
            case
                when unidade_solicitante like 'POLICLINICA MUNICIPAL%' 
                    and unidade_propria = 'propria'
                    then unidade_referencia
                when unidade_propria = 'externa'
                    then unidade_referencia
                when unidade_solicitante like 'CS%' 
                    and unidade_referencia like 'CS%'
                    and unidade_solicitante <> unidade_referencia
                    and equipe_referencia is not null
                    then unidade_referencia
                else unidade_solicitante
                end as unidade_responsavel_solicitacao,
            case
                when unidade_solicitante like 'POLICLINICA MUNICIPAL%' and unidade_propria = 'propria'
                    then equipe_referencia
                when unidade_propria = 'externa'
                    then equipe_referencia
                when unidade_solicitante like 'CS%' 
                    and unidade_referencia like 'CS%'
                    and unidade_solicitante <> unidade_referencia
                    and equipe_referencia is not null
                    then equipe_referencia
                when unidade_solicitante like 'CS%' 
                    and unidade_referencia like 'CS%'
                    and unidade_solicitante = unidade_referencia
                    and equipe_referencia is not null
                    then equipe_referencia
                else equipe_solicitante
                end as equipe_responsavel_solicitacao,
            --coalesce(cbo_atd, cbo_pch) as cbo,
            case 
                when coalesce(cbo_atd, cbo_pch) similar to '(225|2231)%' then 'Medico'
                when coalesce(cbo_atd, cbo_pch) like '2235%' then 'Enfermeiro'
                when coalesce(cbo_atd, cbo_pch) like '2232%' then 'Odonto'
                when coalesce(cbo_atd, cbo_pch) like '3222%' then 'Tec_enf'
                when coalesce(cbo_atd, cbo_pch) like '3224%' then 'Tec_odonto'
                when coalesce(cbo_atd, cbo_pch) = '223710' then 'Nutricionista'
                when coalesce(cbo_atd, cbo_pch) = '221510' then 'Psicologo'
                when coalesce(cbo_atd, cbo_pch) = '251605' then 'Assistente Social'
                when coalesce(cbo_atd, cbo_pch) like '2241%' then 'Prof. Educacao Fisica'
                when coalesce(cbo_atd, cbo_pch) like '2234%' then 'Farmaceutico'
                when coalesce(cbo_atd, cbo_pch) like '2236%' then 'Fisioterapeuta'
                when coalesce(cbo_atd, cbo_pch) = '515105' then 'ACS'
                when coalesce(cbo_atd, cbo_pch) = '515140' then 'ACE'
                else 'Outros' end as profissao_resumida
        from
            devolvidos_c_referencia
    )
select
    nr_solicitacao,
    --tipo_procedimento,
    nome_procedimento,
    data_solicitacao,
    data_regulacao,
    regulador,
    --retorno_1a_cons,
    classificacao_risco,
    unidade_propria,
    unidade_origem_pedido,
    unidade_solicitante,
    equipe_solicitante,
    coalesce(unidade_referencia, 'SEM UNIDADE DE REFERENCIA') as unidade_referencia,
    coalesce(equipe_referencia, 'SEM EQUIPE DE REFERENCIA') as equipe_referencia,
    profissional_solicitante,
    --coalesce(cbo_atd, cbo_pch) as cbo,
    profissao_resumida,
    coalesce(unidade_responsavel_solicitacao,'SEM UNIDADE DE REFERENCIA') as unidade_responsavel_solicitacao,
    coalesce(equipe_responsavel_solicitacao::text, 'SEM EQUIPE DE REFERENCIA') as equipe_responsavel_solicitacao
from
    analise_unidade_referencia
;
