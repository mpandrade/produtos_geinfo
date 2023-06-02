select 
    uc.nm_usuario as nome_paciente,
    uc.dt_nascimento as dt_nascimento,
    uc.sg_sexo as sexo,
    cns.cd_numero_cartao as cns,
    uc.cpf as cpf,
    uc.nr_telefone as telefone1,
    uc.nr_telefone_2 as telefone2,
    uc.telefone3 as telefone3,
    uc.telefone4 as telefone4,
    uc.celular as celular,
    upper(tlc.ds_tipo_logradouro) || ' ' || upper(euc.nm_logradouro) as logradouro,
    euc.nr_logradouro as numero,
    upper(euc.nm_comp_logradouro) as complemento,
    upper(euc.nm_bairro) as bairro,
    c.descricao as municipio,
    e.sigla as estado			
from
    usuario_cadsus uc 
    left join usuario_cadsus_cns cns on uc.cd_usu_cadsus = cns.cd_usu_cadsus and cns.st_excluido = 0
    left join endereco_usuario_cadsus euc on uc.cd_endereco = euc.cd_endereco 
    left join tipo_logradouro_cadsus tlc on euc.cd_tipo_logradouro = tlc.cd_tipo_logradouro 
    left join cidade c on euc.cod_cid = c.cod_cid 
    left join estado e on c.cod_est = e.cod_est 
