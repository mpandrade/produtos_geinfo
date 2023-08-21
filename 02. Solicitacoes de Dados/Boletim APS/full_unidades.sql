select 
	e.empresa,
	e.descricao as unidade,
	e.cod_atv,
	eed.descricao as distrito
from 
	empresa e
	left join end_estruturado_distrito eed on eed.cd_end_estruturado_distrito = e.cd_end_estruturado_distrito 
where
	e.cnpj = '82892282000143'
	and cod_atv in (2, 4, 70, 73)
