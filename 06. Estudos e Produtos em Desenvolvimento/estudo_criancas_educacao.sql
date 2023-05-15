select 
	euc.nm_bairro as nome_bairro,
	euc.nm_logradouro as nome_rua,
	extract('year' from age(uc.dt_nascimento)) as idade,
	count(uc.cd_usu_cadsus) as quant_criancas
from 
	usuario_cadsus uc 
	join endereco_usuario_cadsus euc on uc.cd_endereco = euc.cd_endereco 
where 
	uc.cd_municipio_residencia = 420540
	and extract('year' from age(uc.dt_nascimento)) between 0 and 15
	and uc.flag_unificado = 0
	and uc.st_vivo = 1
	and uc.situacao in (0,1)
	and uc.dt_cadastro::date >= '2019-03-01'::date
group by 1,2,3
order by 1,2,3
