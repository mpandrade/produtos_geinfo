with 
	mulheres as (
	select
		uc.cd_usu_cadsus as cod
	from 
		usuario_cadsus uc  
	where 
		extract('year' from age(uc.dt_nascimento)) between 25 and 64
		and uc.st_excluido = 0
		and uc.flag_unificado = 0
		and uc.situacao in (0,1)
		and uc.sg_sexo = 'F'
	),
	mulheres_atendidas as (
	select
		count(distinct(cod)) as m_25_64_atendidas,
		atv.descricao as tipo_unidade 
	from 
		atendimento atd
		join mulheres m on atd.cd_usu_cadsus = m.cod 
		join empresa em on atd.empresa = em.empresa 
		join atividade atv on em.cod_atv = atv.cod_atv 
	where 
		atv.cod_atv in (73,2,4,70,50)
		and atd.dt_atendimento::date between '2022-10-01'::date and '2022-10-31'::date
	group by 2
	),
	procedimentos as (
		select
			sum(case when p2.cd_procedimento in (1143,1144,419,421,422,423,426) or trt.tp_teste = 2
				then 1 else 0 end) 
				as teste_sifilis,	
			sum(case when p2.cd_procedimento in (1140,1141,315,340,341,412,417) or trt.tp_teste = 0
				then 1 else 0 end) 
				as teste_hiv,		
			sum(case when p2.referencia = '0201020033' then 1 else 0 end) as citopatologico,
			atv.descricao as tipo_unidade
		from 
			atendimento atd 
			join usuario_cadsus uc on uc.cd_usu_cadsus = atd.cd_usu_cadsus 
			left join item_conta_paciente icp on atd.nr_atendimento = icp.nr_atendimento
			left join procedimento p2 on icp.cd_procedimento = p2.cd_procedimento
			left join teste_rapido tr on tr.nr_atendimento = atd.nr_atendimento
			left join teste_rapido_realizado trr on trr.cd_teste_rapido = tr.cd_teste_rapido
			left join teste_rapido_tipo trt on trt.cd_tp_teste = trr.cd_tp_teste
			left join empresa em on atd.empresa = em.empresa 
			left join atividade atv on em.cod_atv = atv.cod_atv 
		where 
			atd.dt_atendimento::date between '2022-10-01'::date and '2022-10-31'::date
			and atv.cod_atv in (73,2,4,70,50)
			and uc.sg_sexo = 'F'
			and uc.st_excluido = 0
			and uc.flag_unificado = 0
			and uc.situacao in (0,1)
		group by 4
			),
	vacinas as (
		select 	
			sum(case when tv.cd_vacina = 1553761 then 1 else 0 end) as vacina_hpv,
			atv.descricao as tipo_unidade
		from 
			vac_aplicacao va 
			left join usuario_cadsus uc on va.cd_usu_cadsus = uc.cd_usu_cadsus 
			left join tipo_vacina tv on tv.cd_vacina = va.cd_vacina
			left join empresa em on va.empresa = em.empresa 
			left join atividade atv on em.cod_atv = atv.cod_atv 
		where
		va.status = 1
		and tv.cd_vacina = 1553761
		and uc.sg_sexo = 'F'
		and uc.st_excluido = 0
		and uc.flag_unificado = 0
		and uc.situacao in (0,1)
		and va.dt_aplicacao::date between '2022-10-01'::date and '2022-10-31'::date
		and atv.cod_atv in (73,2,4,70,50)
		group by 2
	)
	select 
		atv.descricao,
		ma.m_25_64_atendidas,
		pro.citopatologico,
		pro.teste_sifilis,
		pro.teste_hiv,
		vac.vacina_hpv
	from 
		atividade atv 
		left join mulheres_atendidas ma on ma.tipo_unidade = atv.descricao 
		left join procedimentos pro on pro.tipo_unidade = atv.descricao 
		left join vacinas vac on vac.tipo_unidade = atv.descricao 
	order by descricao nulls last