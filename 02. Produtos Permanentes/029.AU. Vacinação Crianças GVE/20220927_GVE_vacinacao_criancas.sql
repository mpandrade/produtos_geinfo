select 
	uc.cd_usu_cadsus as cod_usuario,
	uc.dt_nascimento as dn,
	extract('year' from age(va.dt_aplicacao::date,uc.dt_nascimento::date))::int as idade_na_aplicacao,
	euc.nm_bairro as bairro,
	cid.descricao as cidade,
	va.dt_aplicacao::date as dt_aplicacao,
	tv.ds_vacina as tipo_vacina,
	case
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
	end as dose,
	va.flag_historico as flag_historico,
	em.descricao as unidade_aplicacao
from 
	vac_aplicacao va
	inner join tipo_vacina tv on va.cd_vacina = tv.cd_vacina 
	inner join usuario_cadsus uc on va.cd_usu_cadsus = uc.cd_usu_cadsus 
	left join cidade cid on uc.cd_municipio_residencia = cid.cod_cid 
	left join endereco_usuario_cadsus euc on uc.cd_endereco = euc.cd_endereco
	left join empresa em on va.empresa = em.empresa
where
	uc.dt_nascimento::date >= (current_date - interval '5 years')
