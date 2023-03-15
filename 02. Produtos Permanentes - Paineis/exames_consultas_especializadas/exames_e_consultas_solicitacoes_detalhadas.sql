with
    solicitacoes as  (
        select
            case
                when tp.ds_tp_procedimento like '%LABORAT%'
                    then 'GRUPO - EXAMES LABORATORIAIS'
                when tp.ds_tp_procedimento like '%FISIO%'
                    then 'CONSULTA EM FISIOTERAPIA'
                else replace(ltrim(tp.ds_tp_procedimento), 'SMS - ', '')
            end as nome_procedimento,
            ep.ds_procedimento as nome_procedimento_detalhado,
            em.descricao as unidade_solicitante,
            sa.dt_solicitacao::date as data_solicitacao,
            sa.tp_fila as tipo_fila,
            sa.tp_consulta as retorno_1a_cons,
            sa.status as status_solic,
            case
                when cr.descricao is null
                    or cr.descricao in ('Sem Classificação','Não Urgente')
                    then 'Não Urgente'
                else cr.descricao
                end as classificacao_risco,
            case
                when sa.status = 1
                    then current_date - sa.dt_cadastro::date
                end tempo_espera_todos_nao_agendados,
            sa.cd_solicitacao,
            sa.status
        from
            solicitacao_agendamento sa
            left join tipo_procedimento tp on sa.cd_tp_procedimento = tp.cd_tp_procedimento
            left join solicitacao_agendamento_exame sae on sa.cd_solicitacao = sae.cd_solicitacao
            left join exame_procedimento ep on sae.cd_exame_procedimento = ep.cd_exame_procedimento
            left join procedimento pc on tp.cd_procedimento = pc.cd_procedimento
            left join tipo_procedimento_cla tc on tp.cd_tp_pro_cla = tc.cd_tp_pro_cla
            left join empresa em on sa.unidade = em.empresa
            left join classificacao_risco cr on sa.classificacao_risco = cr.cd_classificacao_risco
        where
            sa.status = 1 -- RETIRAR AS SOLICITAÇÕES CANCELADAS
            and tp.ds_tp_procedimento like 'SMS%' -- APENAS PROCEDIMENTOS DAS FILAS DA SMS, FILTRADAS PELOS NOMES
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
				334085,		--SMS - CONSULTA ODONTO PCTE NECESSIDADES ESPECIAIS
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
            and sa.dt_solicitacao < current_date --EXCLUI HOJE DA CONTAGEM
	   -- and sa.dt_solicitacao::date >= (current_date - interval '180 days')::date
	    
    ),
    table_calc_solic as (
        select
            date_trunc('month', data_solicitacao)::date as competencia,
            slc.nome_procedimento,
            case
                when slc.nome_procedimento_detalhado is null
                    then slc.nome_procedimento
                else slc.nome_procedimento_detalhado
                end as nome_procedimento_detalhado,
            sum(case when data_solicitacao::date >= (current_date - interval '180 days')::date then 1 else 0 end) as quant_180_dias,
            sum(case when data_solicitacao::date >= (current_date - interval '30 days')::date then 1 else 0 end) as quant_30_dias,
            count(distinct(cd_solicitacao)) as quantidade
        from
            solicitacoes slc
        group by    
            1,2,3
    )
select
    'total_por_mes' as dado_analisado,
    competencia,
    nome_procedimento,
    nome_procedimento_detalhado,
    quant_30_dias,
    quant_180_dias,
    quantidade
from
    table_calc_solic
order by 
    1,2

;