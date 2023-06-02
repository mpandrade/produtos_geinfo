select 
	em.empresa,
	em.descricao,
	em.fantasia,
	em.cnpj,
	em.cnes,
	a.cod_atv,
	a.descricao,
	em.dist_sanitario
from 
	empresa em
	left join atividade a on em.cod_atv = a.cod_atv 
where
	ativo = 'S'
	and em.cnpj = '82892282000143'
	-- and em.cod_atv = 2 -- APS
order by 2
	