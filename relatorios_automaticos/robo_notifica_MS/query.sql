with
	
	paises("pais_esus","pais_ckan") as (
		values 
		('1','AF'),('2','ZA'),('3','AL'),('4','DE'),('5','AD'),('6','AO'),('7','AI'),('8','AQ'),('9','AG'),
		('11','SA'),('12','DZ'),('13','AR'),('14','AM'),('15','AW'),('16','AU'),('17','AT'),('18','AZ'),
		('19','BS'),('22','BH'),('20','BD'),('21','BB'),('23','BY'),('24','BE'),('25','BZ'),('26','BJ'),
		('27','BM'),('28','BO'),('29','BA'),('30','BW'),('31','BR'),('32','BN'),('33','BG'),('34','BF'),
		('35','BI'),('36','BT'),('37','CV'),('38','CM'),('39','KH'),('40','CA'),('42','KZ'),('43','TD'),
		('44','CL'),('45','CN'),('46','CY'),('47','SG'),('48','CO'),('49','KM'),('50','CG'),('51','KP'),
		('52','KR'),('53','CI'),('54','CR'),('55','HR'),('56','CU'),('57','DK'),('58','DJ'),('59','DM'),
		('60','EG'),('61','SV'),('62','AE'),('63','EC'),('64','ER'),('65','SK'),('66','SI'),('67','ES'),
		('68','US'),('69','EE'),('70','ET'),('72','FJ'),('73','PH'),('74','FI'),('75','FR'),('77','GA'),
		('78','GM'),('79','GH'),('80','GE'),('81','GI'),('110','GB'),('82','GB'),('83','GD'),('84','GR'),
		('85','GL'),('86','GP'),('87','GU'),('88','GT'),('106','GG'),('89','GY'),('90','GF'),('91','GN'),
		('92','GQ'),('93','GW'),('94','HT'),('95','NL'),('96','HN'),('97','HK'),('98','HU'),('99','YE'),
		('100','BV'),('114','PN'),('115','RE'),('103','KY'),('104','CC'),('105','CK'),('108','FO'),
		('109','GS'),('110','HM'),('111','FK'),('112','MP'),('113','MH'),('116','SB'),('205','SC'),
		('119','TK'),('120','TC'),('121','VI'),('122','VG'),('124','IN'),('125','ID'),('126','IR'),
		('127','IQ'),('128','IE'),('129','IS'),('130','IL'),('131','IT'),('133','JM'),('134','JP'),
		('240','JE'),('135','JO'),('136','KI'),('137','KW'),('138','LA'),('139','LS'),('140','LV'),
		('141','LB'),('142','LR'),('143','LY'),('144','LI'),('145','LT'),('146','LU'),('147','MO'),
		('148','MK'),('149','MG'),('150','MY'),('151','MW'),('152','MV'),('153','ML'),('154','MT'),
		('155','MA'),('156','MQ'),('157','MU'),('158','MR'),('159','YT'),('160','MX'),('162','FM'),
		('163','MZ'),('164','MD'),('165','MC'),('166','MN'),('241','ME'),('167','MS'),('161','MM'),
		('168','NA'),('169','NR'),('170','NP'),('171','NI'),('172','NE'),('173','NG'),('174','NU'),
		('175','NO'),('176','NC'),('177','NZ'),('178','OM'),('179','PW'),('242','PS'),('180','PA'),
		('181','PG'),('182','PK'),('183','PY'),('184','PE'),('185','PF'),('186','PL'),('187','PR'),
		('188','PT'),('41','QA'),('189','KE'),('191','CF'),('50','CD'),('192','DO'),('193','CZ'),
		('194','RO'),('195','RW'),('71','RU'),('196','EH'),('202','PM'),('197','AS'),('198','WS'),
		('199','SM'),('200','LC'),('201','KN'),('203','ST'),('204','VC'),('206','SN'),('207','SL'),
		('243','RS'),('208','SY'),('209','SO'),('210','LK'),('211','SZ'),('212','SD'),('212','SS'),
		('213','SE'),('214','CH'),('215','SR'),('216','TJ'),('217','TH'),('218','TW'),('219','TZ'),
		('220','TF'),('221','TL'),('222','TG'),('223','TO'),('224','TT'),('225','TN'),('226','TM'),
		('227','TR'),('228','TV'),('229','UA'),('230','UG'),('231','UY'),('232','UZ'),('233','VU'),
		('234','VA'),('235','VE'),('236','VN'),('123','WF'),('237','ZM'),('238','ZW')),
				
	dados_notificacoes as (
		select 

			-- DADOS PESSOAIS
			uc.nm_usuario as nome_completo,
			to_char(uc.dt_nascimento::date, 'dd-mm-yyyy') as data_nascimento,
			case
            	when uc.sg_sexo = 'M' then '1'
                when uc.sg_sexo = 'F' then '2'
	            else null
            	end as codigo_sexo,
			uc.nm_mae as nome_mae,
			
			-- DOCUMENTOS
			case 
				when uc.cpf is not null and uc.cpf <> '' then '1' else '2' 
				end as codigo_tem_cpf,
			uc.cpf as cpf,		
			ucc.cd_numero_cartao as cns,
			case 
				when uc.flag_estrangeiro = 1
				then '999' else null 
				end as passaporte,
			
			-- ORIGEM
			case 
				when uc.flag_estrangeiro = 1
					and p.pais_ckan is not null 
					then '1' else '2'
				end as codigo_estrangeiro,
			case 
				when uc.flag_estrangeiro = 1
				and p.pais_ckan is not null
				then p.pais_ckan end as codigo_pais_origem,
						
			-- ENDEREÇO
			coalesce(tlc.ds_tipo_logradouro || ' ' || euc.nm_logradouro, 'AV. PROF HENRIQUE DA SILVA FONTES')::text as logradouro,
		    coalesce(euc.nr_logradouro, 'SN')::text as numero,
		    euc.nm_comp_logradouro as complemento,
		    coalesce(euc.nm_bairro, 'TRINDADE')::text as bairro,
		    case when euc.cep is null or euc.cep = '' then '88036700' else euc.cep::text end as cep,
		    coalesce('420540',c.cod_cid)::text as codigo_municipio,
		    coalesce(e.sigla, 'SC')::text as codigo_estado, 
		    
		    -- TELEFONE E EMAIL
		    coalesce(uc.nr_telefone, uc.nr_telefone_2, uc.telefone3, uc.telefone4, '48999999999')::text as telefone_contato,
			coalesce(uc.nr_telefone, uc.nr_telefone_2, uc.telefone3, uc.telefone4, '48999999999')::text as telefone,
			uc.email as email,
						
			-- PROFISSÃO
			case 	
				when iac.profissional_saude = 1 and iac.tabela_cbo is not null then '1'
				else '2'
				end as codigo_profissional_saude,
			case 
				when iac.profissional_seguranca = 1 then '1'
				else '2'
				end as codigo_profissional_seguranca,
			substr(iac.tabela_cbo,1,4) as codigo_cbo,
			
			-- ETNIA
			case
    			when uc.cd_raca = 1 then '01'
    			when uc.cd_raca = 2 then '02'
    			when uc.cd_raca = 3 then '03'
    			when uc.cd_raca = 4 then '04'
    			when uc.cd_raca = 5 then '05'
    			else '06' 	
	    		end as codigo_raca_cor,
			'2' as codigo_contem_comunidade_tradicional, -- sem registros
		   	case 
		   		when uc.cd_raca = 5 then '9999' else null 
		   		end as codigo_etnia, -- corrigir tabela Celk
						
			-- DADOS NOTIFICAÇÃO
			ra.cd_registro_agravo as id_origem,
			ra.cod_notificacao as numero_notificacao,
			to_char(ra.dt_registro, 'dd-mm-yyyy') as data_notificacao,
			case 
				when enot.cnes is null then '6364403'
				else enot.cnes 
				end as cnes,
			--coalesce(enot.cod_cid, '4205407')::text as codigoMunicipioNotificacao,
			'4205407' as codigo_municipio_notificacao,
			coalesce(ufnot.sigla, 'SC')::text as codigo_estado_notificacao,
		   	'1' as codigo_estrategia_covid,
		   	
		   	-- SINTOMAS		   	
		   	case
		   		when (iac.dor_garganta = 1 or iac.dispneia = 1 or iac.febre = 1 or iac.tosse = 1 or iac.outros = 1 or iac.dor_cabeca = 1
						or iac.disturbios_gustatorios = 1 or iac.disturbios_olfativos = 1 or iac.coriza = 1)
		   				then to_char(ra.dt_primeiros_sintomas, 'dd-mm-yyyy') end as data_inicio_sintomas,
			case when iac.dor_garganta = 1 then '1' else '0' end as sintoma_10,
			case when iac.dispneia = 1 then '1' else '0' end as sintoma_9,
			case when iac.febre = 1 then '1' else '0' end as sintoma_8,
			case when iac.tosse = 1 then '1' else '0' end as sintoma_7,
			case when iac.outros = 1 then '1' else '0' end as sintoma_6,
			case when iac.dor_cabeca = 1 then '1' else '0' end as sintoma_5,
			case when iac.disturbios_gustatorios = 1 then '1' else '0' end as sintoma_4,
			case when iac.disturbios_olfativos = 1 then '1' else '0' end as sintoma_3,
			case when iac.coriza = 1 then '1' else '0' end as sintoma_2,
			case when iac.outros = 1 
				then coalesce(iac.outros_observacao, 'Nao informado') end as outros_sintomas,
				
			-- CONDIÇÕES
			case when iac.doenca_resp_descompensada = 1 then '1' else '0' end as condicao_9,
		   	case when iac.doenca_card_cronica = 1 then '1' else '0' end as condicao_8,
		   	case when iac.diabetes = 1 then '1' else '0' end as condicao_7,
		   	case when iac.doencas_renais_avancado = 1 then '1' else '0' end as condicao_6,
		   	case when iac.imunossupressao = 1 then '1' else '0' end as condicao_5,
		   	case when iac.gestante_alto_risco = 1 then '1' else '0' end as condicao_4,
		   	case when iac.portador_doenca_cromossomica = 1 then '1' else '0' end as condicao_3,
		   	case when iac.condicao_puerpera = 1 then '1' else '0' end as condicao_2,
		   	case when iac.condicao_obesidade = 1 then '1' else '0' end as condicao_1,
		   	-- 'outros' indisponível
		   	
		   	-- EVOLUÇÃO E CLASSIFICAÇÃO FINAL
		   	case 
				when iac.cancelado = 1 and ra.dt_encerramento is not null then '1'
				when iac.ignorado = 1 and ra.dt_encerramento is not null then '2'
				when iac.obito = 1 and ra.dt_encerramento is not null then '3'
				when iac.cura = 1 and ra.dt_encerramento is not null then '4'
				when iac.internado = 1 and ra.dt_encerramento is not null then '5'
				when iac.internado_uti = 1 and ra.dt_encerramento is not null then '6'
				when iac.tratamento_domiciliar = 1 and ra.dt_encerramento is not null then '7'
				else null 
				end as codigo_evolucao,
			case 
				when iac.classificacao_final = 1 then '1' 
				when iac.classificacao_final = 2 then '2'
				when iac.classificacao_final = 3 then '3'
				when iac.classificacao_final = 4 then '4'
				when iac.classificacao_final = 5 then '5'
				when iac.classificacao_final = 6 then '6'
				else null
				end as codigo_classificacao_final,
			to_char(ra.dt_encerramento, 'dd-mm-yyyy') as data_encerramento,
						
			-- EXAMES				
			case 
				when iac.tipo_teste = 1 then '4'
				when iac.tipo_teste = 2 
					and iac.data_coleta_teste is not null 
					and iac.resultado_teste is not null
					then '3'
				when iac.tipo_teste = 3 then '1'
				else '1'
				end as codigo_tipo_teste,
			case 
				when iac.concluido = 1 
					and iac.data_coleta_teste is not null 
					and iac.resultado_teste is not null
					then '3'
				when iac.coletado = 1 and iac.data_coleta_teste is not null then '2'
				when iac.solicitado = 1 then '1'
				else '4'
				end as codigo_estado_teste, 
			to_char(iac.data_coleta_teste, 'dd-mm-yyyy') as data_coleta_teste,
			iac.resultado_teste::text as codigo_resultado_teste,
			case 
				when iac.tipo_teste = 3 then 'XXXXXXX' 
				end as lote_teste,
			case 
				when iac.tipo_teste = 2 then '915' 
				end as codigo_fabricante_teste,
			case 
				when iac.tipo_teste is null then null else '1'
				end as codigo_local_realizacao_testagem,
			
			-- ATUALIZAÇÃO
		   	to_char(current_date, 'dd-mm-yyyy') as data_atualizacao,
			'2' as atualiza_up
		from 
			
			-- DADOS NOTIFICAÇÃO E INVESTIGAÇÃO
			registro_agravo ra
			left join investigacao_agr_covid_19 iac on iac.cd_registro_agravo = ra.cd_registro_agravo
            join empresa enot on enot.empresa = ra.empresa
            join cidade cnot on cnot.cod_cid = enot.cod_cid 
            join estado ufnot on ufnot.cod_est = cnot.cod_est
            	
			-- DADOS USUÁRIO
			join usuario_cadsus uc on ra.cd_usu_cadsus = uc.cd_usu_cadsus
            left join endereco_usuario_cadsus euc on euc.cd_endereco = uc.cd_endereco
            left join tipo_logradouro_cadsus tlc on tlc.cd_tipo_logradouro = euc.cd_tipo_logradouro
			left join cidade c on euc.cod_cid = c.cod_cid 
			left join estado e on c.cod_est = e.cod_est 
            left join usuario_cadsus_esus uce on uc.cd_usu_cadsus = uce.cd_usu_cadsus
            left join usuario_cadsus_cns ucc on ucc.cd_usu_cadsus = uc.cd_usu_cadsus and ucc.st_excluido = 0
			left join raca rac on rac.cd_raca = uc.cd_raca
            left join etnia_indigena et on uc.cd_etnia = et.cd_etnia

            -- PAISES (pais padrão Celk >>> país padrão ESUS >>> país padrão CKAN)
            left join nacionalidade n on uc.cd_pais_nascimento = n.cd_pais 
			left join paises p on n.cd_esus::text = p.pais_esus
			
			-- MUNICIPIOS (municipio padrão Celk >>> municipio padrão ESUS)
            --left join municipios m on euc.cod_cid::text = m.municipio_celk
            
        where 
            ra.cd_cid in ('B342','B972','J11','J111','J118','U071','U072','U078','U079','Y598')
            and ra.status <> 3
            and ra.dt_registro::date between '2022-09-01'::date and '2022-09-30'::date
            and uc.situacao in (0,1)
            and uc.st_excluido = 0
            and uc.dt_inativacao is null
            and (
            	(uc.cpf is not null and uc.cpf <> '')
            	or 
            	(uc.nm_mae is not null and ucc.cd_numero_cartao is not null)
				)
	) 
	
