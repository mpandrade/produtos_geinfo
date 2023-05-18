
with
    filas_procedimentos as ( 
        select distinct
            case
                when tp.ds_tp_procedimento like '%LABORAT%'
                    then 'GRUPO - EXAMES LABORATORIAIS'
                when tp.ds_tp_procedimento like '%FISIO%'
                    then 'CONSULTA EM FISIOTERAPIA'
                else replace(ltrim(tp.ds_tp_procedimento), 'SMS - ', '')
            end as nome_procedimento
        from
            tipo_procedimento tp
            left join tipo_procedimento_cla tpc on tp.cd_tp_pro_cla = tpc.cd_tp_pro_cla
            left join procedimento pc on tp.cd_procedimento = pc.cd_procedimento
        where
            tp.ds_tp_procedimento like 'SMS%'
            and tp.cd_tp_procedimento not in (
				373693003,	--SMS - AMBULATÓRIO TRANS - CONSULTA MÉDICA
				373357677,	--SMS - AMBULATÓRIO TRANS - PSICOLOGIA
				373692644,	--SMS - AMBULATÓRIO TRANS - SERVIÇO SOCIAL
				373693480,	--SMS - AMBULATÓRIO TRANS - TELECONSULTA MÉDICA
				109862259,	--SMS - CAPSULOTOMIA A YAG LASER
				294611221,	--SMS - CONSULTA EM ACUPUNTURA - POR SESSÃO
				310453674,	--SMS - CONSULTA EM ANESTESIOLOGISTA
				294610333,	--SMS - CONSULTA EM FONOAUDIOLOGIA - POR SESSÃO
				296934980,	--SMS - CONSULTA EM NEFROLOGIA - REVISÃO
				36428007,	--SMS - CONSULTA EM OFTALMOLOGIA - CATARATA - PÓS-OPERATÓRIO
				302421689,	--SMS - CONSULTA EM OFTALMOLOGIA - CÓRNEA
				302421830,	--SMS - CONSULTA EM OFTALMOLOGIA - ESTRABISMO
				302421910,	--SMS - CONSULTA EM OFTALMOLOGIA - PLÁSTICA OCULAR
				109868113,	--SMS - CONSULTA EM OFTALMOLOGIA - REFRAÇÃO
				302815756,	--SMS - CONSULTA EM OFTALMOLOGIA - RETORNO
				109871180,	--SMS - CONSULTA EM OFTALMOLOGIA PTERÍGIO - RETORNO
				369778826,	--SMS - CONSULTA EM PSICOLOGIA AMB INFANTIL - SESSÃO
				304517664,	--SMS - CONSULTA EM UROLOGIA TRANSPLANTE RENAL
				--334085,		--SMS - CONSULTA ODONTO PCTE NECESSIDADES ESPECIAIS
				379166031,	--SMS - CONSULTA PÓS TRANSPLANTE RENAL
				335481,		--SMS - CURATIVO GRAU II C/ OU S/ DEBRIDAMENTO
				437546570,	--SMS - GRUPO - CIRURGIAS OFTALMOLÓGICAS
				302423187,	--SMS - GRUPO - TOMOGRAFIA COMPUTADORIZADA - ONCOLOGIA
				384355444,	--SMS - HEMOGRAMA DENGUE/ARBOVIROSES
				331351965,	--SMS - TELECONSULTA - DERMATOLOGIA
				330027575,	--SMS - TELECONSULTA - PNEUMOLOGIA ADULTO
				399177348,	--SMS - TELECONSULTA EM FONOAUDIOLOGIA - POR SESSÃO
				332660485,	--SMS - TELECONSULTA EM GASTROENTEROLOGIA ADULTO
				334003382,	--SMS - TELECONSULTA EM INFECTOLOGIA - RETORNO
				388659206,	--SMS - TELECONSULTA EM PEDIATRIA
				331581142,	--SMS - TELECONSULTA EM NEUROLOGIA ADULTO
				342864050	--SMS - TRANSPORTE DE PACIENTE INTRADIÁRIO
				)
    ),
    vagas as (
        select
            nome_procedimento,
            sum(vagas_total) as vagas_total_180_dias,
            sum(case when data_atd >= (current_date - interval '30 days')::date then vagas_total else 0 end) as vagas_total_30_dias,
            sum (case when (select sum(case when extract (dow from generate_series) in (1,2,3,4,5) then 1 else 0 end) as soma                
                    from generate_series(dt_cadastro, data_atd, '1 day'::interval)) > 3 then vagas_total end) as vagas_uteis_180_dias,
            sum (case when (select sum(case when extract (dow from generate_series) in (1,2,3,4,5) then 1 else 0 end) as soma                
                    from generate_series(dt_cadastro, data_atd, '1 day'::interval)) > 3 and data_atd >= (current_date - interval '30 days')::date then vagas_total else 0 end) as vagas_uteis_30_dias,
            sum(vagas_agendadas) as vagas_agendadas_180_dias,
            sum(case when data_atd >= (current_date - interval '30 days')::date then vagas_agendadas else 0 end) as vagas_agendadas_30_dias,
            sum(faltas) as faltas_180_dias,
            sum(case when data_atd >= (current_date - interval '30 days')::date then faltas else 0 end) as faltas_30_dias
        from (
            select
                case
                    when tp.ds_tp_procedimento like '%LABORAT%'
                        then 'GRUPO - EXAMES LABORATORIAIS'
                    when tp.ds_tp_procedimento like '%FISIO%'
                        then 'CONSULTA EM FISIOTERAPIA'
                    else replace(ltrim(tp.ds_tp_procedimento), 'SMS - ', '')
                end as nome_procedimento,
                ag.cd_agenda,
                agr.cd_ag_grade,
                aga.cd_ag_gra_atendimento,
                agr.data as data_atd,
                ag.dt_cadastro::date as dt_cadastro,
                coalesce(aga.qtdade_atendimento,0) as vagas_total,
                coalesce(aga.qtdade_ate_bloqueado,0) as vagas_bloqueadas,
                sum(case when agh.status <> 3 then coalesce(agh.qt_vaga_ocupada,0) else 0 end) as vagas_agendadas,
                sum(case when agh.status = 4 or a1.status = 8 or a1.dt_atendimento is null then coalesce(agh.qt_vaga_ocupada,0) else 0 end) as faltas
            from
                agenda ag
                left join agenda_grade agr on ag.cd_agenda = agr.cd_agenda
                left join agenda_grade_atendimento aga on aga.cd_ag_grade = agr.cd_ag_grade
                left join tipo_atendimento_agenda taa on aga.cd_tipo = taa.cd_tipo
                left join agenda_gra_ate_horario agh on agh.cd_ag_gra_atendimento = aga.cd_ag_gra_atendimento
                left join tipo_procedimento tp on ag.cd_tp_procedimento = tp.cd_tp_procedimento
                left join procedimento pc on tp.cd_procedimento = pc.cd_procedimento
                left join tipo_procedimento_cla tc on tp.cd_tp_pro_cla = tc.cd_tp_pro_cla
                left join empresa em on ag.empresa = em.empresa
                left join atendimento a1 on agh.nr_atendimento = a1.nr_atendimento
            where
                (ag.status not in (3,6))
                -- MANTENDO OS CANCELADOS E OS INATIVADOS, CONFORME RELATORIO CELK
                /*and agh.dt_cancelamento is null
                and (ag.dt_inativacao is not null 
                    or ag.dt_inativacao::date > agr.data) */
                and em.cod_atv not in (2,70,73) -- NÃO PEGAR APS, UPAS E CAPS
                and taa.cd_tipo not in (36276366,286279789) -- FILTRO DO TIPO DE PROCEDIMENTO (RETIRA MATRICIAMETNO)
                and tp.ds_tp_procedimento like 'SMS%' -- APENAS PROCEDIMENTOS DAS FILAS DA SMS, FILTRADAS PELOS NOMES
                and ag.tp_agenda = 'C' -- AGENDA COMPARTILHADA (VISIVEL PELA REGULAÇÃO)
                and agr.data::date >= (current_date - interval '180 days')::date 
                and agr.data::date < current_date
            group by
                1,2,3,4,5,6,7,8
        ) t1
        group by 1
        order by 1,2
    ),
    solicitacoes as ( -- NESSE BLOCO VÃO TODAS AS SOLICITAÇÕES
        select
            --tc.ds_tp_pro_cla as tipo_procedimento,
            --tp.cd_tp_procedimento as id_procedimento,
            case
                when tp.ds_tp_procedimento like '%LABORAT%'
                    then 'GRUPO - EXAMES LABORATORIAIS'
                when tp.ds_tp_procedimento like '%FISIO%'
                    then 'CONSULTA EM FISIOTERAPIA'
                else replace(ltrim(tp.ds_tp_procedimento), 'SMS - ', '')
            end as nome_procedimento,
            --pc.referencia as cod_procedimento,
            em.descricao as unidade_solicitante,
            sa.dt_solicitacao::date as data_solicitacao,
            sa.tp_fila as tipo_fila,
            sa.tp_consulta as retorno_1a_cons,
            sa.status as status_solic,
            sa.dt_agendamento::date as data_agendamento,
            case
                when cr.descricao is null
                    or cr.descricao in ('Sem Classificação','Não Urgente')
                    then 'Não Urgente'
                else cr.descricao
                end as classificacao_risco,
            case
                when sa.dt_agendamento::date >= (current_date - interval '180 days')::date
                        and sa.dt_agendamento::date is not null
                    then sa.dt_agendamento::date - sa.dt_solicitacao::date
                    end as tempo_espera_dias,
            case
                when sa.status = 1
                    then current_date - sa.dt_solicitacao::date
                end tempo_espera_todos_nao_agendados,
            sa.cd_solicitacao,
            sa.status
        from
            solicitacao_agendamento sa
            left join tipo_procedimento tp on sa.cd_tp_procedimento = tp.cd_tp_procedimento
            left join procedimento pc on tp.cd_procedimento = pc.cd_procedimento
            left join tipo_procedimento_cla tc on tp.cd_tp_pro_cla = tc.cd_tp_pro_cla
            left join empresa em on sa.unidade = em.empresa
            left join profissional pro on sa.cd_profissional = pro.cd_profissional
            left join classificacao_risco cr on sa.classificacao_risco = cr.cd_classificacao_risco
        where
            sa.status <> 6 -- RETIRAR AS SOLICITAÇÕES CANCELADAS
            and tp.ds_tp_procedimento like 'SMS%'  -- APENAS PROCEDIMENTOS DAS FILAS DA SMS, FILTRADAS PELOS NOMES
            and sa.dt_solicitacao < current_date --EXCLUI HOJE DA CONTAGEM
	    --and sa.dt_solicitacao::date >= (current_date - interval '180 days')::date
            -- ABAIXO APENAS OS PROCEDIMENTOS QUE ESTÃO SENDO USADOS PELA REGULAÇÃO. PODE SER NECESSÁRIO ADAPTAÇÃO AO LONGO DO TEMPO
				and tp.cd_tp_procedimento not in (
				373693003,	--SMS - AMBULATÓRIO TRANS - CONSULTA MÉDICA
				373357677,	--SMS - AMBULATÓRIO TRANS - PSICOLOGIA
				373692644,	--SMS - AMBULATÓRIO TRANS - SERVIÇO SOCIAL
				373693480,	--SMS - AMBULATÓRIO TRANS - TELECONSULTA MÉDICA
				109862259,	--SMS - CAPSULOTOMIA A YAG LASER
				294611221,	--SMS - CONSULTA EM ACUPUNTURA - POR SESSÃO
				310453674,	--SMS - CONSULTA EM ANESTESIOLOGISTA
				294610333,	--SMS - CONSULTA EM FONOAUDIOLOGIA - POR SESSÃO
				296934980,	--SMS - CONSULTA EM NEFROLOGIA - REVISÃO
				36428007,	--SMS - CONSULTA EM OFTALMOLOGIA - CATARATA - PÓS-OPERATÓRIO
				302421689,	--SMS - CONSULTA EM OFTALMOLOGIA - CÓRNEA
				302421830,	--SMS - CONSULTA EM OFTALMOLOGIA - ESTRABISMO
				302421910,	--SMS - CONSULTA EM OFTALMOLOGIA - PLÁSTICA OCULAR
				109868113,	--SMS - CONSULTA EM OFTALMOLOGIA - REFRAÇÃO
				302815756,	--SMS - CONSULTA EM OFTALMOLOGIA - RETORNO
				109871180,	--SMS - CONSULTA EM OFTALMOLOGIA PTERÍGIO - RETORNO
				369778826,	--SMS - CONSULTA EM PSICOLOGIA AMB INFANTIL - SESSÃO
				304517664,	--SMS - CONSULTA EM UROLOGIA TRANSPLANTE RENAL
				--334085,		--SMS - CONSULTA ODONTO PCTE NECESSIDADES ESPECIAIS
				379166031,	--SMS - CONSULTA PÓS TRANSPLANTE RENAL
				335481,		--SMS - CURATIVO GRAU II C/ OU S/ DEBRIDAMENTO
				437546570,	--SMS - GRUPO - CIRURGIAS OFTALMOLÓGICAS
				302423187,	--SMS - GRUPO - TOMOGRAFIA COMPUTADORIZADA - ONCOLOGIA
				384355444,	--SMS - HEMOGRAMA DENGUE/ARBOVIROSES
				331351965,	--SMS - TELECONSULTA - DERMATOLOGIA
				330027575,	--SMS - TELECONSULTA - PNEUMOLOGIA ADULTO
				399177348,	--SMS - TELECONSULTA EM FONOAUDIOLOGIA - POR SESSÃO
				332660485,	--SMS - TELECONSULTA EM GASTROENTEROLOGIA ADULTO
				334003382,	--SMS - TELECONSULTA EM INFECTOLOGIA - RETORNO
				388659206,	--SMS - TELECONSULTA EM PEDIATRIA
				331581142,	--SMS - TELECONSULTA EM NEUROLOGIA ADULTO
				342864050	--SMS - TRANSPORTE DE PACIENTE INTRADIÁRIO
				)    
		),
    table_calc_solic as (
        select
            slc.nome_procedimento as nome_procedimento,
            sum(case when data_solicitacao >= (current_date - interval '30 days')::date then 1 else 0 end) as solic_total_ultimos_30_dias,
            sum(case when data_solicitacao >= (current_date - interval '180 days')::date then 1 else 0 end) as solic_total_ultimos_180_dias,
            sum(case when status_solic = 0 then 1 else 0 end) as solic_nao_reguladas,
            sum(case when status_solic = 1 then 1 else 0 end) as solic_reguladas_na_fila,
            sum(case when data_agendamento >= (current_date - interval '30 days') and status_solic = 2 then 1 else 0 end) as solic_agendadas_30_dias,
            sum(case when data_agendamento >= (current_date - interval '180 days') and status_solic = 2 then 1 else 0 end) as solic_agendadas_180_dias,
            sum(case when status_solic = 4 then 1 else 0 end) as solic_devolvidas,
            trunc(avg(tempo_espera_todos_nao_agendados)) as media_tempo_espera_todos_nao_agendados,
            percentile_cont(0.5) WITHIN GROUP (ORDER BY tempo_espera_todos_nao_agendados) as mediana_tempo_espera_todos_nao_agendados
        from
            solicitacoes slc
        group by    
            1--,2,3
    )
