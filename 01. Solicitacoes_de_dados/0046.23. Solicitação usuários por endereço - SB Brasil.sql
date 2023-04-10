select 
	uc.cd_usu_cadsus as cod_usuario,
	uc.nm_usuario as nome_usuario,
	uc.sg_sexo as sexo,
	uc.cpf,
	to_char(uc.dt_nascimento, 'dd/MM/YYYY') as dt_nascimento,
	uc.nr_telefone,
	uc.nr_telefone_2,
	uc.telefone3,
	uc.telefone4,
	uc.celular,
	tlc.ds_tipo_logradouro as tipo_logradouro,
	euc.nm_logradouro as nome_logradouro,
	euc.nr_logradouro as numero,
	euc.nm_bairro as bairro
from 	
	usuario_cadsus uc
	join endereco_usuario_cadsus euc on uc.cd_endereco = euc.cd_endereco
	join tipo_logradouro_cadsus tlc on euc.cd_tipo_logradouro = tlc.cd_tipo_logradouro 
where 
	upper(euc.nm_logradouro) like '%AMARO ANT_NIO VIEIRA%'
	and euc.nr_logradouro in ('2651','2623')