select
	
	-- DADOS PESSOAIS
	nome_completo as "nomeCompleto",
	data_nascimento as "dataNascimento",
	codigo_sexo as "codigoSexo",	
	nome_mae as "nomeMae",

	-- DOCUMENTOS
	codigo_tem_cpf as "codigoTemCpf",
	cpf,
	cns::text as cns,
	passaporte,

	-- ORIGEM
   	codigo_estrangeiro as "codigoEstrangeiro",
	codigo_pais_origem as "codigoPaisOrigem",
		
	-- ENDEREÇO
	logradouro,
	numero,
	bairro,
	cep,
	codigo_municipio::text as "codigoMunicipio",
	codigo_estado as "codigoEstado",
	
    -- TELEFONE E EMAIL
    telefone_contato as "telefoneContato",
    telefone,
    email,

	-- PROFISSÃO
	codigo_profissional_saude as "codigoProfissionalSaude",
	codigo_profissional_seguranca as "codigoProfissionalSeguranca",
	codigo_cbo as "codigoCbo",

	-- ETNIA
	codigo_raca_cor as "codigoRacaCor",
   	codigo_contem_comunidade_tradicional as "codigoContemComunidadeTradicional",
   	codigo_etnia as "codigoEtnia",
    
   	-- DADOS NOTIFICAÇÃO
   	id_origem::text as "idOrigem",
   	numero_notificacao::text as "numeroNotificacao" ,
   	data_notificacao as "dataNotificacao",
   	cnes,
   	codigo_municipio_notificacao as "codigoMunicipioNotificacao",
   	codigo_estado_notificacao as "codigoEstadoNotificacao",
	codigo_estrategia_covid as "codigoEstrategiaCovid",
   	
    -- SINTOMAS (numeros devem estar dentro de 'codigoSintomas')
	data_inicio_sintomas as "dataInicioSintomas",
	sintoma_10,
	sintoma_9,
	sintoma_8,
	sintoma_7,
	sintoma_6,
	sintoma_5,
	sintoma_4,
	sintoma_3,
	sintoma_2,
	case when (sintoma_10 = '0' and sintoma_9 = '0' and sintoma_8 = '0' and sintoma_7 = '0' and sintoma_6 = '0' and 
	           sintoma_5 = '0' and sintoma_4 = '0' and sintoma_3 = '0' and sintoma_2 = '0')
	           then '1' else '0' end as sintoma_1,
	outros_sintomas as "outrosSintomas",
	
	-- CONDIÇÕES (numeros devem estar dentro de 'codigoCondicoes')
	condicao_9,
	condicao_8,
	condicao_7,
	condicao_6,
	condicao_5,
	condicao_4,
	condicao_3,
	condicao_2,
	condicao_1,
	
	-- EVOLUÇÃO E CLASSIFICAÇÃO FINAL
	codigo_evolucao as "codigoEvolucaoCaso",
	codigo_classificacao_final as "codigoClassificacaoFinal",
	data_encerramento as "dataEncerramento",
			
	-- TESTES (Exceto o local de testagem, os demais dados devem estar dentro de 'testes'. Se tipo teste null, todo bloco null.)				
	codigo_tipo_teste as "codigoTipoTeste",
	codigo_estado_teste as "codigoEstadoTeste", 
	data_coleta_teste as "dataColetaTeste",
	codigo_resultado_teste as "codigoResultadoTeste",
	--loteTeste as "loteTeste",
	codigo_fabricante_teste as "codigoFabricanteTeste",
	'1' as "codigoLocalRealizacaoTestagem",
	
	
	-- TRATAMENTO
	'2' as "codigoRecebeuAntiviral", --Não
		
		
	-- ATUALIZAÇÃO
	data_atualizacao as "dataAtualizacao",
	atualiza_up as "atualizaUp"
	    	
from
   	dados_notificacoes dn
   	order by 1
;