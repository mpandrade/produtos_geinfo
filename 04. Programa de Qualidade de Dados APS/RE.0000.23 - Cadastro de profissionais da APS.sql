-- Profissionais cadastrados na APS
-- Um profissional pode estar cadastrado em várias unidades e com CBOs diferentes
-- Esta listagem não contempla composição de equipes

select 
	em.descricao as unidade,
	p.nm_profissional,
	p.cpf,
	p.cd_cns,
	pch.cd_cbo,
	tc.ds_cbo 
from 
	profissional_carga_horaria pch 
	left join profissional p on pch.cd_profissional = p.cd_profissional 
	left join empresa em on em.empresa = pch.empresa 
	left join tabela_cbo tc on pch.cd_cbo = tc.cd_cbo 
where 
	em.cod_atv = 2
	and pch.dt_desativacao is null 
order by 1,2