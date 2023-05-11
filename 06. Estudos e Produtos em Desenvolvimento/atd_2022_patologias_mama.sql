select 
	em.descricao as unidade,
	cid.cd_cid as cid,
	cid.nm_cid as descricao_cid,
	count(atd.nr_atendimento) as quant_atendimentos 
from 
	atendimento atd 
	join empresa em on em.empresa = atd.empresa 
	join cid cid on atd.cd_cid_principal = cid.cd_cid 
where 
	atd.dt_atendimento::date between '2022-01-01'::date and '2022-12-31'::date 
	and atd.status = 4 
	and (atd.cd_cid_principal in ('O92','O921','N640','O912','O70','O700') or cid.nm_cid ilike '%mama%' or cid.nm_cid ilike '%mamá%' or cid.nm_cid ilike '%mami%')
group by 1,2,3