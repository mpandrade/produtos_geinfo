
select 
	pro.nm_profissional,
	to_char(atd.dt_atendimento, 'MM/YYYY') as mes_ano,
	count(atd.nr_atendimento) as qt_atd
from 
	atendimento atd 
	join usuario_cadsus uc on atd.cd_usu_cadsus = uc.cd_usu_cadsus 
	join profissional pro on atd.cd_profissional = pro.cd_profissional
where 
	atd.cd_profissional in (423056023,263569)
	and atd.dt_atendimento::date between '2021-07-01'::date and '2023-06-30'::date
group by 1,2
order by 1,2





Endereços obtidos a partir de março de 2022 - Entrada do Tales


with 
	usuarios_ana as (
		select distinct
			atd.cd_usu_cadsus
		from 
			atendimento atd 
		where 
			atd.cd_profissional = 263569
			and atd.dt_atendimento::date between '2022-03-01'::date and '2023-06-30'::date
		),
	usuarios_tales as (
		select distinct
			atd.cd_usu_cadsus
		from 
			atendimento atd 
		where 
			atd.cd_profissional = 423056023
			and atd.dt_atendimento::date between '2022-03-01'::date and '2023-06-30'::date
		)
select 
	'ANA PAULA MACANEIRO MELO' as profissional,
	ana.cd_usu_cadsus,
	tlc.ds_tipo_logradouro || ' ' || euc.nm_logradouro as logradouro,
	euc.nr_logradouro,
	euc.nm_bairro,
	euc.cep,
	eq.nm_referencia as equipe_acomp
from 
	usuario_cadsus uc 
	join usuarios_ana ana on uc.cd_usu_cadsus = ana.cd_usu_cadsus
	join endereco_usuario_cadsus euc on uc.cd_endereco = euc.cd_endereco 
	join tipo_logradouro_cadsus tlc on euc.cd_tipo_logradouro = tlc.cd_tipo_logradouro
	left join equipe eq on uc.cd_equipe = eq.cd_equipe

union all 

select 
	'TALES SEVERIANO DA SILVA' as profissional,
	tales.cd_usu_cadsus,
	tlc.ds_tipo_logradouro || ' ' || euc.nm_logradouro as logradouro,
	euc.nr_logradouro,
	euc.nm_bairro,
	euc.cep,
	eq.nm_referencia as equipe_acomp
from 
	usuario_cadsus uc 
	join usuarios_tales tales on uc.cd_usu_cadsus = tales.cd_usu_cadsus
	join endereco_usuario_cadsus euc on uc.cd_endereco = euc.cd_endereco 
	join tipo_logradouro_cadsus tlc on euc.cd_tipo_logradouro = tlc.cd_tipo_logradouro
	left join equipe eq on uc.cd_equipe = eq.cd_equipe