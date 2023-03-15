-- adequações no código para cálculo de série histórica:
-- where da CTE quad
-- idade no atendimento
-- dt cadastro menor que o final do quadrimestre - trocado - dt atendimento últimos 3 anos
-- citopatológico entre final do quad e 3 anos anteriores


with

	-- Define os quadrimestres
	dia_mes ("q","inicio","fim") as (
		values
			('_Q1','-01-01','-04-30'),
			('_Q2','-05-01','-08-31'),
			('_Q3','-09-01','-12-31')),
 	ano as (
 		select 
 			generate_series(2019,2022,1) as ano),
 	quad as (
	 	select
			ano||q as quad_texto,
			(ano||inicio)::date as inicio_quad,
			(ano||fim)::date as fim_quad
		from 
			dia_mes cross join ano
		where -- Filtro para o quad atual
			ano||q <> '2022_Q3'
    ),
	atend as (
		select 
			atd.cd_usu_cadsus,
			atd.dt_atendimento 
		from 
			atendimento atd 
			join empresa em on atd.empresa = em.empresa 
		where 
			atd.dt_cadastro::date >= ('2019-04-30'::date - interval '3 years')
			and em.cod_atv = 2
),
	mulheres_25_64 as (
		select
			distinct (uc.cd_usu_cadsus),
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
			-- Joins para equipe definida pelo endereço estruturado	
			left join endereco_estruturado ee on euc.cd_endereco_estruturado = ee.cd_endereco_estruturado 
			left join equipe_micro_area ema on ema.cd_eqp_micro_area = ee.cd_eqp_micro_area 
			left join equipe_area eqa2 on ema.cd_equipe_area = eqa2.cd_equipe_area 
			left join empresa em2 on ema.empresa = em2.empresa
			join quad q on true
		where 
			uc.sg_sexo = 'F'
			and extract('year' from age(a.dt_atendimento::date,uc.dt_nascimento::date)) between 25 and 64
			and uc.st_vivo = 1
			and uc.st_excluido = 0
			and uc.cd_municipio_residencia = 420540
			and uc.flag_unificado = 0
			and uc.situacao in (0,1)
			and uc.dt_cadastro::date <= q.fim_quad
			
		),
		mulheres_c_cp as (
		
				select
					cp.cd_usu_cadsus,
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
					and cp.dt_geracao between (q.fim_quad - interval '3 years') and q.fim_quad
				group  by 1
	)
				select
					coalesce(unidade,'SEM UNIDADE')as unidade,
					coalesce(equipe,'SEM EQUIPE')as equipe,
					fem.quad_texto,
					fem.inicio_quad,
					fem.fim_quad,
					count(fem.cd_usu_cadsus) AS mulheres_25_64,
					sum(mcp.fez_cp) as fez_cp
				from
					mulheres_25_64 fem
				 	left join mulheres_c_cp mcp on fem.cd_usu_cadsus = mcp.cd_usu_cadsus
					
				group by 1,2,3,4,5
				order by 1
					