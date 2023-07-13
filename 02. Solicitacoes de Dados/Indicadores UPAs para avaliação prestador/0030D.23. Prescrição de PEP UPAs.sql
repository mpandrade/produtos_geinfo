select 
	count(distinct(atd.cd_usu_cadsus)) as pacientes_cid_z20_z209,
	count(distinct(ri.cd_receiturario_item)) as receitas_pep
from
	atendimento atd
	join empresa em on atd.empresa = em.empresa
	left join receituario re on em.empresa = re.empresa 
	left join receituario_item ri on re.cd_receituario = ri.cd_receituario 
where 
	atd.empresa in (259033,4272619,259035)
	and atd.dt_atendimento::date between '2023-01-01'::date and '2023-03-31'::date
	and re.dt_cadastro::date between '2023-01-01'::date and '2023-03-31'::date
	and atd.status = 4
	and (atd.cd_cid_principal in ('Z20', 'Z209') or atd.cd_cid_secundario in ('Z20', 'Z209'))
	and ri.cod_pro in ('3446', '3655')






---------------------------------


select 
	count(distinct(ri.cd_receiturario_item)) as receitas_pep
from
	receituario re
	join empresa em on em.empresa = re.empresa 
	left join receituario_item ri on re.cd_receituario = ri.cd_receituario 
where 
	re.empresa in (259033,4272619,259035)
	and re.dt_cadastro::date between '2023-01-01'::date and '2023-03-31'::date
	and ri.cod_pro in ('3446', '3655')

