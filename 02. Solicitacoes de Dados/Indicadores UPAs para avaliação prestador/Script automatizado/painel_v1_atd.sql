select distinct
	a.cd_usu_cadsus,
	a.nr_atendimento_principal,
	em.descricao as unidade,
	date_trunc('month', a.dt_chegada) as mes_referencia,
	min(a.dt_chegada) over (partition by a.nr_atendimento_principal) as dt_chegada,
    min(case when cr.descricao is not null then a.dt_atendimento end) over (partition by a.nr_atendimento_principal) as dt_inicio_primeira_cl_risco,
    min(case when cr.descricao is not null then a.dt_fechamento end) over (partition by a.nr_atendimento_principal) as dt_fechamento_primeira_cl_risco,
	first_value(cr.descricao) over (partition by a.nr_atendimento_principal
		order by a.dt_atendimento rows between unbounded preceding and unbounded following) as primeira_cl_risco,
    min(case when a.cd_cbo like '225%' then a.dt_atendimento end) over (partition by a.nr_atendimento_principal) as dt_primeiro_atendimento_medico,
    max(a.dt_fechamento) over (partition by a.nr_atendimento_principal) as dt_fechamento,
    max(case when a.cd_cbo like '225%' and (a.cd_cid_principal !~* '^Z' or a.cd_cid_principal ~* '(Z20$|Z209)') then 1 else 0 end) over (partition by a.nr_atendimento_principal) as fl_cid_especifico,
    max(case when a.cd_cbo like '225%' and a.cd_cid_principal ~* '(Z20$|Z209)' then 1 else 0 end) over (partition by a.nr_atendimento_principal) as fl_cid_exposicao_hiv,
    max(case when a.cd_cbo like '225%' then 1 else 0 end) over (partition by a.nr_atendimento_principal) as fl_atend_medico,
    max(case when ap.motivo_nao_procurou_unidade_saude is not null then 1 else 0 end) over (partition by a.nr_atendimento_principal) as fl_motivo_preenchido,
    max(case when ae.nr_atendimento is not null then 1 else 0 end) over (partition by a.nr_atendimento_principal) as fl_exame,
    max(case when ae.nr_atendimento is not null and abs(extract(epoch from a.dt_fechamento - a.dt_cadastro)/3600) < 4 then 1 else 0 end) over (partition by a.nr_atendimento_principal) as fl_exame_4h
from 
	atendimento a 
	join empresa em on em.empresa = a.empresa
	join classificacao_risco cr on cr.cd_classificacao_risco = a.classificacao_risco 
	left join atendimento_primario ap on ap.nr_atendimento = a.nr_atendimento 
	left join atendimento_exame ae on ae.nr_atendimento = a.nr_atendimento 
where 
	a.empresa in (259033,4272619,259035)
	and a.dt_chegada between date_trunc('month', current_date) - interval '1 year'
		and date_trunc('month', current_date) - interval '1 day'
	and a.status = 4