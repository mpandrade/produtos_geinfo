select 
	c.cd_cid,
	c.nm_cid,
	tc.ds_cbo,
	count(atd.nr_atendimento) 
from 
	atendimento atd 
	left join cid c on atd.cd_cid_principal = c.cd_cid
	join empresa em on em.empresa = atd.empresa
	join usuario_cadsus uc on atd.cd_usu_cadsus = uc.cd_usu_cadsus 
	join tabela_cbo tc on atd.cd_cbo = tc.cd_cbo 
where 
	em.cod_atv = 2
	and atd.dt_atendimento::date between '2023-04-01'::date and '2023-05-30'::date
	and extract('year' from age(uc.dt_nascimento,atd.dt_atendimento)) between 0 and 10
group by 1,2,3
order by 3 desc 
