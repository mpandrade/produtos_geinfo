select 
	to_char(current_date - interval '1 month', 'MM-YYYY') as mes,
	sum(case when 
		(uc.cpf is null or uc.cpf = '')
			and extract('year' from age(uc.dt_nascimento)) < 1
		then 1 else 0 end) 
		as menor_1a_sem_CPF,
	sum(case when 
		(uc.cpf is null or uc.cpf = '')
			and extract('year' from age(uc.dt_nascimento)) >= 1
		then 1 else 0 end) 
		as maior_1a_sem_CPF,
	sum(case when 
		(coalesce(uc.celular,uc.nr_telefone,uc.nr_telefone_2,uc.telefone3,uc.telefone4) similar to '%(99999999|00000000|88888888)'
			or coalesce(uc.celular,uc.nr_telefone,uc.nr_telefone_2,uc.telefone3,uc.telefone4) is null)
			and extract('year' from age(uc.dt_nascimento)) < 1
		then 1 else 0 end) 
		as menor_1a_sem_telefone,
	sum(case when 
		(coalesce(uc.celular,uc.nr_telefone,uc.nr_telefone_2,uc.telefone3,uc.telefone4) similar to '%(99999999|00000000|88888888)'
			or coalesce(uc.celular,uc.nr_telefone,uc.nr_telefone_2,uc.telefone3,uc.telefone4) is null)
			and extract('year' from age(uc.dt_nascimento)) >= 1
		then 1 else 0 end) 
		as maior_1a_sem_telefone,
	sum(case when 
		uc.cd_equipe is null
			and extract('year' from age(uc.dt_nascimento)) < 1
		then 1 else 0 end) 
		as menor_1a_sem_equipe,
	sum(case when 
		uc.cd_equipe is null
			and extract('year' from age(uc.dt_nascimento)) >= 1
		then 1 else 0 end) 
		as maior_1a_sem_equipe,
	sum(case when
		uc.situacao = 1
		then 1 else 0 end)
		as cadastros_provisorios,
	sum(case when 
		extract('year' from age(uc.dt_nascimento)) < 1
		then 1 else 0 end)
		as cadastros_novos_menor_1a,
	sum(case when 
		extract('year' from age(uc.dt_nascimento)) >= 1
		then 1 else 0 end)
		as cadastros_novos_maior_1a	
from 
	usuario_cadsus uc 
	left join empresa em on uc.empresa_responsavel = em.empresa  
where 
   	uc.st_excluido = 0
    and uc.st_vivo = 1
    and uc.situacao in (0,1)
    and uc.flag_unificado = 0
    and uc.cd_municipio_residencia = 420540
	and to_char(uc.dt_cadastro::date, 'MM-YYYY') = to_char(current_date - interval '1 month', 'MM-YYYY')

	-- seleciona apenas APS
    --and em.cod_atv = 2