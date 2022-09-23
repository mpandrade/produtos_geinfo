select 
	distinct(uc.cd_usu_cadsus)::text as cod,
	upper(tlc.ds_tipo_logradouro) || ' ' || upper(euc.nm_logradouro) as logradouro,
	upper(euc.nr_logradouro) as num,
	upper(euc.nm_bairro) as bairro,
	coalesce(em.descricao, em2.descricao, 'SEM UNIDADE') as unidade,
	coalesce(eqa.cd_area::text, eqa2.cd_area::text, 'SEM EQUIPE') as equipe,
	case when uc.cpf = '' or uc.cpf is null then 'NÃO' else 'SIM' end as tem_cpf
from
	usuario_cadsus uc 
	left join endereco_usuario_cadsus euc on uc.cd_endereco = euc.cd_endereco 
	left join tipo_logradouro_cadsus tlc on euc.cd_tipo_logradouro = tlc.cd_tipo_logradouro 
	join atendimento atd on uc.cd_usu_cadsus = atd.cd_usu_cadsus
	join empresa em3 on atd.empresa = em3.empresa 
	-- Joins para equipe de acompanhamento	
	left join equipe eq on uc.cd_equipe = eq.cd_equipe
	left join equipe_area eqa on eq.cd_equipe_area = eqa.cd_equipe_area
	left join empresa em on eq.empresa = em.empresa 
	-- Joins para equipe definida pelo endereço estruturado	
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
and (
	coalesce(eqa.cd_area::text, eqa2.cd_area::text, 'SEM EQUIPE') = 'SEM EQUIPE' 
	or 
	case when uc.cpf = '' or uc.cpf is null then 'NÃO' else 'SIM' end = 'NÃO'
	)
