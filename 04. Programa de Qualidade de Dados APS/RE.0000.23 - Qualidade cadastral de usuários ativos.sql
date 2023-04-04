-- Avaliação de usuários ativos e qualidade dos cadastros
-- Rodas a query 2x: usar os filtros cod_atv = 2 para APS e somente o CNPJ para todos os serviços

with 
	-- Usuários ativos da APS: último dia do mês passado menos 2 anos
	-- Soma usuários de atendimento, vacinação e dispensação, deduplica com union
	usuarios_aps_sem_filtros as (
		select 
			atd.cd_usu_cadsus as cd_usu_cadsus
		from 
			atendimento atd
			join empresa em on em.empresa = atd.empresa
		where 
			--em.cod_atv = 2
			em.cnpj = '82892282000143'
			and atd.dt_atendimento::date >= date_trunc('month',current_date) - interval '1 day' - interval '2 years'
			and atd.status = 4
		
		union
		
		select
			dm.cd_usu_cadsus_destino as cd_usu_cadsus
		from 
			dispensacao_medicamento dm
			join empresa em on em.empresa = dm.empresa  
		where 
			--em.cod_atv = 2
			em.cnpj = '82892282000143'
			and dm.dt_dispensacao::date >= date_trunc('month',current_date) - interval '1 day' - interval '2 years'
		
		union

		select 
			va.cd_usu_cadsus as cd_usu_cadsus
		
		from 
			vac_aplicacao va 
			join empresa em on em.empresa = va.empresa  
		where 
			--em.cod_atv = 2
			em.cnpj = '82892282000143'
			and va.dt_aplicacao::date >= date_trunc('month',current_date) - interval '1 day' - interval '2 years'
		
		),
	
	-- aplicação de filtros nos usuários ativos, removendo excluídos, óbitos, residentes em outros municípios, etc.
	usuarios_ativos_aps as (
	select
		aps.cd_usu_cadsus 
	from 
		usuarios_aps_sem_filtros aps
		join usuario_cadsus uc on uc.cd_usu_cadsus = aps.cd_usu_cadsus

	where 
    	uc.st_excluido = 0
        and uc.st_vivo = 1
        and uc.situacao in (0,1)
        and uc.flag_unificado = 0
        and uc.cd_municipio_residencia = 420540
 	),
	
 	-- soma o total de usuários ativos
 	denominador as (
		select count(*) as total_usuarios from usuarios_ativos_aps
	),
	
	-- define mês passado
	mes_ano as (
		select to_char(current_date - interval '1 month', 'MM-YYYY') as mes_ano
	),
	
	-- calcular indicadores	
	indicadores as (
		select 
			sum(case when uc.cpf is null or uc.cpf = '' then 1 else 0 end) as sem_cpf,
			sum(case when 
				coalesce(uc.celular,uc.nr_telefone,uc.nr_telefone_2,uc.telefone3,uc.telefone4) is null 
				or coalesce(uc.celular,uc.nr_telefone,uc.nr_telefone_2,uc.telefone3,uc.telefone4) similar to '%(99999999|00000000|88888888)'
				then 1 else 0 end) as sem_telefone,
			sum(case when uc.nm_usuario like 'RN %' then 1 else 0 end) as nome_RN,
			sum(case when uc.situacao = 1 then 1 else 0 end) as cad_provisorio,
			sum(case when uc.cd_equipe is null then 1 else 0 end) as sem_equipe_acomp
		from 
			usuarios_ativos_aps aps 
			join usuario_cadsus uc on aps.cd_usu_cadsus = uc.cd_usu_cadsus  
	)
	
-- exibe mês, indicadores e total de usuários ativos
select 
	ma.mes_ano,	
	ind.*,
	round((ind.sem_cpf::numeric * 100 / den.total_usuarios::numeric),2) as perc_sem_cpf,
	den.total_usuarios
from 
	indicadores ind
	cross join mes_ano ma 
	cross join denominador den