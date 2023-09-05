select distinct
	e.descricao,
	date_trunc('month', dt_atendimento) as mes_atendimento,
	min(a.dt_chegada) over (partition by a.nr_atendimento_principal) as dt_chegada,
	sum(case when a.cd_procedimento in (1218, 1225) then 1 else 0 end) over (partition by a.nr_atendimento_principal) as qt_atend_medico,
	sum(case when a.cd_procedimento in (1227, 4681) then 1 else 0 end) over (partition by a.nr_atendimento_principal) as qt_atend_cl_risco,
	min(case when a.cd_procedimento in (1227, 4681) then a.dt_atendimento end) over (partition by a.nr_atendimento_principal) as dt_primeira_cl_risco,
	min(case when a.cd_procedimento in (1218, 1225) then a.dt_atendimento end) over (partition by a.nr_atendimento_principal) as dt_primeiro_atend_medico,
	first_value(case when a.cd_procedimento in (1227, 4681) then cr.descricao end) over (partition by a.nr_atendimento_principal
		order by case when a.cd_procedimento in (1227, 4681) then 0 else 1 end, a.dt_atendimento) as ds_primeira_cl_risco,
	sum(case when a.cd_procedimento in (1218, 1225)
    	and (a.cd_cid_principal is not null 
    		and a.cd_cid_principal not in ('Z000', 'Z719', 'R688', 'Z001', 'B34', 'Z027', 'Z017', 'Z718', 'Z00', 'Z53', 'Z02', 'Z539', 
										   'Z008', 'Z209', 'Z029', 'Z768', 'Z709', 'A289', 'A488', 'A498', 'A499', 'A638', 'A64', 'B349', 
										   'B369', 'B49', 'B888', 'B889', 'B89', 'B99', 'J189', 'L309', 'R688', 'R69', 'Y838', 'Y839', 
										   'Y848', 'Y849', 'Z008', 'Z03', 'Z04', 'Z049'))
		then 1 else 0 end) over (partition by a.nr_atendimento_principal) as qt_atend_cid_especifico,
    max(case when a.cd_cbo similar to '(225|2231)%' 
    	and a.cd_cid_principal ~* '(Z20$|Z209)' then 1 else 0 end) over (partition by a.nr_atendimento_principal) as fl_cid_exposicao_hiv
from 
	atendimento a 
	join empresa e on e.empresa = a.empresa 
	left join classificacao_risco cr on cr.cd_classificacao_risco = a.classificacao_risco
where 
	a.empresa in (259033,4272619,259035)
	and a.dt_chegada >= '2023-07-01'::date