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
	
	
	--Define o total de hipertensos em 2 anos e quem consultou nos últimos 6 meses
	hipertensos as (
		select 
			uc.cd_usu_cadsus,
			uc.dt_nascimento,
			coalesce(em.descricao, em2.descricao, 'Sem unidade') as unidade,
			coalesce(eqa.cd_area::text, eqa2.cd_area::text, 'Sem equipe') as equipe,
			q.inicio_quad,
			q.fim_quad,
			q.quad_texto,
			(q.fim_quad - interval '6 months')::date as inicio_semestre,
			max(case
				when
					(a1.cd_cid_principal in ('I10','I11','I110','I119','I12','I120','I129','I13','I130','I131',
											 'I132','I139','I15','I150','I151','I152','I158','I159','O10','O100',
											 'O101','O102','O103','O104','O109','O11')
					or a1.cd_cid_secundario in ('I10','I11','I110','I119','I12','I120','I129','I13','I130','I131',
											 'I132','I139','I15','I150','I151','I152','I158','I159','O10','O100',
											 'O101','O102','O103','O104','O109','O11')
					or ciap2.referencia in ('K86','K87'))
					and em_atd.cod_atv = 2
					and a1.dt_atendimento >= q.fim_quad - interval '6 months'
					then 1
				else 0
			end) as consulta_6m		
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
			-- 
			left join grupo_problemas_condicoes prob on uc.cd_usu_cadsus = prob.cd_usu_cadsus
			left join ciap ciap on prob.cd_ciap = ciap.cd_ciap
			left join ciap ciap2 on a1.cd_ciap = ciap2.cd_ciap
			join quad q on true
		where 
			(a1.cd_cid_principal in ('I10','I11','I110','I119','I12','I120','I129','I13','I130','I131',
				'I132','I139','I15','I150','I151','I152','I158','I159','O10','O100','O101','O102','O103','O104','O109','O11')
			or a1.cd_cid_secundario in ('I10','I11','I110','I119','I12','I120','I129','I13','I130','I131',
				'I132','I139','I15','I150','I151','I152','I158','I159','O10','O100','O101','O102','O103','O104','O109','O11')
			or ciap2.referencia in ('K86','K87')
			or prob.cd_cid in ('I10','I11','I110','I119','I12','I120','I129','I13','I130','I131',
				'I132','I139','I15','I150','I151','I152','I158','I159','O10','O100','O101','O102','O103','O104','O109','O11')
			or ciap.referencia in ('K86','K87'))
			and a1.cd_cbo similar to '(225|2231|2235)%'
			and a1.dt_atendimento >= '2013-01-01'
			and (uc.dt_nascimento + interval '18 years')::date <= q.inicio_quad
			and a1.dt_atendimento >= q.fim_quad - interval '2 years'
			and (prob.situacao is null or prob.situacao <> 99)
			and uc.st_excluido = 0
            and uc.st_vivo = 1
            and uc.situacao in (0,1)
			and uc.flag_unificado = 0
		group by 1,2,3,4,5,6,7,8
	),
	
	-- Define quais hipertensos aferiram a pressão nos últimos 6 meses
	afericao_pa as (
		select 
			cp.cd_usu_cadsus,
			max(case when cp.dt_geracao::date is not null then 1 else 0 end) as aferiu_pa
		from
			conta_paciente cp
			join item_conta_paciente icp on icp.cd_conta_paciente = cp.cd_conta_paciente
			join procedimento prc on icp.cd_procedimento = prc.cd_procedimento
			join empresa e1 on cp.empresa = e1.empresa
			join hipertensos hip on hip.cd_usu_cadsus = cp.cd_usu_cadsus 
			join quad q on true
		where
			prc.referencia = '0301100039'
			and icp.cd_cbo similar to '(225|2231|2235|3222)%'
			and cp.dt_geracao::date >= (q.fim_quad - '6 months'::interval)::date
			and e1.cod_atv = 2	
		group by 1
	)
select 
	has.unidade,
	has.equipe,
	has.cd_usu_cadsus as codigo_usuario,
	uc.nm_usuario,
	has.dt_nascimento as data_nasc,
	uc.nr_telefone,
   	uc.nr_telefone_2,
   	uc.telefone3,
   	uc.telefone4,
   	uc.celular,
	has.quad_texto,
	has.inicio_quad,
	has.fim_quad,
	case when has.consulta_6m = 1 then 'sim' else 'não' end as consulta_6m,
	case when pa.aferiu_pa = 1 then 'sim' else 'não'end as pa_6m,
	case when (case when has.consulta_6m = 1 and pa.aferiu_pa = 1 then 1 else 0 end) = 1 then 'sim' else 'não' end as pa_e_consulta_6m
from 
	hipertensos has
	left join afericao_pa pa on has.cd_usu_cadsus = pa.cd_usu_cadsus
	join usuario_cadsus uc on has.cd_usu_cadsus = uc.cd_usu_cadsus 
