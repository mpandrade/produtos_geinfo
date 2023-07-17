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
			and (ano||inicio)::date <= current_date
    ),
	atend as (
		select 
			atd.cd_usu_cadsus,
			atd.dt_atendimento 
		from 
			atendimento atd 
			join empresa em on atd.empresa = em.empresa 
		where 
			atd.dt_atendimento::date >= (current_date - interval '3 years')
			and em.cod_atv = 2
),
	mulheres_25_64 as (
		select
			uc.cd_usu_cadsus,
			uc.dt_nascimento,
           	coalesce(em.descricao, em2.descricao) as unidade,
			coalesce(eqa.cd_area::text, eqa2.cd_area::text) as equipe,
			q.inicio_quad,
			q.fim_quad,
			q.quad_texto
		from 
			atend a join usuario_cadsus uc on a.cd_usu_cadsus = uc.cd_usu_cadsus 
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
			join quad q on true
		where 
			uc.sg_sexo = 'F'
			and extract('year' from age(uc.dt_nascimento)) between 25 and 64
			and uc.st_vivo = 1
			and uc.st_excluido = 0
			and uc.cd_municipio_residencia = 420540
			and uc.flag_unificado = 0
			and uc.situacao in (0,1)
		),
		mulheres_c_cp as (
		
				select
					distinct (cp.cd_usu_cadsus),
					cp.dt_geracao,
					max(case when cp.dt_geracao is not null then 1 else 0 end) as fez_cp 
				from
					conta_paciente cp
					--inner join mulheres_25_64 mul on cp.cd_usu_cadsus = mul.cd_usu_cadsus
					inner join item_conta_paciente icp on icp.cd_conta_paciente = cp.cd_conta_paciente
					inner join procedimento prc on icp.cd_procedimento = prc.cd_procedimento
					inner join empresa e1 on cp.empresa = e1.empresa
					join quad q on true
				where
					prc.referencia = '0201020033'
					and e1.cod_atv = 2
					and icp.cd_cbo similar to '(225|2231|2235|3222)%'
					and cp.dt_geracao between ( q.fim_quad - interval '3 years') and q.fim_quad
				group  by 1,2
	)
				select
					distinct (fem.cd_usu_cadsus),
					uc.nm_usuario,
					uc.dt_nascimento,
					uc.nr_telefone,
					uc.nr_telefone_2,
					uc.telefone3,
					uc.telefone4,
					uc.celular,
					coalesce(unidade,'SEM UNIDADE') as unidade,
					coalesce(equipe,'SEM EQUIPE')as equipe,
					case when mcp.fez_cp = 1 then 'sim' else 'não'end as fez_cp,
					max(to_char(mcp.dt_geracao, 'dd-mm-yyyy')) as ultimo_cp
				from
					mulheres_25_64 fem
				 	left join mulheres_c_cp mcp on fem.cd_usu_cadsus = mcp.cd_usu_cadsus
				 	left join usuario_cadsus uc on fem.cd_usu_cadsus = uc.cd_usu_cadsus 
				group by 1,2,3,4,5,6,7,8,9,10,11
				
					