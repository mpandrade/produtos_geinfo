with 
	psr as (
	 	select
	        distinct(uc.cd_usu_cadsus) as cd_usu_cadsus
	    from
	        usuario_cadsus uc 
	        left join vac_aplicacao va on va.cd_usu_cadsus = uc.cd_usu_cadsus 
	        left join usuario_cadsus_esus uce on uc.cd_usu_cadsus = uce.cd_usu_cadsus 
	        left join esus_ficha_usuario_cadsus_esus efuce on uce.cd_usu_cadsus_esus = efuce.cd_usu_cadsus_esus
	        left join equipe eq on uc.cd_equipe = eq.cd_equipe
	    where 
	        uc.grupo_vacinacao = 94 
	        or va.grupo_atendimento = 94
	        or efuce.situacao_rua = 1
	        or uce.situacao_rua = 1
	        or eq.cd_equipe = 323971 -- CNR
	 )
select 
	uc.cd_usu_cadsus,
	uc.nm_usuario,
	uc.dt_nascimento,
	uc.sg_sexo,
	uc.cpf,
	case when uc.cd_equipe = 323971 then 1 else 0 end as vinculo_133,
	case 
		when uc.situacao = 0 then 'ativo' 
		when uc.situacao = 1 then 'provisorio'
		when uc.situacao = 2 then 'inativo' 
		when uc.situacao = 3 then 'excluido'
		end as status_cadastro,
	max(case when atd.cd_cbo similar to '(225|2231|2235)%' then 1 else 0 end) as ativo_med_enf,
	max(case when atd.empresa = 447392844 then 1 else 0 end) as atendido_cnr
from 
	psr psr
	left join usuario_cadsus uc on psr.cd_usu_cadsus = uc.cd_usu_cadsus
	left join atendimento atd on psr.cd_usu_cadsus = atd.cd_usu_cadsus
	join empresa em on atd.empresa = em.empresa
where 
	atd.dt_atendimento::date >= current_date - interval '2 years'
group by 1,2,3,4,5,6,7