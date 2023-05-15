/*
	Proporção de crianças de 1 (um) ano de idade vacinadas na APS contra 
	Difteria, Tétano, Coqueluche, Hepatite B, infecções causadas por 
	Haemophilus Influenzae tipo B e Poliomielite Inativada.
	
	SÉRIE HISTÓRICA POR QUADIMESTRE
	
*/

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
			
		-- SELECIONAR AQUI O QUADRIMESTRE
		where 
			(ano||fim)::date < current_date
			and (ano||fim)::date > (current_date - interval '4 months')::date),


	-- Seleciona crianças que completam 1 ano no Quadrimestre e vinculam a Unidade e Equipe
	criancas_quad as (
		select 
			uc.cd_usu_cadsus,
			uc.dt_nascimento,
			coalesce(em.descricao, em2.descricao, 'Sem unidade') as unidade,
			coalesce(eqa.cd_area::text, eqa2.cd_area::text, 'Sem equipe') as equipe,
			count(uc.cd_usu_cadsus) as quant_criancas
		from 
			usuario_cadsus uc 
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
			uc.st_excluido = 0
			and uc.st_vivo = 1
			and uc.situacao in (0,1)
			and uc.flag_unificado = 0
			and uc.cd_municipio_residencia = 420540
			and (uc.dt_nascimento + interval '1 year') between q.inicio_quad and q.fim_quad
		group by 1,2,3,4),
		
	-- Seleciona vacinas por tipo, associa com criança
	-- Como é situação anterior, é utilizado um filtro para a data da aplicação até fim do quadrimestre selecionado
	vacinas as (
		select
			uc.cd_usu_cadsus,
			max(case when tv.cd_vacina in ('3127216','81982') then 1 else 0 end) as vip,
			max(case when tv.cd_vacina in ('1550326','81985') then 1 else 0 end) as penta
		from
			vac_aplicacao va
			join tipo_vacina tv on tv.cd_vacina = va.cd_vacina
			join usuario_cadsus uc on va.cd_usu_cadsus = uc.cd_usu_cadsus
			join quad q on true
		where
			va.status = 1
			and va.cd_doses = 3 
			and tv.cd_vacina in ('81982','3127216','1550326','81985') 
			and va.dt_aplicacao::date <= q.fim_quad
		group by 1),
		
		
	-- Define o total de crianças do quadrimestre como o denominador por Unidade
	denominador as (
		select 
			count(*) as denominador,
			unidade
		from 
			criancas_quad
		group by 2)

-- Saída de dados
select 
	q.quad_texto,
	cri.unidade,
	count(cri.cd_usu_cadsus) as numerador,
	den.denominador
from 
	criancas_quad cri
	left join vacinas vac on cri.cd_usu_cadsus = vac.cd_usu_cadsus
	join quad q on true
	join denominador den on den.unidade = cri.unidade
where coalesce(vac.vip,0) = 1 and coalesce(vac.penta,0) = 1
group by 1,2,4