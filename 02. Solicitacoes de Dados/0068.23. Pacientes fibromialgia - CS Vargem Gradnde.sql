select distinct 
uc.cd_usu_cadsus,
uc.nm_usuario,
uc.dt_nascimento
from 
atendimento atd
join usuario_cadsus uc on atd.cd_usu_cadsus = uc.cd_usu_cadsus 
join equipe eq on uc.cd_equipe = eq.cd_equipe 
where 
(atd.cd_cid_principal = 'M797' or atd.cd_cid_secundario = 'M797')
and atd.dt_atendimento::date >= current_date - interval '2 years'
and eq.empresa = 257643
order by 2