select
    fp.nome_procedimento,
    tc.solic_total_ultimos_30_dias,
    tc.solic_total_ultimos_180_dias,
    tc.solic_nao_reguladas,
    tc.solic_reguladas_na_fila,
    tc.solic_agendadas_30_dias,
    tc.solic_agendadas_180_dias,
    tc.solic_devolvidas,
    tc.media_tempo_espera_todos_nao_agendados, -- CALCULO (MÉDIA): DA DATA DE INSERÇÃO DA SOLICITAÇÃO MENOS O DIA DE HOJE PARA TODOS OS NÃO AGENDADAS
    tc.mediana_tempo_espera_todos_nao_agendados, -- CALCULO (MEDIANA): DA DATA DE INSERÇÃO DA SOLICITAÇÃO MENOS O DIA DE HOJE PARA TODOS OS NÃO AGENDADAS
    coalesce(vg.vagas_total_180_dias, 0)::int as vagas_total_180_dias, 
    coalesce(vg.vagas_total_30_dias, 0)::int as vagas_total_30_dias, 
    coalesce(vg.vagas_uteis_180_dias, 0)::int as vagas_uteis_180_dias, 
    coalesce(vg.vagas_uteis_30_dias, 0)::int as vagas_uteis_30_dias, 
    coalesce(vg.vagas_agendadas_180_dias, 0)::int as vagas_agendadas_180_dias, 
    coalesce(vg.vagas_agendadas_30_dias, 0)::int as vagas_agendadas_30_dias, 
    coalesce(vg.faltas_180_dias, 0)::int as faltas_180_dias,
    coalesce(vg.faltas_30_dias, 0)::int as faltas_30_dias
from
    filas_procedimentos fp
    left join table_calc_solic tc on fp.nome_procedimento = tc.nome_procedimento
    left join vagas vg on fp.nome_procedimento = vg.nome_procedimento
;