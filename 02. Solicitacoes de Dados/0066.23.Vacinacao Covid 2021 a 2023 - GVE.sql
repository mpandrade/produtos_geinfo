select 
	em.descricao as unidade_aplicacao,
	va.dt_aplicacao::date as dt_aplicacao,
	uc.cd_usu_cadsus as cod_usuario,
	uc.nm_usuario as nome_usuario,
	uc.dt_nascimento as dn,
	extract('year' from age(va.dt_aplicacao::date,uc.dt_nascimento::date))::int as idade_na_aplicacao,
	concat_ws(' ', tlc.ds_tipo_logradouro, euc.nm_logradouro, euc.nr_logradouro, euc.nm_comp_logradouro) as endereco,
	euc.nm_bairro as bairro,
	cid.descricao as cidade,
	tv.ds_vacina as tipo_vacina,
	case
		when va.cd_doses=9 then 'Dose Unica'
		when va.cd_doses=8 then 'Dose'
		when va.cd_doses=1 then 'Dose 1' 
		when va.cd_doses=2 then 'Dose 2' 
		when va.cd_doses=3 then 'Dose 3'
		when va.cd_doses=4 then 'Dose 4'
		when va.cd_doses=5 then 'Dose 5'
		when va.cd_doses=10 then 'Revacinacao'
		when va.cd_doses=7 then '2º Reforço'
		when va.cd_doses=6 then '1º Reforço'
		when va.cd_doses=38 then 'Reforço'
		when va.cd_doses=36 then 'Dose Inicial'
		when va.cd_doses=37 then 'Dose Adicional'
	end as dose,
	case
                when va.grupo_atendimento = 1 then 'INDÍGENAS'
                when va.grupo_atendimento = 2 then 'ASSENTADOS'
                when va.grupo_atendimento = 3 then 'ACAMPADOS'
                when va.grupo_atendimento = 4 then 'MILITARES'
                when va.grupo_atendimento = 5 then 'QUILOMBOLAS'
                when va.grupo_atendimento = 6 then 'POPULAÇÃO PRIVADA DE LIBERDADE'
                when va.grupo_atendimento = 7 then 'POPULAÇÃO GERAL'
                when va.grupo_atendimento = 8 then 'CRIANÇAS'
                when va.grupo_atendimento = 9 then 'GESTANTES'
                when va.grupo_atendimento = 11 then 'PUÉRPERAS'
                when va.grupo_atendimento = 12 then 'IDOSOS'
                when va.grupo_atendimento = 13 then 'FUNCIONÁRIOS DO SISTEMA PRISIONAL'
                when va.grupo_atendimento = 14 then 'COMORBIDADES'
                when va.grupo_atendimento = 15 then 'OUTROS GRUPOS SEM COMORBIDADE'
                when va.grupo_atendimento = 16 then 'DOENÇA RESPIRATÓRIA CRÔNICA'
                when va.grupo_atendimento = 17 then 'DOENÇA CARDÍACA CRÔNICA'
                when va.grupo_atendimento in (18,38) then 'DOENÇA RENAL CRÔNICA'
                when va.grupo_atendimento = 19 then 'DOENÇA HEPÁTICA CRÔNICA'
                when va.grupo_atendimento = 20 then 'DOENÇA NEUROLÓGICA CRÔNICA'
                when va.grupo_atendimento in (21,36) then 'DIABETES'
                when va.grupo_atendimento = 22 then 'OBESOS'
                when va.grupo_atendimento in (23,41) then 'IMUNOSSUPRIMIDOS'
                when va.grupo_atendimento = 24 then 'TRANSPLANTADOS'
                when va.grupo_atendimento = 25 then 'TRISSOMIAS'
                when va.grupo_atendimento = 26 then 'PROFESSORES DO ENSINO BÁSICO'
                when va.grupo_atendimento in (27,31) then 'CAMINHONEIROS'
                when va.grupo_atendimento = 28 then 'TRABALHADORES DO TRANSPORTE COLETIVO'
                when va.grupo_atendimento in (29,33) then 'TRABALHADORES PORTUÁRIOS'
                when va.grupo_atendimento = 30 then 'FORÇAS DE SEGURANÇA E SALVAMENTO'
                when va.grupo_atendimento = 10 and va.dt_aplicacao::date >= to_date('01/02/2021','dd/mm/yyyy') then 'OUTROS'
                when va.grupo_atendimento = 10 and va.dt_aplicacao::date < to_date('01/02/2021','dd/mm/yyyy') then 'TRABALHADORES DE SAUDE'
                when va.grupo_atendimento = 32 then 'COLETIVO RODOVIÁRIO PASSAGEIROS URBANO E DE LONGO CURSO'
                when va.grupo_atendimento = 34 then 'ANEMIA FALCIFORME'
                when va.grupo_atendimento = 35 then 'CÂNCER'
                when va.grupo_atendimento = 37 then 'PORTADOR DE DPOC'
                when va.grupo_atendimento = 39 then 'DOENÇAS CARDIO-CEREBROVASCULARES'
                when va.grupo_atendimento = 40 then 'HIPERTENSÃO GRAVE'
                when va.grupo_atendimento = 41 then 'IMUNOSSUPRIMIDOS'
                when va.grupo_atendimento = 42 then 'OBESIDADE GRAVE'
                when va.grupo_atendimento = 43 then '60 A 64 ANOS'
                when va.grupo_atendimento = 44 then '65 A 69 ANOS'
                when va.grupo_atendimento = 45 then '70 A 74 ANOS'
                when va.grupo_atendimento = 46 then '75 A 79 ANOS'
                when va.grupo_atendimento = 47 then '80 ANOS OU MAIS'
                when va.grupo_atendimento = 48 then 'IDOSOS INSTITUCIONALIZADOS'
                when va.grupo_atendimento = 49 then 'MARINHA'
                when va.grupo_atendimento = 50 then 'EXÉRCITO'
                when va.grupo_atendimento = 51 then 'FORÇA AÉREA'
                when va.grupo_atendimento = 52 then 'BOMBEIRO CIVIL'
                when va.grupo_atendimento = 53 then 'BOMBEIRO MILITAR'
                when va.grupo_atendimento = 54 then 'GUARDA MUNICIPAL'
                when va.grupo_atendimento = 55 then 'POLICIAL ROD. FEDERAL'
                when va.grupo_atendimento = 56 then 'POLICIAL CIVIL'
                when va.grupo_atendimento = 57 then 'POLICIAL FEDERAL'
                when va.grupo_atendimento = 58 then 'POLICIAL MILITAR'
                when va.grupo_atendimento = 59 then 'RIBEIRINHA'
                when va.grupo_atendimento = 60 then 'POVOS INDÍGENAS'
                when va.grupo_atendimento = 61 then 'ENSINO BÁSICO'
                when va.grupo_atendimento = 62 then 'ENSINO SUPERIOR'
                when va.grupo_atendimento = 63 then 'AUXILIAR DE VETERINÁRIO'
                when va.grupo_atendimento = 64 then 'BIÓLOGO'
                when va.grupo_atendimento = 65 then 'BIOMÉDICO'
                when va.grupo_atendimento = 66 then 'COZINHEIRO E AUXILIARES'
                when va.grupo_atendimento = 67 then 'CUIDADOR DE IDOSOS'
                when va.grupo_atendimento = 68 then 'DOULA/PARTEIRA'
                when va.grupo_atendimento = 69 then 'ENFERMEIRO'
                when va.grupo_atendimento = 70 then 'FARMACÊUTICO'
                when va.grupo_atendimento = 71 then 'FISIOTERAPEUTAS'
                when va.grupo_atendimento = 72 then 'FONOAUDIÓLOGO'
                when va.grupo_atendimento = 73 then 'FUNCIONÁRIO DO SIST. FUNERÁRIO'
                when va.grupo_atendimento = 74 then 'MÉDICO'
                when va.grupo_atendimento = 75 then 'MED. VETERINÁRIO'
                when va.grupo_atendimento = 76 then 'MOTORISTA DE AMBULÂNCIA'
                when va.grupo_atendimento = 77 then 'NUTRICIONISTA'
                when va.grupo_atendimento = 78 then 'ODONTOLOGISTA'
                when va.grupo_atendimento = 79 then 'AUX. LIMPEZA'
                when va.grupo_atendimento = 80 then 'EDUCADOR FÍSICO'
                when va.grupo_atendimento = 81 then 'PSICÓLOGO'
                when va.grupo_atendimento = 82 then 'RECEPCIONISTA'
                when va.grupo_atendimento = 83 then 'SEGURANÇA'
                when va.grupo_atendimento = 84 then 'ASSISTENTE SOCIAL'
                when va.grupo_atendimento = 85 then 'TÉC. DE ENFERMAGEM'
                when va.grupo_atendimento = 86 then 'TÉCNICO DE VETERINÁRIO'
                when va.grupo_atendimento = 87 then 'TERAPEUTA OCUP.'
                when va.grupo_atendimento = 88 then 'PROF. TRANSPORTE AÉREO COLETIVO'
                when va.grupo_atendimento = 89 then 'FERROVIÁRIO'
                when va.grupo_atendimento = 90 then 'METROVIÁRIO'
                when va.grupo_atendimento = 91 then 'AQUAVIÁRIO'
                when va.grupo_atendimento = 92 then 'PESSOAS COM DEFICIÊNCIA INSTITUCIONALIZADAS'
                when va.grupo_atendimento = 93 then 'DEFICIÊNCIA GRAVE'
                when va.grupo_atendimento = 94 then 'SITUAÇÃO DE RUA'
                when va.grupo_atendimento = 95 then 'TRAB. INDUSTRIAIS'
                when va.grupo_atendimento = 96 then 'SÍNDROME DE DOWN'
                when va.grupo_atendimento = 97 then 'AUX.DE ENFERMAGEM'
                when va.grupo_atendimento = 98 then 'TÉC. DE ODONTOLOGIA'
                when va.grupo_atendimento = 99 then 'ESTUDANTE'
                when va.grupo_atendimento = 101 then 'PNEUMOPATIAS CRÔNICAS GRAVES'
                when va.grupo_atendimento = 102 then 'HIPERTENSÃO ARTERIAL RESISTENTE (HAR)'
                when va.grupo_atendimento = 103 then 'HIPERTENSÃO ARTERIAL ESTÁGIO 3'
                when va.grupo_atendimento = 104 then 'HIPERTENSÃO ARTERIAL ESTÁGIOS 1 E 2 COM LESÃO EM ÓRGÃO-ALVO E/OU COMORBIDADE'
                when va.grupo_atendimento = 105 then 'INSUFICIÊNCIA CARDÍACA (IC)'
                when va.grupo_atendimento = 106 then 'COR-PULMONALE E HIPERTENSÃO PULMONAR'
                when va.grupo_atendimento = 107 then 'CARDIOPATIA HIPERTENSIVA'
                when va.grupo_atendimento = 108 then 'SÍNDROMES CORONARIANAS'
                when va.grupo_atendimento = 109 then 'VALVOPATIAS'
                when va.grupo_atendimento = 110 then 'MIOCARDIOPATIAS E PERICARDIOPATIAS'
                when va.grupo_atendimento = 111 then 'DOENÇAS DA AORTA, DOS GRANDES VASOS E FÍSTULAS ARTERIOVENOSAS'
                when va.grupo_atendimento = 112 then 'ARRITMIAS CARDÍACAS'
                when va.grupo_atendimento = 113 then 'CARDIOPATIAS CONGÊNITA NO ADULTO'
                when va.grupo_atendimento = 114 then 'PRÓTESES VALVARES E DISPOSITIVOS CARDÍACOS IMPLANTADOS'
                when va.grupo_atendimento = 115 then 'DOENÇA RENAL CRÔNICA'
                when va.grupo_atendimento = 116 then 'HEMOGLOBINOPATIAS GRAVES'
                when va.grupo_atendimento = 117 then 'OBESIDADE MÓRBIDA'
                when va.grupo_atendimento = 118 then 'CIRROSE HEPÁTICA'
                when va.grupo_atendimento = 119 then 'PACIENTES DE 18 A 64 ANOS'
                when va.grupo_atendimento = 120 then 'TRABALHADORES DE LIMPEZA URBANA E MANEJO DE RESÍDUOS SÓLIDOS'
                when va.grupo_atendimento = 121 then 'LACTANTES'
                else 'OUTROS'
                end as grupo_atendimento,
	va.flag_historico as flag_historico
from 
	vac_aplicacao va
	inner join tipo_vacina tv on va.cd_vacina = tv.cd_vacina 
	inner join usuario_cadsus uc on va.cd_usu_cadsus = uc.cd_usu_cadsus 
	left join cidade cid on uc.cd_municipio_residencia = cid.cod_cid 
	left join endereco_usuario_cadsus euc on uc.cd_endereco = euc.cd_endereco
	left join tipo_logradouro_cadsus tlc on euc.cd_tipo_logradouro = tlc.cd_tipo_logradouro 
	left join empresa em on va.empresa = em.empresa
where
	va.dt_aplicacao::date >= '2021-01-01'::date
