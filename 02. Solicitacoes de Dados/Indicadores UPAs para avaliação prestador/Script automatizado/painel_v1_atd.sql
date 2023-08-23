select distinct
	a.cd_usu_cadsus,
	a.nr_atendimento_principal,
	em.descricao as unidade,
	date_trunc('month', a.dt_chegada) as mes_referencia,
	min(a.dt_chegada) over (partition by a.nr_atendimento_principal) as dt_chegada,
	sum(CASE WHEN cr.descricao IS NOT NULL THEN 1 ELSE 0 END) over (partition by a.nr_atendimento_principal) as qt_class_risco_reg,
	sum(CASE WHEN  a.cd_procedimento in (1227, 4681) THEN 1 ELSE 0 END) over (partition by a.nr_atendimento_principal) as qt_class_risco_proc,
    min(case when cr.descricao is not null then a.dt_atendimento end) over (partition by a.nr_atendimento_principal) as dt_inicio_primeira_cl_risco,
    min(case when cr.descricao is not null then a.dt_fechamento end) over (partition by a.nr_atendimento_principal) as dt_fechamento_primeira_cl_risco,
	first_value(cr.descricao) over (partition by a.nr_atendimento_principal
		order by a.dt_atendimento rows between unbounded preceding and unbounded following) as primeira_cl_risco,
    min(case when a.cd_cbo similar to '(225|2231)%' then a.dt_atendimento end) over (partition by a.nr_atendimento_principal) as dt_primeiro_atendimento_medico,
    max(a.dt_fechamento) over (partition by a.nr_atendimento_principal) as dt_fechamento,
	max(case when a.cd_procedimento in (1218, 1225) then 1 else 0 end) over (partition by a.nr_atendimento_principal) as fl_atend_medico,
    max(case when a.cd_cbo similar to '(225|2231)%' 
    	and (a.cd_cid_principal is not null 
    		and a.cd_cid_principal not in ('Z000', 'Z719', 'R688', 'Z001', 'B34', 'Z027', 'Z017', 'Z718', 'Z00', 'Z53', 'Z02', 'Z539', 
										   'Z008', 'Z209', 'Z029', 'Z768', 'Z709', 'A289', 'A488', 'A498', 'A499', 'A638', 'A64', 'B349', 
										   'B369', 'B49', 'B888', 'B889', 'B89', 'B99', 'J189', 'L309', 'R688', 'R69', 'Y838', 'Y839', 
										   'Y848', 'Y849', 'Z008', 'Z03', 'Z04', 'Z049'))
		then 1 else 0 end) over (partition by a.nr_atendimento_principal) as fl_cid_especifico,
    max(case when a.cd_cbo similar to '(225|2231)%' and a.cd_cid_principal ~* '(Z20$|Z209)' then 1 else 0 end) over (partition by a.nr_atendimento_principal) as fl_cid_exposicao_hiv,
    max(case when a.cd_procedimento in (1218, 1225) then 1 else 0 end) over (partition by a.nr_atendimento_principal) as fl_atend_medico,
    max(case when ap.motivo_nao_procurou_unidade_saude is not null then 1 else 0 end) over (partition by a.nr_atendimento_principal) as fl_motivo_preenchido,
    max(case when ae.nr_atendimento is not null then 1 else 0 end) over (partition by a.nr_atendimento_principal) as fl_exame,
    max(case when ae.nr_atendimento is not null and abs(extract(epoch from a.dt_fechamento - a.dt_cadastro)/3600) < 4 then 1 else 0 end) over (partition by a.nr_atendimento_principal) as fl_exame_4h
from 
	atendimento a 
	join empresa em on em.empresa = a.empresa
	left join classificacao_risco cr on cr.cd_classificacao_risco = a.classificacao_risco 
	left join atendimento_primario ap on ap.nr_atendimento = a.nr_atendimento 
	left join atendimento_exame ae on ae.nr_atendimento = a.nr_atendimento 
where 
	a.empresa in (259033,4272619,259035)
	and a.dt_chegada between date_trunc('month', current_date) - interval '1 year'
		and date_trunc('month', current_date) - interval '1 day'
	and a.status = 4