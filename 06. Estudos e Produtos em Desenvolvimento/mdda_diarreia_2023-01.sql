with 
	mdda as (
		select 
			atd.nr_atendimento,
			'Sim' as mdda,
			em.descricao as unidade_atendimento,
			coalesce(em1.descricao, em2.descricao) as unidade_referencia,
			coalesce(right(eqa.ds_area,3), right(eqa2.ds_area,3)) as equipe_referencia,
			atd.dt_atendimento::date as dt_atendimento,
			atd.dt_atendimento::time as hora_atendimento,
			uc.nm_usuario as nome_paciente,
			uc.dt_nascimento as dt_nascimento,
			extract(year from age(atd.dt_atendimento::date,uc.dt_nascimento::date)) as idade_no_atendimento,
			cns.cd_numero_cartao as cns,
			uc.cpf as cpf,
			uc.nr_telefone as telefone1,
			uc.nr_telefone_2 as telefone2,
			uc.telefone3 as telefone3,
			uc.telefone4 as telefone4,
			upper(tlc.ds_tipo_logradouro) || ' ' || upper(euc.nm_logradouro) as logradouro,
			euc.nr_logradouro as numero,
			upper(euc.nm_comp_logradouro) as complemento,
			upper(euc.nm_bairro) as bairro,
			c2.descricao as municipio,
			e.sigla as estado,
			atd.cd_cid_principal as cod_cid, 
			cid1.nm_cid as cid,
			atd.cd_cid_secundario as cod_cid_secund,
			cid2.nm_cid as cid_secund,
			case when mdda.com_sangue = 0 then 'Não' else 'Sim' end as diarreia_com_sangue,
			(mdda.dt_primeiros_sintomas::date)::text as dt_primeiros_sintomas,
			mdda.plano_tratamento as plano_tratamento,
			mdda.resultado_exame_lab as resultado_exame
		from 
			atendimento_mdda mdda
			join atendimento atd on atd.nr_atendimento = mdda.nr_atendimento 
			join empresa em on atd.empresa = em.empresa 
			join usuario_cadsus uc on atd.cd_usu_cadsus = uc.cd_usu_cadsus 
			left join usuario_cadsus_cns cns on uc.cd_usu_cadsus = cns.cd_usu_cadsus and cns.st_excluido = 0
			left join endereco_usuario_cadsus euc on uc.cd_endereco = euc.cd_endereco 
			left join tipo_logradouro_cadsus tlc on euc.cd_tipo_logradouro = tlc.cd_tipo_logradouro 
			-- Joins para equipe de acompanhamento	
			left join equipe eq on uc.cd_equipe = eq.cd_equipe
			left join equipe_area eqa on eq.cd_equipe_area = eqa.cd_equipe_area
			left join empresa em1 on eq.empresa = em1.empresa 
			-- Joins para equipe definida pelo endereÃ§o estruturado	
			left join endereco_estruturado ee on euc.cd_endereco_estruturado = ee.cd_endereco_estruturado 
			left join equipe_micro_area ema on ema.cd_eqp_micro_area = ee.cd_eqp_micro_area 
			left join equipe_area eqa2 on ema.cd_equipe_area = eqa2.cd_equipe_area 
			left join empresa em2 on ema.empresa = em2.empresa
			left join cid cid1 on atd.cd_cid_principal = cid1.cd_cid
			left join cid cid2 on atd.cd_cid_secundario = cid2.cd_cid
			left join cidade c2 on euc.cod_cid = c2.cod_cid 
			left join estado e on c2.cod_est = e.cod_est 
		where
			(atd.dt_atendimento::date = current_date - interval '1 day'
			and atd.dt_atendimento::time between '16:00:00'::time and '23:59:59'::time)
			or
			(atd.dt_atendimento::date = current_date
			and atd.dt_atendimento::time between '00:00:01'::time and '08:59:59'::time)
		),
	atendimentos as (
		select 
			atd.nr_atendimento,
			'Não' as mdda,
			em.descricao as unidade_atendimento,
			coalesce(em1.descricao, em2.descricao) as unidade_referencia,
			coalesce(right(eqa.ds_area,3), right(eqa2.ds_area,3)) as equipe_referencia,
			atd.dt_atendimento::date as dt_atendimento,
			atd.dt_atendimento::time as hora_atendimento,
			uc.nm_usuario as nome_paciente,
			uc.dt_nascimento as dt_nascimento,
			extract(year from age(atd.dt_atendimento::date,uc.dt_nascimento::date)) as idade_no_atendimento,
			cns.cd_numero_cartao as cns,
			uc.cpf as cpf,
			uc.nr_telefone as telefone1,
			uc.nr_telefone_2 as telefone2,
			uc.telefone3 as telefone3,
			uc.telefone4 as telefone4,
			upper(tlc.ds_tipo_logradouro) || ' ' || upper(euc.nm_logradouro) as logradouro,
			euc.nr_logradouro as numero,
			upper(euc.nm_comp_logradouro) as complemento,
			upper(euc.nm_bairro) as bairro,
			c2.descricao as municipio,
			e.sigla as estado,
			atd.cd_cid_principal as cod_cid, 
			cid1.nm_cid as cid,
			atd.cd_cid_secundario as cod_cid_secund,
			cid2.nm_cid as cid_secund,
			null as diarreia_com_sangue,
			null as dt_primeiros_sintomas,
			null as plano_tratamento,
			null as resultado_exame
		from 
			atendimento atd
			join empresa em on atd.empresa = em.empresa 
			join usuario_cadsus uc on atd.cd_usu_cadsus = uc.cd_usu_cadsus 
			left join usuario_cadsus_cns cns on uc.cd_usu_cadsus = cns.cd_usu_cadsus and cns.st_excluido = 0
			left join endereco_usuario_cadsus euc on uc.cd_endereco = euc.cd_endereco 
			left join tipo_logradouro_cadsus tlc on euc.cd_tipo_logradouro = tlc.cd_tipo_logradouro 
			-- Joins para equipe de acompanhamento	
			left join equipe eq on uc.cd_equipe = eq.cd_equipe
			left join equipe_area eqa on eq.cd_equipe_area = eqa.cd_equipe_area
			left join empresa em1 on eq.empresa = em1.empresa 
			-- Joins para equipe definida pelo endereÃ§o estruturado	
			left join endereco_estruturado ee on euc.cd_endereco_estruturado = ee.cd_endereco_estruturado 
			left join equipe_micro_area ema on ema.cd_eqp_micro_area = ee.cd_eqp_micro_area 
			left join equipe_area eqa2 on ema.cd_equipe_area = eqa2.cd_equipe_area 
			left join empresa em2 on ema.empresa = em2.empresa
			left join cid cid1 on atd.cd_cid_principal = cid1.cd_cid
			left join cid cid2 on atd.cd_cid_secundario = cid2.cd_cid
			left join cidade c2 on euc.cod_cid = c2.cod_cid 
			left join estado e on c2.cod_est = e.cod_est 
		where
			--dia e horário
			(
				(atd.dt_atendimento::date between '2019-01-01'::date and '2023-01-10'::date
				or
				(atd.dt_atendimento::date = '2023-01-11'::date
				and atd.dt_atendimento::time between '00:00:01'::time and '15:59:59'::time)
			)
			-- cid
			and (
				cid1.cd_cid in ('A09', 'A03', 'A04', 'A05', 'A06', 'A08', 'A084', 'A085')
				or cid2.cd_cid in ('A09', 'A03', 'A04', 'A05', 'A06', 'A08', 'A084', 'A085')
				)
			and atd.nr_atendimento not in (select distinct nr_atendimento from mdda)
		)
	select * from mdda
	union all
	select * from atendimentos

