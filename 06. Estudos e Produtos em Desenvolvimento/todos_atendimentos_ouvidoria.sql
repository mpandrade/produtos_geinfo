--- trimestre


select 
	count(distinct(atd.nr_atendimento)) as atendimentos
from atendimento atd
where atd.dt_atendimento::date between '2023-01-01'::date and '2023-03-31'
and atd.status = 4

union all 

select 
	count(distinct(va.cd_vac_aplicacao)) as atendimentos
from vac_aplicacao va 
where va.dt_aplicacao::date between '2023-01-01'::date and '2023-03-31'

union all 

select 
	count(distinct(dm.nr_dispensacao)) as atendimentos
from dispensacao_medicamento dm 
where dm.dt_dispensacao::date between '2023-01-01'::date and '2023-03-31'


---------------


with usuarios as (

select 
	atd.cd_usu_cadsus as usuario 
from atendimento atd
where atd.dt_atendimento::date between '2023-01-01'::date and '2023-03-31'
and atd.status = 4

union all

select 
	va.cd_usu_cadsus as usuario
from vac_aplicacao va 
where va.dt_aplicacao::date between '2023-01-01'::date and '2023-03-31'

union all 

select 
	dm.cd_usu_cadsus_destino as usuario
from dispensacao_medicamento dm 
where dm.dt_dispensacao::date between '2023-01-01'::date and '2023-03-31'

) select count(distinct(usuario)) from usuarios