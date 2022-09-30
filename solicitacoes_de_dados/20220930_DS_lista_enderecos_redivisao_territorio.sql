select
	distinct(uc.cd_usu_cadsus) as cod_usuario,
	upper(tlc.ds_tipo_logradouro) || ' ' || upper(euc.nm_logradouro) as logradouro,
	upper(euc.nr_logradouro) as num,
	upper(euc.nm_bairro) as bairro,
	em.descricao as unidade_acompanhamento,
	em2.descricao as unidade_endereco,
	eqa.cd_area as equipe_acompanhamento,
	eqa2.cd_area as equipe_endereco,
	ema.micro_area as micro_area
from
	usuario_cadsus uc
	left join endereco_usuario_cadsus euc on uc.cd_endereco = euc.cd_endereco
	left join tipo_logradouro_cadsus tlc on euc.cd_tipo_logradouro = tlc.cd_tipo_logradouro
	join atendimento atd on uc.cd_usu_cadsus = atd.cd_usu_cadsus
	join empresa em3 on atd.empresa = em3.empresa
			
	left join equipe eq on uc.cd_equipe = eq.cd_equipe
	left join equipe_area eqa on eq.cd_equipe_area = eqa.cd_equipe_area
	left join empresa em on eq.empresa = em.empresa
			
	left join endereco_estruturado ee on euc.cd_endereco_estruturado = ee.cd_endereco_estruturado
	left join equipe_micro_area ema on ema.cd_eqp_micro_area = ee.cd_eqp_micro_area
	left join equipe_area eqa2 on ema.cd_equipe_area = eqa2.cd_equipe_area
	left join empresa em2 on ema.empresa = em2.empresa
where atd.dt_atendimento::date >= (current_date - interval '2 years')
	and euc.cod_cid = 420540
	and uc.st_vivo = 1
	and uc.situacao in (0,1) -- Ativo, provisório
	and uc.st_excluido = 0
	and uc.flag_unificado = 0

union

select
	distinct(uc.cd_usu_cadsus) as cod_usuario,
	upper(tlc.ds_tipo_logradouro) || ' ' || upper(euc.nm_logradouro) as logradouro,
	upper(euc.nr_logradouro) as num,
	upper(euc.nm_bairro) as bairro,
	em.descricao as unidade_acompanhamento,
	em2.descricao as unidade_endereco,
	eqa.cd_area as equipe_acompanhamento,
	eqa2.cd_area as equipe_endereco,
	ema.micro_area as micro_area
from
	usuario_cadsus uc
	left join endereco_usuario_cadsus euc on uc.cd_endereco = euc.cd_endereco
	left join tipo_logradouro_cadsus tlc on euc.cd_tipo_logradouro = tlc.cd_tipo_logradouro
	join vac_aplicacao va on uc.cd_usu_cadsus = va.cd_usu_cadsus
	join empresa em3 on va.empresa = em3.empresa

	left join equipe eq on uc.cd_equipe = eq.cd_equipe
	left join equipe_area eqa on eq.cd_equipe_area = eqa.cd_equipe_area
	left join empresa em on eq.empresa = em.empresa

	left join endereco_estruturado ee on euc.cd_endereco_estruturado = ee.cd_endereco_estruturado
	left join equipe_micro_area ema on ema.cd_eqp_micro_area = ee.cd_eqp_micro_area
	left join equipe_area eqa2 on ema.cd_equipe_area = eqa2.cd_equipe_area
	left join empresa em2 on ema.empresa = em2.empresa
where va.dt_aplicacao::date >= (current_date - interval '2 years'
	and euc.cod_cid = 420540
	and uc.st_vivo = 1
	and uc.situacao in (0,1) -- Ativo,provisório
	and uc.st_excluido = 0
	and uc.flag_unificado = 0

union

select
	distinct(uc.cd_usu_cadsus) as cod_usuario,
	upper(tlc.ds_tipo_logradouro) || ' ' || upper(euc.nm_logradouro) as logradouro,
	upper(euc.nr_logradouro) as num,
	upper(euc.nm_bairro) as bairro,
	em.descricao as unidade_acompanhamento,
	em2.descricao as unidade_endereco,
	eqa.cd_area as equipe_acompanhamento,
	eqa2.cd_area as equipe_endereco,
	ema.micro_area as micro_area
from
	usuario_cadsus uc
	left join endereco_usuario_cadsus euc on uc.cd_endereco = euc.cd_endereco
	left join tipo_logradouro_cadsus tlc on euc.cd_tipo_logradouro = tlc.cd_tipo_logradouro
	join dispensacao_medicamento dm on uc.cd_usu_cadsus = dm.cd_usu_cadsus_destino
	join empresa em3 on dm.empresa = em3.empresa
			
	left join equipe eq on uc.cd_equipe = eq.cd_equipe
	left join equipe_area eqa on eq.cd_equipe_area = eqa.cd_equipe_area
	left join empresa em on eq.empresa = em.empresa
			
	left join endereco_estruturado ee on euc.cd_endereco_estruturado = ee.cd_endereco_estruturado
	left join equipe_micro_area ema on ema.cd_eqp_micro_area = ee.cd_eqp_micro_area
	left join equipe_area eqa2 on ema.cd_equipe_area = eqa2.cd_equipe_area
	left join empresa em2 on ema.empresa = em2.empresa
where dm.dt_dispensacao::date >= (current_date - interval '2 years')
	and euc.cod_cid = 420540
	and uc.st_vivo = 1
	and uc.situacao in (0,1) -- Ativo,provisório
	and uc.st_excluido = 0
	and uc.flag_unificado = 0
