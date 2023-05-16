select 
	euc.nm_bairro as nome_bairro,
	euc.nm_logradouro as nome_rua,
	extract('year' from age(uc.dt_nascimento)) as idade,
	count(uc.cd_usu_cadsus) as quant_criancas
from 
	usuario_cadsus uc 
	join endereco_usuario_cadsus euc on uc.cd_endereco = euc.cd_endereco 
where 
	uc.cd_municipio_residencia = 420540
	and extract('year' from age(uc.dt_nascimento)) between 0 and 15
	and uc.flag_unificado = 0
	and uc.st_vivo = 1
	and uc.situacao in (0,1)
	and uc.dt_cadastro::date >= '2019-03-01'::date
group by 1,2,3
order by 1,2,3


--- versão 2


select 
	euc.nm_bairro as nome_bairro,
	euc.nm_logradouro as nome_rua,
	coalesce(em.descricao, em2.descricao, 'Não informada') as unidade_referencia,
	extract('year' from age(uc.dt_nascimento)) as idade,
	count(uc.cd_usu_cadsus) as quant_criancas
from 
	usuario_cadsus uc 
    		left join endereco_usuario_cadsus euc on euc.cd_endereco = uc.cd_endereco
			-- Joins para equipe de acompanhamento	
			left join equipe eq on uc.cd_equipe = eq.cd_equipe
			left join equipe_area eqa on eq.cd_equipe_area = eqa.cd_equipe_area
			left join empresa em on eq.empresa = em.empresa 
			-- Joins para equipe definida pelo endereço estruturado	
			left join endereco_estruturado ee on euc.cd_endereco_estruturado = ee.cd_endereco_estruturado 
			left join equipe_micro_area ema on ema.cd_eqp_micro_area = ee.cd_eqp_micro_area 
			left join equipe_area eqa2 on ema.cd_equipe_area = eqa2.cd_equipe_area 
			left join empresa em2 on ema.empresa = em2.empresa
where 
	uc.cd_municipio_residencia = 420540
	and extract('year' from age(uc.dt_nascimento)) between 0 and 15
	and uc.flag_unificado = 0
	and uc.st_vivo = 1
	and uc.situacao in (0,1)
	and uc.dt_cadastro::date between '2019-03-01'::date and '2023-05-14'::date
group by 1,2,3,4
order by 1,2,3
