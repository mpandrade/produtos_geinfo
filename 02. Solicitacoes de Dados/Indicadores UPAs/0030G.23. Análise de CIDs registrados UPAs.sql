select 
	replace(em.descricao, 'UNIDADE DE PRONTO ATENDIMENTO - ', '') as unidade,
	case 
		when atd.cd_cbo similar to '(225|2231)%' then 'MEDICO'
		when atd.cd_cbo similar to '(2235)%' then 'ENFERMEIRO'
		when atd.cd_cbo similar to '(2232)%' then 'DENTISTA'
	end as profissional,
	coalesce(atd.cd_cid_principal, 'Sem CID') as cid,
	coalesce(cid.nm_cid, 'Sem CID') as nome_cid,
	count(atd.nr_atendimento) as quant
from
	atendimento atd
	join empresa em on atd.empresa = em.empresa
 	left join cid cid on atd.cd_cid_principal = cid.cd_cid 
where 
	atd.empresa in (259033,4272619,259035)
	and atd.cd_cbo similar to '(225|2231|2235|2232)%'
	and atd.dt_atendimento::date between '2022-01-01'::date and '2022-12-31'::date
	and atd.status = 4
group by 1,2,3,4


