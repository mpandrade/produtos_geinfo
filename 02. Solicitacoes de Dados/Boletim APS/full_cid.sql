select 
	coalesce(em.descricao, em2.descricao,'SEM UNIDADE') as unidade,
	coalesce(eqa.cd_area::text, eqa2.cd_area::text, 'SEM EQUIPE') as equipe,
	left(a.cd_cid_principal, 3) as cid,
	count(distinct a.cd_usu_cadsus::varchar || '|' || a.dt_chegada::date) as consultas
from 
	atendimento a 
	join empresa e on e.empresa = a.empresa
	join usuario_cadsus uc on uc.cd_usu_cadsus = a.cd_usu_cadsus 
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
	a.dt_atendimento between date_trunc('month', current_date) - interval '1 years'
		and date_trunc('month', current_date)
	and a.status = 4
	and a.cd_cbo similar to '(225|2231)%'
	and uc.st_vivo = 1
	and uc.st_excluido = 0
	and uc.cd_municipio_residencia = 420540
	and uc.flag_unificado = 0
	and uc.situacao in (0,1)
	and e.cod_atv = 2
group by 1, 2, 3