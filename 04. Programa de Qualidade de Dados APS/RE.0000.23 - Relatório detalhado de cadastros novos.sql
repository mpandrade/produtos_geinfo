select 
	uc.cd_usu_cadsus,
	em.descricao as unidade,
	upper(usu.nm_usuario) as profissional,
	case 
		when extract('year' from age(uc.dt_nascimento)) < 1	then 'Idade < 1a'
		else 'Idade >= 1a'
		end as idade,
	case when uc.cpf is null or uc.cpf = '' then 'não' else 'sim' end as possui_cpf,
	case when uc.cd_equipe is null then 'não' else 'sim' end as possui_equipe_acomp,
	case when uc.situacao = 1 then 'provisorio' else 'definitivo' end as tipo_cadastro,
	case when uc.nm_usuario like 'RN %' then 'sim' else 'não' end as nome_contem_RN,
	case when 
		coalesce(uc.celular,uc.nr_telefone,uc.nr_telefone_2,uc.telefone3,uc.telefone4) similar to '%(99999999|00000000|88888888)'
		or coalesce(uc.celular,uc.nr_telefone,uc.nr_telefone_2,uc.telefone3,uc.telefone4) is null 
		then 'não' else 'sim' 
		end as possui_telefone
from 
	usuario_cadsus uc 
	left join empresa em on uc.empresa_responsavel = em.empresa  
	left join usuarios usu on coalesce(uc.cd_usuario_cad,uc.cd_usuario) = usu.cd_usuario  
where 
   	uc.st_excluido = 0
    and uc.st_vivo = 1
    and uc.situacao in (0,1)
    and uc.flag_unificado = 0
    and uc.cd_municipio_residencia = 420540
	and to_char(uc.dt_cadastro::date, 'MM-YYYY') = to_char(current_date - interval '1 month', 'MM-YYYY')