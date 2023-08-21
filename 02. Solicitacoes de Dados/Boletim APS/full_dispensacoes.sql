select
	date_trunc('month', dt_dispensacao)::date as mes,
	coalesce(em.descricao, em2.descricao,'SEM UNIDADE') as unidade_paciente,
	coalesce(eqa.cd_area::text, eqa2.cd_area::text, 'SEM EQUIPE') as equipe_paciente,
    count(dm.nr_dispensacao) as quantidade
from
    dispensacao_medicamento dm    
    join empresa e1 on dm.empresa = e1.empresa
    join usuario_cadsus uc on dm.cd_usu_cadsus_destino = uc.cd_usu_cadsus 
    left join endereco_usuario_cadsus euc on euc.cd_endereco = uc.cd_endereco
	-- Joins para equipe de acompanhamento	
	left join equipe eq on uc.cd_equipe = eq.cd_equipe
	left join equipe_area eqa on eq.cd_equipe_area = eqa.cd_equipe_area
	left join empresa em on eq.empresa = em.empresa 
	-- Joins para equipe definida pelo endereÃ§o estruturado	
	left join endereco_estruturado ee on euc.cd_endereco_estruturado = ee.cd_endereco_estruturado 
	left join equipe_micro_area ema on ema.cd_eqp_micro_area = ee.cd_eqp_micro_area 
	left join equipe_area eqa2 on ema.cd_equipe_area = eqa2.cd_equipe_area 
	left join empresa em2 on ema.empresa = em2.empresa
where
 	dt_dispensacao::date between date_trunc('month', current_date) - interval '1 year' and date_trunc('month', current_date)
group by 1,2,3