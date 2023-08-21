select 
	uc.cd_usu_cadsus,
	uc.dt_nascimento,
	uc.sg_sexo,
	case when length(uc.cpf) = 11 then 1 else 0 end as fl_cpf_registrado,
	coalesce(em.descricao, em2.descricao,'SEM UNIDADE') as unidade,
	coalesce(eqa.cd_area::text, eqa2.cd_area::text, 'SEM EQUIPE') as equipe,
	euc.nm_bairro,
	case when eqa.cd_area is not null and length(uc.cpf) = 11 then 1 else 0 end as fl_cadastro_completo,
	count(distinct case when a.cd_cbo similar to '(225|2231)%' and e.cod_atv = 2 then a.cd_usu_cadsus::varchar || '|' || a.dt_chegada::date end) as cons_med_aps,
	count(distinct case when a.cd_cbo similar to '(2235)%' and e.cod_atv = 2 then a.cd_usu_cadsus::varchar || '|' || a.dt_chegada::date end) as cons_enf_aps,
	count(distinct case when a.cd_cbo similar to '(2232)%' and e.cod_atv = 2 then a.cd_usu_cadsus::varchar || '|' || a.dt_chegada::date end) as cons_odo_aps,
	count(distinct case when a.cd_cbo similar to '(225|2231|2232|2235)%' and e.cod_atv = 2 and a.dt_atendimento >= date_trunc('month', current_date) - interval '1 year'
		then a.cd_usu_cadsus::varchar || '|' || a.dt_chegada::date end) as cons_m_e_o_1_ano,
	count(distinct case when a.cd_cbo similar to '(225|2231)%' and e.cod_atv = 2 and a.dt_atendimento >= date_trunc('month', current_date) - interval '1 year'
		then a.cd_usu_cadsus::varchar || '|' || a.dt_chegada::date end) as cons_med_aps_ano,
	count(distinct case when a.cd_cbo similar to '(225|2231)%' and e.cod_atv = 73 and a.dt_atendimento >= date_trunc('month', current_date) - interval '1 year'
		then a.cd_usu_cadsus::varchar || '|' || a.dt_chegada::date end) as cons_med_upa_ano
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
	-- Joins para proporção de atendimentos em APS versus UPA e cálculo ativo
	left join atendimento a on a.cd_usu_cadsus = uc.cd_usu_cadsus 
		and a.dt_atendimento between date_trunc('month', current_date) - interval '2 years' and date_trunc('month', current_date)
		and a.status = 4
		and a.cd_cbo similar to '(225|2231|2232|2235)%'
	left join empresa e on e.empresa = a.empresa 
where 
	uc.st_vivo = 1
	and uc.st_excluido = 0
	and uc.cd_municipio_residencia = 420540
	and uc.flag_unificado = 0
	and uc.situacao in (0,1)
	and (e.cod_atv is null or e.cod_atv in (2, 73))
group by 1, 2, 3, 4, 5, 6, 7, 8