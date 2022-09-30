with        -- TODAS as CTES PRECISAM DE REVISÃO
	tcv as (
        select
            'ex' || e.cd_exame::text as cd_teste,
            e.cd_usu_cadsus,
            max(case when rer.id_tag = 'CONJUNTO' then upper(rer.resultado_individual) end) as tp_teste,
            rer.dt_resultado::date as dt_teste,
            max(case when rer.id_tag = 'FINAL' then upper(rer.resultado_individual) end) as de_resultado,
            null as lote,
            null as fabricante,
            null as fabricante_codigo
        from 
            exame e
            join exame_requisicao er on er.cd_exame = e.cd_exame 
            join resultado_exame_requisicao rer on rer.cd_exame_requisicao = er.cd_exame_requisicao 
        where 
            er.cd_exame_procedimento = 319259548
            and er.status = 1
        group by 1, 2, 4
        union
        select 
            'ee' || ee.cd_exame_externo::text as cd_teste,
            ee.cd_usu_cadsus,
            'VÍRUS RESPIRATÓRIOS RT-PCR EM TEMPO REAL' as tp_teste,
            ee.dt_exame::date as dt_teste,
            case when ds_resultado ilike 'detect%vel' then '1' 
                when ds_resultado ilike 'inconclusivo' then '3'
                else '2' end as de_resultado,
            null as lote,
            null as fabricante,
            null as fabricante_codigo   
        from 
            exame_externo ee 
        where 
            upper(ee.ds_exame) like '%V%RUS RESPIRAT%RIOS%PCR%'
        union
        select distinct
            'tr' || trr.cd_teste_rapido_realizado::text as cd_teste,
            a1.cd_usu_cadsus,
            case when lower(trc.fabricante) similar to '%won%f%|leading%poct%'
                then 'WONDFO'
                else upper(trc.fabricante) end || ' - ' ||
            case when lower(trc.fabricante) similar to '%won%f%|leading%poct%'
                then 'SARS-CoV-2 Antibody Test (Lateral Flow Method)'
                else trc.nm_conjunto end as tp_teste,
            a1.dt_atendimento::date as dt_teste,
            case
                when trr.resultado = 1 then '1'
                when trr.resultado = 2 then '2' end as de_resultado,
            trr.lote as lote,
            trc.fabricante,
            case 
                when upper(trc.fabricante) similar to '%WON%|NÃO%|LEADING%' then '6' 
                when upper(trc.fabricante) like 'WAMA%' then  '175'
                when upper(trc.fabricante) like 'WATMIND%' then '190' 
                when upper(trc.fabricante) similar to 'SHENZHEN%|SHENZEN%' then '484' 
                when upper(trc.fabricante) like '%BASALL%' then '51' 
                when upper(trc.fabricante) like 'ECO%' then '359'
                when upper(trc.fabricante) like '%LMG%' then '129' else '6' end as fabricante_codigo   
        from 
            teste_rapido_realizado trr 
            join teste_rapido tr on tr.cd_teste_rapido = trr.cd_teste_rapido 
            join atendimento a1 on a1.nr_atendimento = tr.nr_atendimento 
            left join teste_rapido_conjunto trc on trr.cd_tr_conjunto = trc.cd_tr_conjunto 
            join teste_rapido_tipo trt on trt.cd_tp_teste = trr.cd_tp_teste 
        where 
            trr.status = 2
            and trt.tp_teste = 5
            and trc.fabricante is not null
            and upper(trc.fabricante) not in ('X', 'TESTE')
        union
        select distinct
            'eec' || cd_exame_externo_covid as cd_teste,
            eec.cd_usu_cadsus,
            eec.descricao_exame as tp_teste,
            date_trunc('day', eec.data_exame) as dt_teste,
            case
                when eec.resultado = 'POSITIVO' then 'REAGENTE'
                when eec.resultado = 'NEGATIVO' then 'NÃO REAGENTE' end as de_resultado,
           null as lote,
           null as fabricante,
           null as fabricante_codigo
        from
            exame_externo_covid eec
    ),
	n1 as 
		(select
			ra.cd_usu_cadsus,
			ra.cd_registro_agravo,
			date_trunc('day', ra.dt_registro) as dt_cadastro,
			lead(date_trunc('day', ra.dt_registro)) over(partition by ra.cd_usu_cadsus order by ra.dt_registro) as dt_prox_cadastro
		from
			registro_agravo ra
		where
			ra.cd_cid in ('B972', 'B342', 'U078', 'U079')
			and ra.dt_registro::date = (current_date - interval '1 day')::date
			and ra.status <> 3),
	tn2 as 
		(select
			tn1.cd_registro_agravo,
			tcv.*
		from
			(select
				t1.cd_usu_cadsus,
				t2.cd_registro_agravo,
				max(case
					when t1.de_resultado like '%CONCLUSIVO%' or t1.de_resultado is null or t1.de_resultado like '%NAO%' or t1.de_resultado like '%NÃO%' then 0
					else 1 end) as resultado,
				min(case
					when t1.de_resultado like '%CONCLUSIVO%' or t1.de_resultado is null or t1.de_resultado like '%NAO%' or t1.de_resultado like '%NÃO%' then null
					else t1.dt_teste end) as dt_min_positivo,
				max(case
					when t1.de_resultado like '%CONCLUSIVO%' or t1.de_resultado is null or t1.de_resultado like '%NAO%' or t1.de_resultado like '%NÃO%' then t1.dt_teste
					else null end) as dt_max_negativo
			from
				tcv t1
				join n1 t2 on t2.cd_usu_cadsus = t1.cd_usu_cadsus
					and t1.dt_teste >= t2.dt_cadastro
					and t1.dt_teste <= coalesce(t2.dt_prox_cadastro, current_date)
			group by 1, 2) tn1
			join tcv on tcv.cd_usu_cadsus = tn1.cd_usu_cadsus
				and (case when resultado = 1 then tn1.dt_min_positivo else dt_max_negativo end) = tcv.dt_teste),
    tabelao as
        (select distinct
            ra.cod_notificacao::text, --1
            case when uc.cpf is not null and uc.cpf <> '' then '1' else '2' end as fl_cpf, --2
            case 
                when iac.profissional_saude = 1 then '1'                
                else '2' end as fl_profsaude, --3
            case
                when uc.cpf = '' then null
                else uc.cpf end as cpf, --4
            uc.nm_usuario as nm_usuario, --5
            uc.nm_mae as nm_mae,  --6
            to_char(uc.dt_nascimento::date, 'dd-mm-yyyy') as dt_nascimento, --7
            'BR' as pais_origem,  --8
            case
                when uc.sg_sexo = 'M' then '1'
                when uc.sg_sexo = 'F' then '2'
                else null end as codigoSexo, --9
            case
                when (euc.cep = '' or euc.cep is null) then '88000000'
                else euc.cep end as cep, --10
           cres.descricao as mun_residencia, --11
            case
                when (euc.nm_logradouro = '' or euc.nm_logradouro is null) then 'NAO INFORMADO'
                else upper(tlc.ds_tipo_logradouro || ' ' || euc.nm_logradouro) end as nm_logradouro, --12
            euc.nr_logradouro::text as nu_logradouro, --13
            euc.nm_comp_logradouro as comp_logradouro, --14
            upper(euc.nm_bairro) as nm_bairro, --15
            case when uc.nr_telefone = '' then '48999999999' else uc.nr_telefone end as telefone, --16
            to_char(ra.dt_registro, 'dd-mm-yyyy') as dt_notificacao, --17
            iac.dor_garganta, --18
			iac.dispneia, --19
			iac.febre, --20
			iac.tosse, --21
            iac.outros_observacao as sint_outros, --22
            to_char(ra.dt_primeiros_sintomas, 'dd-mm-yyyy') as dt_inicio_sintomas, --23
            case
                when iac.solicitado = 0 then null
                when iac.solicitado is null then null
                else 'Solicitado' end as teste_solicitado, --24
            case
                when iac.coletado = 0 then null
                when iac.coletado is null then null
                else 'Coletado' end as teste_coletado, --25
            case
                when iac.concluido = 0 then null
                when iac.concluido is null then null
                else 'Concluído' end as teste_concluido, --26
            to_char(iac.data_coleta_teste, 'dd-mm-yyyy') as dt_coleta_teste, --27
            to_char(iac.data_coleta_teste, 'dd-mm-yyyy') as dt_coleta_teste_erro, --28
            case
                when iac.tipo_teste = 1 then 'TESTE RÁPIDO - ANTICORPO'
                when iac.tipo_teste is null then null
                else null end as teste_tp_ac, --29
            case
                when iac.tipo_teste = 2 then 'TESTE RÁPIDO - ANTÍGENO'
                when iac.tipo_teste is null then null
                else null end as teste_tp_ag, --30
            case
                when iac.tipo_teste = 3 then 'RT-PCR'
                when iac.tipo_teste is null then null
                else null end as teste_tp_pcr, --31
            case
                when iac.resultado_teste = 1 then '1'
                when iac.resultado_teste = 2 then '2'
                else null end as teste_result_ficha,  --32
            case
                when iac.resultado_teste = 1 then coalesce(to_char(iac.data_coleta_teste, 'dd-mm-yyyy'), to_char(tn2.dt_teste, 'dd-mm-yyyy'))
                when iac.resultado_teste = 2 then coalesce(to_char(tn2.dt_teste, 'dd-mm-yyyy'), to_char(iac.data_coleta_teste, 'dd-mm-yyyy'))
                else null end as dt_teste_result, --33
            case
                when iac.cd_invest_agr_covid_19 is null then null
                when iac.tipo_teste = 1 then 'TESTE RÁPIDO - ANTICORPO'
                when iac.tipo_teste = 2 then 'TESTE RÁPIDO - ANTÍGENO'
                when iac.tipo_teste = 3 then 'RT-PCR'
                when iac.tipo_teste is null then null end as teste_tipo_ficha, --34
            case
                when tn2.tp_teste like '%PCR%' then 'PCR'
                when tn2.tp_teste like '%WONDFO%' or tn2.tp_teste like '%ANTIBODY%' then 'TR-Anticorpo'
                when tn2.tp_teste is null then null
                else tn2.tp_teste end as teste_tipo_prontuario, --35
            max(case 
                when replace(upper(translate(
                    lower(tn2.de_resultado), 
                    'áàâãäåāăąèééêëēĕėęěìíîïìĩīĭḩóôõöōŏőùúûüũūŭůäàáâãåæçćĉčöòóôõøüùúûßéèêëýñîìíïş',
                    'aaaaaaaaaeeeeeeeeeeiiiiiiiihooooooouuuuuuuuaaaaaaeccccoooooouuuuseeeeyniiiis')), ';', ',') like '%NAO%' then 'NAO'
                when replace(upper(translate(
                    lower(tn2.de_resultado),
                    'áàâãäåāăąèééêëēĕėęěìíîïìĩīĭḩóôõöōŏőùúûüũūŭůäàáâãåæçćĉčöòóôõøüùúûßéèêëýñîìíïş',
                    'aaaaaaaaaeeeeeeeeeeiiiiiiiihooooooouuuuuuuuaaaaaaeccccoooooouuuuseeeeyniiiis')), ';', ',') like '%CONCLUSIVO%' or tn2.de_resultado is null then null
                else 'SIM' end) as teste_result_prontuario, --36
            case
                when iac.classificacao_final = 1 then 'Confirmado Laboratorial'
                else null end as class_conf_lab, --37
            case
                when iac.classificacao_final = 2 then 'Confirmado Clínico-Epidemiológico'
                else null end as class_conf_clinep, --38
            case
                when iac.classificacao_final = 3 then 'Descartado'
                else null end as class_descart, --39
            case
                when iac.cancelado = 1 then 'Cancelado'
                else null end as evol_cancelado, --40
            case
                when iac.cura = 1 then 'Cura'
                else null end as evol_cura, --41
            case
                when iac.tratamento_domiciliar = 1 then 'Em tratamento domiciliar'
                else null end as evol_tto_domiciliar, --42
            case
                when iac.ignorado = 1 then 'Ignorado'
                else null end as evol_ignorado, --43
            case
                when iac.internado = 1 then 'Internado'
                else null end as evol_internado, --44
            case
                when iac.internado_uti = 1 then 'Internado em UTI'
                else null end as evol_uti, --45
            case
                when iac.obito = 1 then 'Óbito'
                else null end as evol_obito, --46
            to_char(ra.dt_encerramento::date, 'dd-mm-yyyy') as dt_encerramento, --47
            upper(enot.descricao) as unidade_notif, --48
            case
                when enot.cnes is null then '6364403'
                else enot.cnes end as cnes_notif, --49
            ra.latitude, --50
            ra.longitude, --51
            case when uc.cd_raca = 5 then 'Ignorado' else r1.ds_raca end as raca, --52
            null as etnia, --53
            case when uce.membro_comunidade_tradicional = 1 then 'Sim' else 'Não' end as comunidade_tradicional, --54
            case when uce.membro_comunidade_tradicional = 1 then 'POVOS QUILOMBOLAS' end as tipo_comunidade_tradicional, --55
            tn2.lote as lote, --56
            tn2.fabricante_codigo as fabricante,--57
            iac.tipo_teste as tipo_teste,--58
            cres.cod_cid::text as cod_cidade_residencia,--59
            ra.cd_registro_agravo as idOrigem,--60
            ufnot.sigla,--61
            uc.cd_municipio_residencia,--62
            uc.cd_etnia,--63
            iac.tabela_cbo --64
        from 
            registro_agravo ra
            join cid on cid.cd_cid = ra.cd_cid 
            join usuario_cadsus uc on ra.cd_usu_cadsus = uc.cd_usu_cadsus
                and uc.situacao in (0,1)
                and uc.st_excluido = 0
                and uc.dt_inativacao is null
            left join usuario_cadsus_esus uce on uc.cd_usu_cadsus = uce.cd_usu_cadsus
            left join raca r1 on r1.cd_raca = uc.cd_raca
            left join etnia_indigena ei on uc.cd_etnia = ei.cd_etnia
            left join usuario_cadsus_cns ucc on ucc.cd_usu_cadsus = uc.cd_usu_cadsus
                and ucc.st_excluido = 0
            join empresa enot on enot.empresa = ra.empresa
            join cidade cnot on cnot.cod_cid = enot.cod_cid 
            join estado ufnot on ufnot.cod_est = cnot.cod_est
            left join investigacao_agr_covid_19 iac on iac.cd_registro_agravo = ra.cd_registro_agravo
            left join nacionalidade nac on uc.cd_pais_nascimento = nac.cd_pais
            --left join tabela_cbo tcbo on iac.tabela_cbo = tcbo.cd_cbo 
            -- endereco estruturado
            left join endereco_usuario_cadsus euc on euc.cd_endereco = uc.cd_endereco
                and euc.st_ativo = 1
            left join tipo_logradouro_cadsus tlc on tlc.cd_tipo_logradouro = euc.cd_tipo_logradouro 
            left join cidade cres on cres.cod_cid = euc.cod_cid
            left join estado eres on cres.cod_est = eres.cod_est
            left join endereco_estruturado ee on ee.cd_endereco_estruturado = euc.cd_endereco_estruturado
            -- equipe território
            left join equipe_micro_area ema on ema.cd_eqp_micro_area = ee.cd_eqp_micro_area
            left join equipe eqterr on eqterr.cd_equipe_area = ema.cd_equipe_area
            left join equipe_area eaterr on eaterr.cd_equipe_area = eqterr.cd_equipe_area
            left join empresa emterr on emterr.empresa = eqterr.empresa
            -- equipe lista
            left join equipe eqlst on eqlst.cd_equipe_area = uc.cd_equipe
            left join equipe_area ealst on ealst.cd_equipe_area = eqlst.cd_equipe_area
            left join empresa emlst on emlst.empresa = eqlst.empresa
            -- exames
            left join tn2 on tn2.cd_registro_agravo = ra.cd_registro_agravo
            -- outros
            left join usuario_cadsus_documento ucd on uc.cd_usu_cadsus = ucd.cd_usu_cadsus 
        where 
            ra.cd_cid in ('B972', 'B342', 'U078', 'U079')
            and ra.status <> 3
            and ra.dt_registro::date = (current_date - interval '1 day')::date
        group by 
            1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14, 15, 16, 17, 18, 19,
            20, 21, 22, 23, 24, 25, 26, 27, 28, 29, 30, 31, 32, 33, 34, 35, 37, 38, 39,
            40, 41, 42, 43, 44, 45, 46, 47, 48, 49, 50, 51, 52, 53, 54, 55, 56, 57, 58, 59,
            60, 61, 62, 63, 64)        
            
            
            
