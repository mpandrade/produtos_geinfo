select distinct
	ex.cd_usu_cadsus,
	ex.dt_solicitacao::date as dt_solicitacao
from
	exame ex
	join exame_requisicao er on er.cd_exame = ex.cd_exame
	join exame_procedimento eproc on er.cd_exame_procedimento = eproc.cd_exame_procedimento
where 
	ex.dt_solicitacao >= date_trunc('month', current_date) - interval '18 months'
	and ex.dt_solicitacao < date_trunc('month', current_date)
	and ex.status <> 7
	and eproc.cd_procedimento in (229)
group by 1, 2