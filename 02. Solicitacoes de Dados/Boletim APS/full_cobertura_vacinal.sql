with
	datas as (SELECT
			date_trunc('day', dd)::date as mes,
			(date_trunc('day', dd)::date + interval '1 month' - interval '1 day')::date as eom
		FROM
			generate_series('2021-01-01'::date, current_date::date, '1 month'::interval) dd),
	base_vac as (select
			mes,
		   	coalesce(em.descricao, em2.descricao) as unidade,
			coalesce(eqa.cd_area::text, eqa2.cd_area::text) as equipe,
			uc.cd_usu_cadsus,
			max(case when tv.cd_vacina in ('3127216','81982','1550322') then 1 else 0 end) as criancas_com_vip,
			max(case when tv.cd_vacina in ('1550326','81985','1550322') then 1 else 0 end) as criancas_com_penta
		from 
			datas d
			join usuario_cadsus uc on date_trunc('month', uc.dt_nascimento) = d.mes
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
			-- Joins para produção de CP
			left join vac_aplicacao va on va.cd_usu_cadsus = uc.cd_usu_cadsus 
				and va.status = 1
				and va.cd_doses = 3 
			left join tipo_vacina tv on tv.cd_vacina = va.cd_vacina
		where 
			uc.st_vivo = 1
			and uc.st_excluido = 0
			and uc.cd_municipio_residencia = 420540
			and uc.flag_unificado = 0
			and uc.situacao in (0,1)
		group by 1, 2, 3, 4)
select
	mes,
	unidade,
	equipe,
	count(distinct cd_usu_cadsus) as criancas,
	count(case when criancas_com_vip > 0 then cd_usu_cadsus end) as criancas_com_vip,
	count(case when criancas_com_penta > 0 then cd_usu_cadsus end) as criancas_com_penta,
	count(case when criancas_com_vip > 0 and criancas_com_penta > 0 then cd_usu_cadsus end) as criancas_cobertas
from 
	base_vac
group by 1, 2, 3