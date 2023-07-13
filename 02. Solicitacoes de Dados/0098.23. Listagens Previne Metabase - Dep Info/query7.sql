with

	-- Define os quadrimestres
	dia_mes ("q","inicio","fim") as (
		values
			('_Q1','-01-01','-04-30'),
			('_Q2','-05-01','-08-31'),
			('_Q3','-09-01','-12-31')),
 	ano as (
 		select 
 			generate_series(2019,2023,1) as ano),
 	quad as (
	 	select
			ano||q as quad_texto,
			(ano||inicio)::date as inicio_quad,
			(ano||fim)::date as fim_quad
		from 
			dia_mes cross join ano
		where -- Filtro para o quad atual
			(ano||fim)::date >= current_date
			and (ano||inicio)::date <= current_date),
	diabeticos as (
			select 
			uc.cd_usu_cadsus,
			uc.dt_nascimento,
			coalesce(em.descricao, em2.descricao) as unidade,
			coalesce(eqa.cd_area::text, eqa2.cd_area::text) as equipe,
			q.inicio_quad,
			q.fim_quad,
			q.quad_texto,
				max(case
				when
					(a1.cd_cid_principal in ('E10','E100','E101','E102','E103','E104','E105','E106','E107','E108','E109','E11','E110','E111','E112',
'E113','E114','E115','E116','E117','E118','E119','E12','E120','E121','E122','E123','E124','E125','E126','E127','E128','E129','E13','E130',
'E131','E132','E133','E134','E135','E136','E137','E138','E139','E14','E140','E141','E142','E143','E144','E145','E146','E147','E148','E149',
'O240','O241','O242','O243','P702')
						or a1.cd_cid_secundario in ('E10','E100','E101','E102','E103','E104','E105','E106','E107','E108','E109','E11','E110','E111','E112',
'E113','E114','E115','E116','E117','E118','E119','E12','E120','E121','E122','E123','E124','E125','E126','E127','E128','E129','E13','E130',
'E131','E132','E133','E134','E135','E136','E137','E138','E139','E14','E140','E141','E142','E143','E144','E145','E146','E147','E148','E149',
'O240','O241','O242','O243','P702')
						or ciap2.referencia in ('T89','T90'))
					and em_atd.cod_atv = 2
					and a1.dt_atendimento between (q.fim_quad - interval '6 months') and q.fim_quad
					then 1
				else 0
			end)as consulta_6m
		from 
			usuario_cadsus uc 
			left join atendimento a1 on uc.cd_usu_cadsus = a1.cd_usu_cadsus
			left join empresa em_atd on a1.empresa = em_atd.empresa 
			left join endereco_usuario_cadsus euc on uc.cd_endereco = euc.cd_endereco 
			-- Joins para equipe de acompanhamento	
			left join equipe eq on uc.cd_equipe = eq.cd_equipe
			left join equipe_area eqa on eq.cd_equipe_area = eqa.cd_equipe_area
			left join empresa em on eq.empresa = em.empresa 
			-- Joins para equipe definida pelo endereÃ§o estruturado	
			left join endereco_estruturado ee on euc.cd_endereco_estruturado = ee.cd_endereco_estruturado 
			left join equipe_micro_area ema on ema.cd_eqp_micro_area = ee.cd_eqp_micro_area 
			left join equipe_area eqa2 on ema.cd_equipe_area = eqa2.cd_equipe_area 
			left join empresa em2 on ema.empresa = em2.empresa
			-- 
			left join grupo_problemas_condicoes prob on uc.cd_usu_cadsus = prob.cd_usu_cadsus
			left join ciap ciap on prob.cd_ciap = ciap.cd_ciap
			left join ciap ciap2 on a1.cd_ciap = ciap2.cd_ciap
			join quad q on true
		where 
			(a1.cd_cid_principal in ('E10','E100','E101','E102','E103','E104','E105','E106','E107','E108','E109','E11','E110','E111','E112',
'E113','E114','E115','E116','E117','E118','E119','E12','E120','E121','E122','E123','E124','E125','E126','E127','E128','E129','E13','E130',
'E131','E132','E133','E134','E135','E136','E137','E138','E139','E14','E140','E141','E142','E143','E144','E145','E146','E147','E148','E149',
'O240','O241','O242','O243','P702')
			or a1.cd_cid_secundario in ('E10','E100','E101','E102','E103','E104','E105','E106','E107','E108','E109','E11','E110','E111','E112',
'E113','E114','E115','E116','E117','E118','E119','E12','E120','E121','E122','E123','E124','E125','E126','E127','E128','E129','E13','E130',
'E131','E132','E133','E134','E135','E136','E137','E138','E139','E14','E140','E141','E142','E143','E144','E145','E146','E147','E148','E149',
'O240','O241','O242','O243','P702')
			or ciap2.referencia in ('T89','T90')
			or prob.cd_cid in ('E10','E100','E101','E102','E103','E104','E105','E106','E107','E108','E109','E11','E110','E111','E112',
'E113','E114','E115','E116','E117','E118','E119','E12','E120','E121','E122','E123','E124','E125','E126','E127','E128','E129','E13','E130',
'E131','E132','E133','E134','E135','E136','E137','E138','E139','E14','E140','E141','E142','E143','E144','E145','E146','E147','E148','E149',
'O240','O241','O242','O243','P702')
			or ciap.referencia in ('T89','T90'))
			and a1.dt_atendimento >= '2013-01-01'
			and a1.cd_cbo similar to '(225|2231|2235)%'
			and (prob.situacao is null or prob.situacao <> 99)
			and a1.dt_atendimento between (q.fim_quad - interval '2 years') and q.fim_quad
			and uc.st_excluido = 0
			and uc.st_vivo = 1
			and uc.situacao in (0,1)
			and uc.flag_unificado = 0
			and (uc.dt_nascimento + interval '18 years')::date <= q.inicio_quad
		group by 1,2,3,4,5,6,7
		),
		-- Define quais diabeticos fizeram o exame de hemoglobina glicada nos últimos 6 meses
	exame_hbc as (
		select 
			ex.cd_usu_cadsus,
			max(case when ex.dt_cadastro::date is not null then 1 else 0 end) as fez_hbc
		from
			exame ex
			join exame_requisicao er on ex.cd_exame = er.cd_exame
			join exame_procedimento ep on er.cd_exame_procedimento = ep.cd_exame_procedimento
			join empresa e1 on ex.empresa_solicitante = e1.empresa
			join diabeticos dia on dia.cd_usu_cadsus = ex.cd_usu_cadsus 
			join quad q on true
		where
			ep.cd_procedimento = 229
			and ex.dt_cadastro between (q.fim_quad - interval '6 months') and q.fim_quad
			and ex.cd_cbo similar to '(225|2231|2235)%'
			and ex.status <> 7
			and (e1.cod_atv = 2 or e1.empresa in (258687,258681,258683,258685))
		group by 1
		)
		
		select 
			dia.unidade,
			dia.equipe,
			dia.cd_usu_cadsus,
			dia.dt_nascimento,
			dia.quad_texto,
			dia.inicio_quad,
			dia.fim_quad,
			case when dia.consulta_6m = 1 then 'sim' else 'não' end as consulta_6m,
			case when eh.fez_hbc = 1 then 'sim' else 'não'end as hbc_6m,
			case when (case when dia.consulta_6m = 1 and eh.fez_hbc = 1 then 1 else 0 end) = 1 then 'sim' else 'não' end as hbc_e_consulta_6m
		from 
			diabeticos dia
			left join exame_hbc eh on dia.cd_usu_cadsus = eh.cd_usu_cadsus
		