with
	cadastros as (select
			date_trunc('month', uc.dt_cadastro) as mes_referencia,
			em.descricao as unidade,
			count(uc.*) as total_cadastros_novos,
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
		    and uc.situacao = 0
		    and uc.flag_unificado = 0
			and uc.dt_cadastro between date_trunc('month', current_date) - interval '1 year'
				and date_trunc('month', current_date) - interval '1 day'
			and em.empresa in (259033,4272619,259035)
		group by 1,2)
select 
	mes_referencia,
	unidade,
	total_cadastros_novos,
	cad_incompletos
from 
	cadastros
