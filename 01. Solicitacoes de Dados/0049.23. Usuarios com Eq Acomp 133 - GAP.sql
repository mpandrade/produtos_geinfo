select 
	uc.cd_usu_cadsus as cod_usuario,
	uc.nm_usuario as nome,
	uc.dt_nascimento as dt_nascimento,
	eq.nm_referencia as equipe
from 
	usuario_cadsus uc 
	join equipe eq on uc.cd_equipe = eq.cd_equipe 
where eq.nm_referencia = 'PRAINHA - 133'