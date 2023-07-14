----Cobertura vacinal de Poliomielite inativada e de Pentavalente
with
	quad as (
		select
			inicio_quad,
			fim_quad,
			max_quad,
			to_char(fim_quad,'YYYY')||
				case
					when to_char(fim_quad, 'MM') = '04' then '_Q1'
					when to_char(fim_quad, 'MM') = '08' then '_Q2'
					when to_char(fim_quad, 'MM') = '12' then '_Q3'
				end as quad_texto
			from (
				select
					coalesce((lag(inicio_quad) over()), fim_quad - interval '4 months')::date as inicio_quad,
					(fim_quad - interval '1 day')::date as fim_quad,
					(fim_quad + interval '8 months' - interval '1 day')::date as max_quad
				FROM (
					SELECT
						generate_series(date_trunc('year', current_date - interval '1 year')::date, current_date + interval '1 year', interval '4 months') as inicio_quad,
						generate_series(date_trunc('year', current_date - interval '1 year')::date, current_date + interval '1 year' + interval '4 months', interval '4 months') as fim_quad
				) t1
			) t2
			where --filtra o quad atual na série
				fim_quad >= current_date
				and inicio_quad <= current_date
		),
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
			join quad q on (uc.dt_nascimento + interval '1 year') between q.inicio_quad and q.fim_quad
		where 
			uc.st_excluido = 0
			and uc.st_vivo = 1
			and uc.situacao in (0,1)
			and uc.flag_unificado = 0
			and uc.cd_municipio_residencia = 420540
		group by 1,2,3,4
		),
		vacinas as (
		select
			uc.cd_usu_cadsus,
			max(case when tv.cd_vacina in ('3127216','81982','1550322') then 1 else 0 end) as vip,
			max(case when tv.cd_vacina in ('1550326','81985','1550322') then 1 else 0 end) as penta
		from
			vac_aplicacao va
			join tipo_vacina tv on tv.cd_vacina = va.cd_vacina
			join usuario_cadsus uc on va.cd_usu_cadsus = uc.cd_usu_cadsus
		where
			va.status = 1
			and va.cd_doses = 3 
			and tv.cd_vacina in ('81982','3127216','1550326','81985','1550322') 
		group by 1
		)
select 
	cri.cd_usu_cadsus,
	uc.nm_usuario,
	uc.dt_nascimento,
	uc.nr_telefone,
	uc.nr_telefone_2,
	uc.telefone3,
	uc.telefone4,
	uc.celular,
	concat_ws(' ',euc.nm_logradouro, euc.nr_logradouro, euc.nm_comp_logradouro) as endereco,
	age(uc.dt_nascimento) as idade,
	cri.unidade,
	cri.equipe,
	case when coalesce(vac.vip,0) = 1 then 'Sim' else 'Não' end as vip,
	case when coalesce(vac.penta,0) = 1 then 'Sim' else 'Não' end as penta,
	case when coalesce(vac.vip,0) = 1 and coalesce(vac.penta,0) = 1 then 'Ok!' else 'Vac.Incompleta' end as situacao
from 
	criancas_quad cri
	left join vacinas vac on cri.cd_usu_cadsus = vac.cd_usu_cadsus
	join quad q on true
	join usuario_cadsus uc on cri.cd_usu_cadsus = uc.cd_usu_cadsus 
	left join endereco_usuario_cadsus euc on uc.cd_endereco = euc.cd_endereco