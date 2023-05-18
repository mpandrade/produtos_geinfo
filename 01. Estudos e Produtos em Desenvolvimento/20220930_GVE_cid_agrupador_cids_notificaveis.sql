select 
	cc.cd_cid_agrupador as cid_agrupador,
	cc.descricao as classificacao,
	c.cd_cid as cid,
	c.nm_cid as cid_descricao
from 
	cid_classificacao cc 
	left join cid c on cc.cd_classificacao = c.cd_classificacao
order by 1