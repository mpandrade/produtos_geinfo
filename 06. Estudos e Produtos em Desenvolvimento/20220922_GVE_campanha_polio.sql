with criancas as (
	select
		distinct(uc.cd_usu_cadsus) as cod,
		uc.nm_usuario as nome,
		uc.dt_nascimento as dn,
		uc.nm_mae as nome_mae,
		euc.nm_logradouro || ' ' || euc.nr_logradouro || ' '|| euc.nm_comp_logradouro as endereco,
		euc.nm_bairro as bairro,
		cid.descricao as cidade,
		uc.nr_telefone as telefone1,
		uc.nr_telefone_2 as telefone2,
		uc.telefone3 as telefone3,
		uc.telefone4 as telefone4 
	from 
		usuario_cadsus uc
		left join cidade cid on uc.cd_municipio_residencia = cid.cod_cid 
		left join endereco_usuario_cadsus euc on uc.cd_endereco = euc.cd_endereco
	where 
		uc.dt_nascimento::date >= (current_date - interval '5 years')
		and uc.dt_nascimento is not null
		and uc.cd_municipio_residencia = 420540
		and uc.st_vivo = 1
		and uc.st_excluido = 0
		and uc.flag_unificado = 0
		and uc.situacao in (0,1)
),
	-- Obs: função max utilizada para deduplicação (crianças com 2 doses de polio no período avaliado)
	vacinas as (
	select 
		uc.cd_usu_cadsus as cod,
		max(extract('year' from age(va.dt_aplicacao::date,uc.dt_nascimento::date))::int) as idade_na_aplicacao,
		max(va.dt_aplicacao::date) as dt_aplicacao,
		max(tv.ds_vacina) as tipo_vacina,
		max(case
			when va.cd_doses=9 then 'Dose Unica'
			when va.cd_doses=8 then 'Dose'
			when va.cd_doses=1 then 'Dose 1' 
			when va.cd_doses=2 then 'Dose 2' 
			when va.cd_doses=3 then 'Dose 3'
			when va.cd_doses=4 then 'Dose 4'
			when va.cd_doses=5 then 'Dose 5'
			when va.cd_doses=10 then 'Revacinacao'
			when va.cd_doses=7 then '2º Reforço'
			when va.cd_doses=6 then '1º Reforço'
			when va.cd_doses=38 then 'Reforço'
			when va.cd_doses=36 then 'Dose Inicial'
			when va.cd_doses=37 then 'Dose Adicional'
		end) as dose,
		max(va.flag_historico) as flag_historico,
		max(em.descricao) as unidade_aplicacao
	from 
		usuario_cadsus uc  
		left join vac_aplicacao va on va.cd_usu_cadsus = uc.cd_usu_cadsus 
		inner join tipo_vacina tv on va.cd_vacina = tv.cd_vacina 
		left join empresa em on va.empresa = em.empresa
	where
		va.dt_aplicacao::date >= '2022-08-08'::date
		and extract('year' from age(va.dt_aplicacao::date,uc.dt_nascimento::date)) < 5
		and tv.cd_vacina = 81984
	group by 1
		)
select
	c.cod,
	c.nome,
	c.nome_mae,
	c.dn,
	c.bairro,
	c.cidade,
	c.endereco,
	c.telefone1,
	c.telefone2,
	c.telefone3,
	c.telefone4,
	v.idade_na_aplicacao,
	v.dt_aplicacao,
	v.tipo_vacina,
	v.dose,
	v.flag_historico,
	v.unidade_aplicacao
from 
	criancas c
	left join vacinas v on c.cod = v.cod