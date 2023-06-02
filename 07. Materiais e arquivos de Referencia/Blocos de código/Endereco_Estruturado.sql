select 
    uc.cd_usu_cadsus,
    coalesce(em.descricao, em2.descricao, 'Sem unidade') as unidade,
	coalesce(eqa.cd_area::text, eqa2.cd_area::text, 'Sem equipe') as equipe
from
    usuario_cadsus uc 
    left join atendimento a1 on uc.cd_usu_cadsus = a1.cd_usu_cadsus
    left join empresa em_atd on a1.empresa = em_atd.empresa 
    left join endereco_usuario_cadsus euc on uc.cd_endereco = euc.cd_endereco 
    -- Joins para equipe de acompanhamento	
    left join equipe eq on uc.cd_equipe = eq.cd_equipe
    left join equipe_area eqa on eq.cd_equipe_area = eqa.cd_equipe_area
    left join empresa em on eq.empresa = em.empresa 
    -- Joins para equipe definida pelo endereço estruturado	
    left join endereco_estruturado ee on euc.cd_endereco_estruturado = ee.cd_endereco_estruturado 
    left join equipe_micro_area ema on ema.cd_eqp_micro_area = ee.cd_eqp_micro_area 
    left join equipe_area eqa2 on ema.cd_equipe_area = eqa2.cd_equipe_area 
    left join empresa em2 on ema.empresa = em2.empresa
