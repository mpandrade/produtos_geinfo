select 
	em.descricao as unidade,
	extract('year' from age(atd.dt_atendimento::date,uc.dt_nascimento)) as idade,
	sum(case when icp.cd_procedimento = 3351 then 1 else 0 end) as exo_deciduos,
	sum(case when icp.cd_procedimento = 3352 then 1 else 0 end) as exo_permanente
from 
	item_conta_paciente icp
	join atendimento atd on icp.nr_atendimento = atd.nr_atendimento 
	join empresa em on atd.empresa = em.empresa
	join usuario_cadsus uc on atd.cd_usu_cadsus = uc.cd_usu_cadsus
where 
	extract('year' from atd.dt_atendimento) = 2022
	and atd.cd_cbo like '2232%'
	and icp.cd_procedimento in (3351,3352)
	and extract('year' from age(atd.dt_atendimento::date,uc.dt_nascimento)) <= 10
group by 1,2
order by 1,2