select  -- DADOS OBRIGATÓRIOS CONFORME MANUAL

	fl_cpf as "codigoTemCpf", --1
	cpf as "cpf", --2
	'2' as "codigoEstrangeiro", --3
	nm_mae as "nomeMae", --4

	fl_profsaude as "codigoProfissionalSaude", --5
	substr(tabela_cbo,1,4) as "codigoCbo",  --verificar se esse formato coincide exatamente com manual   --6
	
	upper(nm_usuario) as "nomeCompleto", --7
	dt_nascimento as "dataNascimento", --8
	codigoSexo as "codigoSexo",  --9
	
	case
    	when raca = 'Branca' then '01'
    	when raca = 'Preta' then '02'
    	when raca = 'Parda' then '03'
    	when raca = 'Amarela' then '04'
    	--when raca = 'Indigena' then '05'
    	else '01'   	
    	end as "codigoRacaCor", --10
   	-- etnia as "codigoEtnia", -- obrigatório se indígena, mas códigos da Celk são diferentes do Esus
   	'2' as "codigoContemComunidadeTradicional", -- não como padrão, verificar na Celk se está preenchido --11
	
    cep::text as "cep", --12
	coalesce(nm_logradouro,'AV. PROF HENRIQUE DA SILVA FONTES')::text as "logradouro", --13
    coalesce(nu_logradouro, '6100')::text as "numero", --14
    coalesce(nm_bairro,'TRINDADE')::text as "bairro", --15
    coalesce(sigla,'SC')::text as "codigoEstado", --16
    coalesce('4205407',cd_municipio_residencia)::text as "codigoMunicipio", --17
    coalesce(telefone,'48999999999')::text as "telefone", --18
    
    -- SINTOMAS 
	dt_inicio_sintomas as "dataInicioSintomas", --19
	case when dor_garganta = 1 then '1' else '0' end as sintoma_10,
	case when dispneia = 1 then '1' else '0' end as sintoma_9,
	case when febre = 1 then '1' else '0' end as sintoma_8,
	case when tosse = 1 then '1' else '0' end as sintoma_7,
	null as "outrosSintomas", --25
	
    cod_notificacao as "numeroNotificacao", --26
    dt_notificacao as "dataNotificacao", --27
    cnes_notif as "cnes", --28
    'SC' as "codigoEstadoNotificacao", --29
    '4205407' as "codigoMunicipioNotificacao", --30
    to_char(current_date, 'dd-mm-yyyy') as "dataAtualizacao", --31  
	
	--TESTES	
			case 
			when coalesce(teste_tp_ac,teste_tp_pcr, teste_tp_ag) = 'RT-PCR' then '1'
			else '3'
			end as "codigoTipoTeste",						 
		case
	        when coalesce(teste_concluido, teste_coletado, teste_solicitado) = 'Solicitado' then '1'
	        when coalesce(teste_concluido, teste_coletado, teste_solicitado) = 'Coletado' then '2'
	        when coalesce(teste_concluido, teste_coletado, teste_solicitado) = 'Concluído' then '3'
	        else '4' end as "codigoEstadoTeste",  													 
		coalesce(dt_coleta_teste,dt_notificacao) as "dataColetaTeste",		 						 
		teste_result_ficha as "codigoResultadoTeste",												 
		case when tipo_teste = 2 then coalesce(lote,'XXXXXXX') else lote end as "loteTeste",         
		case when coalesce(dt_coleta_teste,dt_notificacao) is not null 
		then '915' end as "codigoFabricanteTeste",	
	'2' as "codigoAtualiza_up"	--33
from
   	tabelao   	
   	
;