-- Composição de equipes da APS
-- Um profissional pode estar cadastrado em várias unidades e com CBOs diferentes
-- Esta listagem não contempla composição de equipes

select 
	em.descricao as unidade,
	eq.nm_referencia as nome_equipe,
	eq.cd_tp_equipe as tipo_equipe,
	pro.nm_profissional as nome_profissional,
	ep.cd_cbo as cbo
from 
	equipe_profissional ep	
	left join equipe eq on ep.cd_equipe = eq.cd_equipe 
	left join profissional pro on ep.cd_profissional = pro.cd_profissional 
	left join empresa em on eq.empresa = em.empresa 
where 
	em.cod_atv = 2
	and ep.dt_desligamento is null
order by 1,2