with cadastros as (
select 
	to_char(uc.dt_cadastro::date, 'MM-YYYY') as mes_cadastro,
	em.descricao as unidade,
	count(uc.*) as total_cadastros_novos,
	sum(case when uc.situacao = 1 then 1 else 0 end) as cad_provisorios,
	sum(case when 
		uc.cpf is null or uc.cpf = ''
		or uc.celular is null 
		or uc.celular similar to '%(11111111|22222222|33333333|44444444|55555555|66666666|77777777|88888888|99999999|00000000)'
		or ucc.cd_numero_cartao is null
		then 1 else 0 end) 
		as cad_incompletos		
from 
	usuario_cadsus uc 
	left join empresa em on uc.empresa_responsavel = em.empresa  
	left join usuario_cadsus_cns ucc on uc.cd_usu_cadsus = ucc.cd_usu_cadsus and ucc.st_excluido = 0
where 
   	uc.st_excluido = 0
    and uc.st_vivo = 1
    and uc.situacao in (0,1)
    and uc.flag_unificado = 0
	and uc.dt_cadastro::date >= '2022-01-01'::date
	and em.empresa in (259033,4272619,259035)
group by 1,2
)

select 
	mes_cadastro,
	unidade,
	total_cadastros_novos,
	round(cad_provisorios::numeric / total_cadastros_novos::numeric,4) as perc_cad_provisorios,
	round(cad_incompletos::numeric / total_cadastros_novos::numeric,4) as perc_cad_incompletos
from 
	cadastros
