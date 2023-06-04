select 
	extract('year' from ra.dt_registro) as ano_registro,
	em.descricao as unidade,
	count(ra.*) as quant_notificacoes
from 
	registro_agravo ra 
	join empresa em on ra.empresa = em.empresa 
where 
	ra.cd_cid in ('B972', 'B342', 'U071', 'U072')
	and ra.status <> 3
	and ra.dt_registro::date between '2020-01-01'::date and '2023-04-30'::date
	and em.cnpj = '82892282000143'
group by 1,2