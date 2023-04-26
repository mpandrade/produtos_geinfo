with 
	subempresa (codigo, empresa) as (values
       	(1,257551),(2,257553),(3,257555),(4,257557),(5,257559),(6,257561),(7,257563),(8,257565),(9,257567),(10,257569),
		(11,257571),(12,257573),(13,257575),(14,257577),(15,257579),(16,257581),(17,257583),(18,257585),(19,257587),(20,257589),
		(21,257591),(22,257593),(23,257595),(24,257597),(25,257599),(26,257601),(27,257603),(28,257605),(29,257607),(30,257609),
		(31,257611),(32,257613),(33,257615),(34,257617),(35,257619),(36,257621),(37,257623),(38,257625),(39,257627),(40,257629),
		(41,257631),(42,257633),(43,257635),(44,257637),(45,257639),(46,257641),(47,257643),(48,257645),(49,257647),(101,457501398)
		-- Atribuído código 101 ao CS Capivari
	)
select
	uc.cd_usu_cadsus as "Identificacao do Beneficiario",
	case when uc.cpf is not null and uc.cpf <> '' then uc.cpf else null end as "Login do Beneficiario", -- Há usuários sem CPF
	uc.nm_usuario as "Nome",
	case when uc.cpf is not null and uc.cpf <> '' then uc.cpf else null end as "CPF", -- Há usuários sem CPF
	coalesce(to_char(uc.dt_nascimento, 'dd/mm/yyyy'),'01/01/1990') as "DataNascimento",
	uc.sg_sexo as "Sexo",
	1 as "Tipo do Beneficiario",
	uc.email as "Email",
	case 
		when euc.nm_comp_logradouro is null 
		then upper(concat_ws(' ', tlc.ds_tipo_logradouro, euc.nm_logradouro, coalesce(euc.nr_logradouro::text, 'S/N'))) 
	    else upper(concat_ws(' ', tlc.ds_tipo_logradouro, euc.nm_logradouro, coalesce(euc.nr_logradouro::text, 'S/N'),'-', euc.nm_comp_logradouro)) 
		end as "LogradouroResidencial",
	euc.cep as "CEPResidencial",
	euc.nm_bairro as "BairroResidencial",
	c.descricao as "MunicipioResidencial",
	e.sigla as "EstadoResidencial",
	case when uc.flag_estrangeiro = 3 then n.ds_pais else 'BRASIL' end as "PaisResidencial",
	coalesce(uc.nr_telefone, uc.nr_telefone_2, uc.telefone3, uc.telefone4) as "TelefoneResidencial", -- Há 4 campos de telefone, sem identificação entre residencial/comercial
	coalesce(uc.nr_telefone, uc.nr_telefone_2, uc.telefone3, uc.telefone4) as "TelefoneComercial", -- Há 4 campos de telefone, sem identificação entre residencial/comercial
	uc.celular as "TelefoneCelular",
	case when uc.situacao = 0 then 'A' else 'I' end as "StatusBeneficiario ",
	'161' as "IdentificacaoCliente",
	coalesce(se1.codigo, se2.codigo) as "CodigoSubempresa",
	'1' as "IndentificacaoProduto",
	coalesce(eqa.cd_area::text, eqa2.cd_area::text) as "Equipe (antes coluna TAG)",
	NULL as "WhatsappEquipe", -- Extrair dado do JSON
	(select min(ucc.cd_numero_cartao) from usuario_cadsus_cns ucc where ucc.cd_usu_cadsus = uc.cd_usu_cadsus and ucc.st_excluido = 0) as "CNS", -- Aplicado método de deduplicação de CNS
	uc.nm_mae as "Nome da Mae",
	uc.apelido as "Nome Social"
from
	-- dados do usuario
	usuario_cadsus uc
	-- endereco padrao
	left join endereco_usuario_cadsus euc on euc.cd_endereco = uc.cd_endereco
	-- dados complementares
	left join tipo_logradouro_cadsus tlc on tlc.cd_tipo_logradouro = euc.cd_tipo_logradouro
	left join cidade c on c.cod_cid = euc.cod_cid
	left join estado e on c.cod_est = e.cod_est 
	left join nacionalidade n on uc.cd_pais_nascimento = n.cd_pais 
	-- Equipe de acompanhamento	
	left join equipe eq on uc.cd_equipe = eq.cd_equipe
	left join equipe_area eqa on eq.cd_equipe_area = eqa.cd_equipe_area
	left join subempresa se1 on eq.empresa = se1.empresa 
	-- Equipe definida pelo endereço estruturado	
	left join endereco_estruturado ee on euc.cd_endereco_estruturado = ee.cd_endereco_estruturado 
	left join equipe_micro_area ema on ema.cd_eqp_micro_area = ee.cd_eqp_micro_area 
	left join equipe_area eqa2 on ema.cd_equipe_area = eqa2.cd_equipe_area 
	left join subempresa se2 on ema.empresa = se2.empresa
where
	uc.situacao in (0,2) -- Inclui cadastros ativos e inativos, exclui cadastros provisórios
		