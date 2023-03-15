-- QUERY PARA VERIFICAR A ADEQUAÇÃO DA PRODUÇÃO DE PROCEDIMENTOS DO CEO COM RELAÇÃO À PORTARIA MINISTERIAL
with 
	ceos_procedimento (codceo_procedimento,nome_ceoprocedimento,qntceo_mes,tipo_ceo,referencia_ceo)	as(
		values
		-- Para os CEOs Tipo 1:
		--80 Procedimentos Básicos por mês, no total, referente aos seguintes códigos
			(0101020058,'APLICAÇÃO DE CARIOSTÁTICO (POR DENTE)',80,1,'Procedimentos Básicos'),
			(0101020066,'APLICAÇÃO DE SELANTE (POR DENTE)',80,1,'Procedimentos Básicos'),
			(0101020074,'APLICAÇÃO TÓPICA DE FLÚOR (INDIVIDUAL POR SESSÃO)',80,1,'Procedimentos Básicos'),
			(0101020082,'EVIDENCIAÇÃO DE PLACA BACTERIANA',80,1,'Procedimentos Básicos'),
			(0101020090,'SELAMENTO PROVISÓRIO DE CAVIDADE DENTÁRIA',80,1,'Procedimentos Básicos'),
			(0307010015,'CAPEAMENTO PULPAR',80,1,'Procedimentos Básicos'),
			(0307010023,'RESTAURAÇÃO DE DENTE DECÍDUO',80,1,'Procedimentos Básicos'),
			(0307010031,'RESTAURAÇÃO DE DENTE PERMANENTE ANTERIOR',80,1,'Procedimentos Básicos'),
			(0307010040,'RESTAURAÇÃO DE DENTE PERMANENTE POSTERIOR',80,1,'Procedimentos Básicos'),
			(0307020070,'PULPOTOMIA DENTÁRIA',80,1,'Procedimentos Básicos'),
			(0307030016,'RASPAGEM ALISAMENTO E POLIMENTO SUPRAGENGIVAIS (POR SEXTANTE)',80,1,'Procedimentos Básicos'),
			(0307030024,'RASPAGEM ALISAMENTO SUBGENGI VAIS (POR SEXTANTE)',80,1,'Procedimentos Básicos'),
			(0414020120,'EXODONTIA DE DENTE DECÍDUO',80,1,'Procedimentos Básicos'),
			(0414020138,'EXODONTIA DE DENTE PERMANENTE',80,1,'Procedimentos Básicos'),
		--60 Procedimentos de Periodontia por mês, no total, referente aos seguintes códigos:
			(0307030032,'RASPAGEM CORONO-RADICULAR (POR SEXTANTE)',60,1,'Procedimentos de Periodontia'),
			(0414020081,'ENXERTO GENGIVAL',60,1,'Procedimentos de Periodontia'),
			(0414020154,'GENGIVECTOMIA (POR SEXTANTE)',60,1,'Procedimentos de Periodontia'),
			(0414020162,'GENGIVOPLASTIA (POR SEXTANTE)',60,1,'Procedimentos de Periodontia'),
			(0414020375,'TRATAMENTO CIRÚRGICO PERIODONTAL (POR SEXTANTE)',60,1,'Procedimentos de Periodontia'),
		--35 Procedimentos de Endodontia por mês, no total, referente aos seguintes códigos:
			(0307020037,'OBTURAÇÃO DE DENTE DECÍDUO',35,1,'Procedimentos de Endodontia'),
			(0307020045,'OBTURAÇÃO EM DENTE PERMANENTE BIRRADICULAR',35,1,'Procedimentos de Endodontia'),
			(0307020053,'OBTURAÇÃO EM DENTE PERMANENTE C/ TRÊS OU MAIS RAÍZES',35,1,'Procedimentos de Endodontia'),
			(0307020061,'OBTURAÇÃO EM DENTE PERMANENTE UNIRRADICULAR',35,1,'Procedimentos de Endodontia'),
			(0307020088,'RETRATAMENTO ENDODÔNTICO EM DENTE PERMANENTE BI-RADICULAR',35,1,'Procedimentos de Endodontia'),
			(0307020096,'RETRATAMENTO ENDODÔNTICO EM DENTE PERMANENTE C/ 3 OU MAIS RAÍZES',35,1,'Procedimentos de Endodontia'),
			(0307020100,'RETRATAMENTO ENDODÔNTICO EM DENTE PERMANENTE UNI-RADICULAR',35,1,'Procedimentos de Endodontia'),
			(0307020118,'SELAMENTO DE PERFURAÇÃO RADICULAR',35,1,'Procedimentos de Endodontia'),
		--80 Procedimentos de Cirurgia Oral por mês, no total, referente aos seguintes códigos:
			(0201010232,'BIÓPSIA DE GLÂNDULA SALIVAR',80,1,'Cirurgia Oral'),
			(0201010348,'BIÓPSIA DE OSSO DO CRÂNIO E DA FACE',80,1,'Cirurgia Oral'),
			(0201010526,'BIÓPSIA DOS TECIDOS MOLES DA BOCA',80,1,'Cirurgia Oral'),
			(0307010058,'TRATAMENTO DE NEVRALGIAS FACIAIS',80,1,'Cirurgia Oral'),
			(0404020445,'CONTENÇÃO DE DENTES POR SPLINTAGEM',80,1,'Cirurgia Oral'),
			(0404020488,'OSTEOTOMIA DAS FRATURAS ALVEOLO DENTÁRIAS',80,1,'Cirurgia Oral'),
			(0404020577,'REDUÇÃO DE FRATURA ALVEOLO-DENTÁRIA SEM OSTEOSSÍNTESE',80,1,'Cirurgia Oral'),
			(0404020615,'REDUÇÃO DE LUXAÇÃO TÊMPORO- MANDIBULAR',80,1,'Cirurgia Oral'),
			(0404020623,'RETIRADA DE MATERIAL DE SÍNTESE ÓSSEA/ DENTÁRIA',80,1,'Cirurgia Oral'),
			(0404020674,'RECONSTRUÇÃO PARCIAL DO LÁBIO TRAUMATIZADO',80,1,'Cirurgia Oral'),
			(0414010345,'EXCISÃO DE CÁLCULO DE GLÂNDULA SALIVAR',80,1,'Cirurgia Oral'),
			(0414010361,'EXERESE DE CISTO ODONTOGÊNICO E NÃO-ODONTOGÊNICO',80,1,'Cirurgia Oral'),
			(0414010388,'TRATAMENTO CIRÚRGICO DE FÍSTULA INTRA/ EXTRA-ORAL',80,1,'Cirurgia Oral'),
			(0401010082,'FRENECTOMIA',80,1,'Cirurgia Oral'),
			(0404010512,'SINUSOTOMIA TRANSMAXILAR',80,1,'Cirurgia Oral'),
			(0404020038,'CORREÇÃO CIRÚRGICA DE FÍSTULA ORONASAL/ ORO-SINUSAL',80,1,'Cirurgia Oral'),
			(0404020054,'DRENAGEM DE ABSCESSO DA BOCA E ANEXOS',80,1,'Cirurgia Oral'),
			(0404020089,'EXCISÃO DE RÂNULA OU FENÔMENO DE RETENÇÃO SALIVAR',80,1,'Cirurgia Oral'),
			(0404020097,'EXCISÃO E SUTURA DE LESÃO NA BOCA',80,1,'Cirurgia Oral'),
			(0404020100,'EXCISÃO EM CUNHA DO LÁBIO',80,1,'Cirurgia Oral'),
			(0404020313,'RETIRADA DE CORPO ESTRANHO DOS OSSOS DA FACE',80,1,'Cirurgia Oral'),
			(0404020631,'RETIRADA DE MEIOS DE FIXAÇÃO MAXILO-MANDIBULAR',80,1,'Cirurgia Oral'),
			(0414010256,'TRATAMENTO CIRÚRGICO DE FÍSTULA ORO-SINUSAL/ ORO-NASAL',80,1,'Cirurgia Oral'),
			(0414020022,'APICECTOMIA C/ OU S/ OBTURAÇÃO RETROGRADA',80,1,'Cirurgia Oral'),
			(0414020030,'APROFUNDAMENTO DE VESTÍBULO ORAL (POR SEXTANTE)',80,1,'Cirurgia Oral'),
			(0414020049,'CORREÇÃO DE BRIDAS MUSCULARES',80,1,'Cirurgia Oral'),
			(0414020057,'CORREÇÃO DE IRREGULARIDADES DE REBORDO ALVEOLAR',80,1,'Cirurgia Oral'),
			(0414020065,'CORREÇÃO DE TUBEROSIDADE DO MAXILAR',80,1,'Cirurgia Oral'),
			(0414020073,'CURETAGEM PERIAPICAL',80,1,'Cirurgia Oral'),
			(0414020090,'ENXERTO ÓSSEO DE ÁREA DOADORA INTRABUCAL',80,1,'Cirurgia Oral'),
			(0414020146,'EXODONTIA MULTIPLA C/ ALVEOLO-PLASTIA POR SEXTANTE',80,1,'Cirurgia Oral'),
			(0414020170,'GLOSSORRAFIA',80,1,'Cirurgia Oral'),
			(0414020200,'MARSUPIALIZAÇÃO DE CISTOS E PSEUDOCISTOS',80,1,'Cirurgia Oral'),
			(0414020219,'ODONTOSECÇÃO / RADILECTOMIA / TUNELIZAÇÃO',80,1,'Cirurgia Oral'),
			(0414020243,'REIMPLANTE E TRANSPLANTE DENTAL (POR ELEMENTO)',80,1,'Cirurgia Oral'),
			(0414020278,'REMOÇÃO DE DENTE RETIDO (INCLUSO / IMPACTADO)',80,1,'Cirurgia Oral'),
			(0414020294,'REMOÇÃO DE TÓRUS E EXOSTOSES',80,1,'Cirurgia Oral'),
			(0414020359,'TRATAMENTO CIRÚRGICO DE HEMORRAGIA BUCO-DENTAL',80,1,'Cirurgia Oral'),
			(0414020367,'TRATAMENTO CIRÚRGICO P/ TRACIONAMENTO DENTAL',80,1,'Cirurgia Oral'),
			(0414020383,'TRATAMENTO DE ALVEOLITE',80,1,'Cirurgia Oral'),
			(0414020405,'ULOTOMIA/ULECTOMIA',80,1,'Cirurgia Oral'),
		--Para os CEOs Tipo 2:
		--110 Procedimentos Básicos por mês, no total, referente aos seguintes códigos:
			(0101020058,'APLICAÇÃO DE CARIOSTÁTICO (POR DENTE)',110,2,'Procedimentos Básicos'),
			(0101020066,'APLICAÇÃO DE SELANTE (POR DENTE)',110,2,'Procedimentos Básicos'),
			(0101020074,'APLICAÇÃO TÓPICA DE FLÚOR (INDIVIDUAL POR SESSÃO)',110,2,'Procedimentos Básicos'),
			(0101020082,'EVIDENCIAÇÃO DE PLACA BACTERIANA',110,2,'Procedimentos Básicos'),
			(0101020090,'SELAMENTO PROVISÓRIO DE CAVIDADE DENTÁRIA',110,2,'Procedimentos Básicos'),
			(0307010015,'CAPEAMENTO PULPAR',110,2,'Procedimentos Básicos'),
			(0307010023,'RESTAURAÇÃO DE DENTE DECÍDUO',110,2,'Procedimentos Básicos'),
			(0307010031,'RESTAURAÇÃO DE DENTE PERMANENTE ANTERIOR',110,2,'Procedimentos Básicos'),
			(0307010040,'RESTAURAÇÃO DE DENTE PERMANENTE POSTERIOR',110,2,'Procedimentos Básicos'),
			(0307020070,'PULPOTOMIA DENTÁRIA',110,2,'Procedimentos Básicos'),
			(0307030016,'RASPAGEM ALISAMENTO E POLIMENTO SUPRAGENGIVAIS (POR SEXTANTE)',110,2,'Procedimentos Básicos'),
			(0307030024,'RASPAGEM ALISAMENTO SUBGENGIVAIS (POR SEXTANTE)',110,2,'Procedimentos Básicos'),
			(0414020120,'EXODONTIA DE DENTE DECÍDUO',110,2,'Procedimentos Básicos'),
			(0414020138,'EXODONTIA DE DENTE PERMANENTE',110,2,'Procedimentos Básicos'),
		--90 Procedimentos de Periodontia por mês, no total, referente aos seguintes códigos:
			(0307030032,'RASPAGEM CORONO-RADICULAR (POR SEXTANTE)',90,2,'Procedimentos de Periodontia'),
			(0414020081,'ENXERTO GENGIVAL',90,2,'Procedimentos de Periodontia'),
			(0414020154,'GENGIVECTOMIA (POR SEXTANTE)',90,2,'Procedimentos de Periodontia'),
			(0414020162,' GENGIVOPLASTIA (POR SEXTANTE)',90,2,'Procedimentos de Periodontia'),
			(0414020375,'TRATAMENTO CIRÚRGICO PERIODONTAL (POR SEXTANTE)',90,2,'Procedimentos de Periodontia'),
		--60 Procedimentos de Endodontia por mês, no total, referente aos seguintes códigos:
			(0307020037,'OBTURAÇÃO DE DENTE DECÍDUO',60,2,'Procedimentos de Endodontia'),
			(0307020045,'OBTURAÇÃO EM DENTE PERMANENTE BIRRADICULAR',60,2,'Procedimentos de Endodontia'),
			(0307020053,'OBTURAÇÃO EM DENTE PERMANENTE C/ TRÊS OU MAIS RAÍZES',60,2,'Procedimentos de Endodontia'),
			(0307020061,'OBTURAÇÃO EM DENTE PERMANENTE UNIRRADICULAR',60,2,'Procedimentos de Endodontia'),
			(0307020088,'RETRATAMENTO ENDODÔNTICO EM DENTE PERMANENTE BI-RADICULAR',60,2,'Procedimentos de Endodontia'),
			(0307020096,'RETRATAMENTO ENDODÔNTICO EM DENTE PERMANENTE C/ 3 OU MAIS RAÍZES',60,2,'Procedimentos de Endodontia'),
			(0307020100,'RETRATAMENTO ENDODÔNTICO EM DENTE PERMANENTE UNI-RADICULAR',60,2,'Procedimentos de Endodontia'),
			(0307020118,'SELAMENTO DE PERFURAÇÃO RADICULAR',60,2,'Procedimentos de Endodontia'),
		--90 Procedimentos de Cirurgia Oral por mês, no total, referente aos seguintes códigos:
			(0201010232,'BIÓPSIA DE GLÂNDULA SALIVAR',90,2,'Procedimentos de Cirurgia Oral'),
			(0201010348,'BIÓPSIA DE OSSO DO CRÂNIO E DA FACE',90,2,'Procedimentos de Cirurgia Oral'),
			(0201010526,'BIÓPSIA DOS TECIDOS MOLES DA BOCA',90,2,'Procedimentos de Cirurgia Oral'),
			(0307010058,'TRATAMENTO DE NEVRALGIAS FACIAIS',90,2,'Procedimentos de Cirurgia Oral'),
			(0404020445,'CONTENÇÃO DE DENTES POR SPLINTAGEM',90,2,'Procedimentos de Cirurgia Oral'),
			(0404020488,'OSTEOTOMIA DAS FRATURAS ALVEOLO DENTÁRIAS',90,2,'Procedimentos de Cirurgia Oral'),
			(0404020577,'REDUÇÃO DE FRATURA ALVEOLO-DENTÁRIA SEM OSTEOSSÍNTESE',90,2,'Procedimentos de Cirurgia Oral'),
			(0404020615,'REDUÇÃO DE LUXAÇÃO TÊMPORO MANDIBULAR',90,2,'Procedimentos de Cirurgia Oral'),
			(0404020623,'RETIRADA DE MATERIAL DE SÍNTESE ÓSSEA/ DENTÁRIA',90,2,'Procedimentos de Cirurgia Oral'),
			(0404020674,'RECONSTRUÇÃO PARCIAL DO LÁBIO TRAUMATIZADO',90,2,'Procedimentos de Cirurgia Oral'),
			(0414010345,'EXCISÃO DE CÁLCULO DE GLÂNDULA SALIVAR',90,2,'Procedimentos de Cirurgia Oral'),
			(0414010361,'EXERESE DE CISTO ODONTOGÊNICO E NÃO-ODONTOGÊNICO',90,2,'Procedimentos de Cirurgia Oral'),
			(0414010388,'TRATAMENTO CIRÚRGICO DE FÍSTULA INTRA/ EXTRA-ORAL',90,2,'Procedimentos de Cirurgia Oral'),
			(0401010082,'FRENECTOMIA',90,2,'Procedimentos de Cirurgia Oral'),
			(0404010512,'SINUSOTOMIA TRANSMAXILAR',90,2,'Procedimentos de Cirurgia Oral'),
			(0404020038,'CORREÇÃO CIRÚRGICA DE FÍSTULA ORONASAL/ ORO-SINUSAL',90,2,'Procedimentos de Cirurgia Oral'),
			(0404020054,'DRENAGEM DE ABSCESSO DA BOCA E ANEXOS',90,2,'Procedimentos de Cirurgia Oral'),
			(0404020089,'EXCISÃO DE RÂNULA OU FENÔMENO DE RETENÇÃO SALIVAR',90,2,'Procedimentos de Cirurgia Oral'),
			(0404020097,'EXCISÃO E SUTURA DE LESÃO NA BOCA',90,2,'Procedimentos de Cirurgia Oral'),
			(0404020100,'EXCISÃO EM CUNHA DO LÁBIO',90,2,'Procedimentos de Cirurgia Oral'),
			(0404020313,'RETIRADA DE CORPO ESTRANHO DOS OSSOS DA FACE',90,2,'Procedimentos de Cirurgia Oral'),
			(0404020631,'RETIRADA DE MEIOS DE FIXAÇÃO MA XILO-MANDIBULAR',90,2,'Procedimentos de Cirurgia Oral'),
			(0414010256,'TRATAMENTO CIRÚRGICO DE FÍSTULA ORO-SINUSAL / ORO-NASAL',90,2,'Procedimentos de Cirurgia Oral'),
			(0414020022,'APICECTOMIA C/ OU S/ OBTURAÇÃO RETROGRADA',90,2,'Procedimentos de Cirurgia Oral'),
			(0414020030,'APROFUNDAMENTO DE VESTÍBULO ORAL (POR SEXTANTE)',90,2,'Procedimentos de Cirurgia Oral'),
			(0414020049,'CORREÇÃO DE BRIDAS MUSCULARES',90,2,'Procedimentos de Cirurgia Oral'),
			(0414020057,'CORREÇÃO DE IRREGULARIDADES DE REBORDO ALVEOLAR',90,2,'Procedimentos de Cirurgia Oral'),
			(0414020065,'CORREÇÃO DE TUBEROSIDADE DO MAXILAR',90,2,'Procedimentos de Cirurgia Oral'),
			(0414020073,'CURETAGEM PERIAPICAL',90,2,'Procedimentos de Cirurgia Oral'),
			(0414020090,'ENXERTO ÓSSEO DE ÁREA DOADORA INTRABUCAL',90,2,'Procedimentos de Cirurgia Oral'),
			(0414020146,'EXODONTIA MULTIPLA C/ ALVEOLOPLASTIA POR SEXTANTE',90,2,'Procedimentos de Cirurgia Oral'),
			(0414020170,'GLOSSORRAFIA',90,2,'Procedimentos de Cirurgia Oral'),
			(0414020200,'MARSUPIALIZAÇÃO DE CISTOS E PSEUDOCISTOS',90,2,'Procedimentos de Cirurgia Oral'),
			(0414020219,'ODONTOSECÇÃO / RADILECTOMIA / TUNELIZAÇÃO',90,2,'Procedimentos de Cirurgia Oral'),
			(0414020243,'REIMPLANTE E TRANSPLANTE DENTAL (POR ELEMENTO)',90,2,'Procedimentos de Cirurgia Oral'),
			(0414020278,'REMOÇÃO DE DENTE RETIDO (INCLUSO / IMPACTADO)',90,2,'Procedimentos de Cirurgia Oral'),
			(0414020294,'REMOÇÃO DE TÓRUS E EXOSTOSES',90,2,'Procedimentos de Cirurgia Oral'),
			(0414020359,'TRATAMENTO CIRÚRGICO DE HEMORRAGIA BUCO-DENTAL',90,2,'Procedimentos de Cirurgia Oral'),
			(0414020367,'TRATAMENTO CIRÚRGICO P/ TRACIONAMENTO DENTAL',90,2,'Procedimentos de Cirurgia Oral'),
			(0414020383,'TRATAMENTO DE ALVEOLITE',90,2,'Procedimentos de Cirurgia Oral'),
			(0414020405,'ULOTOMIA/ULECTOMIA',90,2,'Procedimentos de Cirurgia Oral'),
		--Para os CEOs Tipo 3:
		--190 Procedimentos Básicos por mês, no total, referente aos seguintes códigos:
			(0101020058,'APLICAÇÃO DE CARIOSTÁTICO (POR DENTE)',190,3,'Procedimentos Básicos'),
			(0101020066,'APLICAÇÃO DE SELANTE (POR DENTE)',190,3,'Procedimentos Básicos'),
			(0101020074,'APLICAÇÃO TÓPICA DE FLÚOR (INDIVIDUAL POR SESSÃO)',190,3,'Procedimentos Básicos'),
			(0101020082,'EVIDENCIAÇÃO DE PLACA BACTERIANA',190,3,'Procedimentos Básicos'),
			(0101020090,'SELAMENTO PROVISÓRIO DE CAVIDADE DENTÁRIA',190,3,'Procedimentos Básicos'),
			(0307010015,'CAPEAMENTO PULPAR',190,3,'Procedimentos Básicos'),
			(0307010023,'RESTAURAÇÃO DE DENTE DECÍDUO',190,3,'Procedimentos Básicos'),
			(0307010031,'RESTAURAÇÃO DE DENTE PERMANENTE ANTERIOR',190,3,'Procedimentos Básicos'),
			(0307010040,'RESTAURAÇÃO DE DENTE PERMANENTE POSTERIOR',190,3,'Procedimentos Básicos'),
			(0307020070,'PULPOTOMIA DENTÁRIA',190,3,'Procedimentos Básicos'),
			(0307030016,'RASPAGEM ALISAMENTO E POLIMENTO SUPRAGENGIVAIS (POR SEXTANTE)',190,3,'Procedimentos Básicos'),
			(0307030024,'RASPAGEM ALISAMENTO SUBGENGIVAIS (POR SEXTANTE)',190,3,'Procedimentos Básicos'),
			(0414020120,'EXODONTIA DE DENTE DECÍDUO',190,3,'Procedimentos Básicos'),
			(0414020138,'EXODONTIA DE DENTE PERMANENTE',190,3,'Procedimentos Básicos'),
		--150 Procedimentos de Periodontia por mês, no total, referente aos seguintes códigos:
			(0307030032,'RASPAGEM CORONO-RADICULAR (POR SEXTANTE)',150,3,'Procedimentos de Periodontia'),
			(0414020081,'ENXERTO GENGIVAL',150,3,'Procedimentos de Periodontia'),
			(0414020154,'GENGIVECTOMIA (POR SEXTANTE)',150,3,'Procedimentos de Periodontia'),
			(0414020162,'GENGIVOPLASTIA (POR SEXTANTE)',150,3,'Procedimentos de Periodontia'),
			(0414020375,'TRATAMENTO CIRÚRGICO PERIODONTAL (POR SEXTANTE)',150,3,'Procedimentos de Periodontia'),
		--95 Procedimentos de Endodontia por mês, no total, referente aos seguintes códigos:
			(0307020037,'OBTURAÇÃO DE DENTE DECÍDUO',95,3,'Procedimentos de Endodontia'),
			(0307020045,'OBTURAÇÃO EM DENTE PERMANENTE BIRRADICULAR',95,3,'Procedimentos de Endodontia'),
			(0307020053,'OBTURAÇÃO EM DENTE PERMANENTE C/ TRÊS OU MAIS RAÍZES',95,3,'Procedimentos de Endodontia'),
			(0307020061,'OBTURAÇÃO EM DENTE PERMANENTE UNIRRADICULAR',95,3,'Procedimentos de Endodontia'),
			(0307020088,'RETRATAMENTO ENDODÔNTICO EM DENTE PERMANENTE BI-RADICULAR',95,3,'Procedimentos de Endodontia'),
			(0307020096,'RETRATAMENTO ENDODÔNTICO EM DENTE PERMANENTE C/ 3 OU MAIS RAÍZES',95,3,'Procedimentos de Endodontia'),
			(0307020100,'RETRATAMENTO ENDODÔNTICO EM DENTE PERMANENTE UNI-RADICULAR',95,3,'Procedimentos de Endodontia'),
			(0307020118,'SELAMENTO DE PERFURAÇÃO RADICULAR.',95,3,'Procedimentos de Endodontia'),
		--170 Procedimentos de Cirurgia Oral por mês, no total, referente aos seguintes códigos:
			(0201010232,'BIÓPSIA DE GLÂNDULA SALIVAR',170,3,'Procedimentos de Cirurgia Oral'),
			(0201010348,'BIÓPSIA DE OSSO DO CRÂNIO E DA FACE',170,3,'Procedimentos de Cirurgia Oral'),
			(0201010526,'BIÓPSIA DOS TECIDOS MOLES DA BOCA',170,3,'Procedimentos de Cirurgia Oral'),
			(0307010058,'TRATAMENTO DE NEVRALGIAS FACIAIS',170,3,'Procedimentos de Cirurgia Oral'),
			(0404020445,'CONTENÇÃO DE DENTES POR SPLINTAGEM',170,3,'Procedimentos de Cirurgia Oral'),
			(0404020488,'OSTEOTOMIA DAS FRATURAS ALVEOLO DENTÁRIAS',170,3,'Procedimentos de Cirurgia Oral'),
			(0404020577,'REDUÇÃO DE FRATURA ALVEOLO-DENTÁRIA SEM OSTEOSSÍNTESE',170,3,'Procedimentos de Cirurgia Oral'),
			(0404020615,'REDUÇÃO DE LUXAÇÃO TÊMPORO MANDIBULAR',170,3,'Procedimentos de Cirurgia Oral'),
			(0404020623,'RETIRADA DE MATERIAL DE SÍNTESE ÓSSEA/ DENTÁRIA',170,3,'Procedimentos de Cirurgia Oral'),
			(0404020674,'RECONSTRUÇÃO PARCIAL DO LÁBIO TRAUMATIZADO',170,3,'Procedimentos de Cirurgia Oral'),
			(0414010345,'EXCISÃO DE CÁLCULO DE GLÂNDULA SALIVAR',170,3,'Procedimentos de Cirurgia Oral'),
			(0414010361,'EXERESE DE CISTO ODONTOGÊNICO E NÃO-ODONTOGÊNICO',170,3,'Procedimentos de Cirurgia Oral'),
			(0414010388,'TRATAMENTO CIRÚRGICO DE FÍSTULA INTRA/ EXTRA-ORAL',170,3,'Procedimentos de Cirurgia Oral'),
			(0401010082,'FRENECTOMIA',170,3,'Procedimentos de Cirurgia Oral'),
			(0404010512,'SINUSOTOMIA TRANSMAXILAR',170,3,'Procedimentos de Cirurgia Oral'),
			(0404020038,'CORREÇÃO CIRÚRGICA DE FÍSTULA ORONASAL/ ORO-SINUSAL',170,3,'Procedimentos de Cirurgia Oral'),
			(0404020054,'DRENAGEM DE ABSCESSO DA BOCA E ANEXOS',170,3,'Procedimentos de Cirurgia Oral'),
			(0404020089,'EXCISÃO DE RÂNULA OU FENÔMENO DE RETENÇÃO SALIVAR',170,3,'Procedimentos de Cirurgia Oral'),
			(0404020097,'EXCISÃO E SUTURA DE LESÃO NA BOCA',170,3,'Procedimentos de Cirurgia Oral'),
			(0404020100,'EXCISÃO EM CUNHA DO LÁBIO',170,3,'Procedimentos de Cirurgia Oral'),
			(0404020313,'RETIRADA DE CORPO ESTRANHO DOS OSSOS DA FACE',170,3,'Procedimentos de Cirurgia Oral'),
			(0404020631,'RETIRADA DE MEIOS DE FIXAÇÃO MAXILO-MANDIBULAR',170,3,'Procedimentos de Cirurgia Oral'),
			(0414010256,'TRATAMENTO CIRÚRGICO DE FÍSTULA ORO-SINUSAL / ORO-NASAL',170,3,'Procedimentos de Cirurgia Oral'),
			(0414020022,'APICECTOMIA C/ OU S/ OBTURAÇÃO RETROGRADA',170,3,'Procedimentos de Cirurgia Oral'),
			(0414020030,'APROFUNDAMENTO DE VESTÍBULO ORAL (POR SEXTANTE)',170,3,'Procedimentos de Cirurgia Oral'),
			(0414020049,'CORREÇÃO DE BRIDAS MUSCULARES',170,3,'Procedimentos de Cirurgia Oral'),
			(0414020057,'CORREÇÃO DE IRREGULARIDADES DE REBORDO ALVEOLAR',170,3,'Procedimentos de Cirurgia Oral'),
			(0414020065,'CORREÇÃO DE TUBEROSIDADE DO MAXILAR',170,3,'Procedimentos de Cirurgia Oral'),
			(0414020073,'CURETAGEM PERIAPICAL',170,3,'Procedimentos de Cirurgia Oral'),
			(0414020090,'ENXERTO ÓSSEO DE ÁREA DOADORA INTRABUCAL',170,3,'Procedimentos de Cirurgia Oral'),
			(0414020146,'EXODONTIA MULTIPLA C/ ALVEOLOPLASTIA POR SEXTANTE',170,3,'Procedimentos de Cirurgia Oral'),
			(0414020170,'GLOSSORRAFIA',170,3,'Procedimentos de Cirurgia Oral'),
			(0414020200,'MARSUPIALIZAÇÃO DE CISTOS E PSEUDOCISTOS',170,3,'Procedimentos de Cirurgia Oral'),
			(0414020219,'ODONTOSECÇÃO / RADILECTOMIA / TUNELIZAÇÃO',170,3,'Procedimentos de Cirurgia Oral'),
			(0414020243,'REIMPLANTE E TRANSPLANTE DENTAL (POR ELEMENTO)',170,3,'Procedimentos de Cirurgia Oral'),
			(0414020278,'REMOÇÃO DE DENTE RETIDO (INCLUSO / IMPACTADO)',170,3,'Procedimentos de Cirurgia Oral'),
			(0414020294,'REMOÇÃO DE TÓRUS E EXOSTOSES',170,3,'Procedimentos de Cirurgia Oral'),
			(014020359,'TRATAMENTO CIRÚRGICO DE HEMORRAGIA BUCO-DENTAL',170,3,'Procedimentos de Cirurgia Oral'),
			(0414020367,'TRATAMENTO CIRÚRGICO P/ TRACIONAMENTO DENTAL',170,3,'Procedimentos de Cirurgia Oral'),
			(0414020383,'TRATAMENTO DE ALVEOLITE',170,3,'Procedimentos de Cirurgia Oral'),
			(0414020405,'ULOTOMIA/ULECTOMIA',170,3,'Procedimentos de Cirurgia Oral')
	),
	table_count as (
		select
			mes_referencia as competencia,
			case 
				when t1.ceo_codigo = 1  then 1
				when t1.ceo_codigo = 2  then 2
				end as ceo,
			cp.qntceo_mes,	
			cp.referencia_ceo as grupo_procedimento, 
			nm_profissional,
			codigo_procedimento ||' ' || nome_procedimento as cod_procedimento,
			sum(quantidade) as quantidade
		from(
			select
				date_trunc('month', icp.data_lancamento)::date as mes_referencia,
				case 
					when e1.empresa = 258681 then 1
					when e1.empresa = 258683 then 2
					end as ceo_codigo,
				p1.referencia as codigo_procedimento,
				p1.ds_procedimento as nome_procedimento,
				icp.cd_it_conta_paciente as id_atendimento,
				pro.nm_profissional,
				icp.quantidade
			from
				item_conta_paciente icp
				join empresa e1 on e1.empresa = icp.empresa_faturamento
				left join procedimento p1 on p1.cd_procedimento = icp.cd_procedimento
				left join profissional pro on icp.cd_profissional = pro.cd_profissional
			where 
				icp.status = 1 -- apenas finalizada
				and date_trunc('month', icp.data_lancamento)::date = date_trunc('month', current_date - interval '1 month')::date
				--and date_trunc('month', icp.data_lancamento)::date between '2020-01-01'::date and '2021-11-30'::date
				and e1.empresa in (258681,258683)
				and icp.cd_cbo similar to '(2232|3224)%'
		) t1
	left join ceos_procedimento cp on lpad(cp.codceo_procedimento::text,10,'0') = t1.codigo_procedimento and cp.tipo_ceo = t1.ceo_codigo
	group by 1,2,3,4,5,6
	order by 1,2,3,4,5,6
	)
select 
	t2.*,
	round(t2.quantidade_grupo / nullif(t2.qnt_portaria_mes, 0)::decimal, 4) as perc 
from(	
	select
		tc.competencia,
		case 
			when tc.ceo = 1 then 'CEO CENTRO'
			when tc.ceo = 2 then 'CEO CONTINENTE'
			end as ceo,
		tc.nm_profissional,
		tc.grupo_procedimento,
		tc.cod_procedimento,
		tc.quantidade,
		sum(tc.quantidade) over (
			partition by competencia, ceo, grupo_procedimento
			order by competencia, ceo, grupo_procedimento, cod_procedimento
			rows between unbounded preceding and unbounded following
		) as quantidade_grupo,
		tc.qntceo_mes as qnt_portaria_mes
	from
		table_count tc
		left join ceos_procedimento cp2 on lpad(cp2.codceo_procedimento::text,10,'0') = tc.cod_procedimento and cp2.tipo_ceo = tc.ceo
)t2