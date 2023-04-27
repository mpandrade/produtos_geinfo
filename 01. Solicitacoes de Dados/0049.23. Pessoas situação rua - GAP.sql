 select
        distinct(uc.cd_usu_cadsus) as cod_usuario,
        uc.nm_usuario as nome,
        uc.dt_nascimento as dt_nascimento
    from
        usuario_cadsus uc 
        left join vac_aplicacao va on va.cd_usu_cadsus = uc.cd_usu_cadsus 
        left join usuario_cadsus_esus uce on uc.cd_usu_cadsus = uce.cd_usu_cadsus 
        left join esus_ficha_usuario_cadsus_esus efuce on uce.cd_usu_cadsus_esus = efuce.cd_usu_cadsus_esus
    where 
        uc.grupo_vacinacao = 94 
        or va.grupo_atendimento = 94
        or efuce.situacao_rua = 1
        or uce.situacao_rua = 1