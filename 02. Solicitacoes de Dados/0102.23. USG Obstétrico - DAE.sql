select
	to_char(sa.dt_solicitacao, 'MM/YYYY') as mes_ano_solicitacao,
	tp.ds_tp_procedimento as especialidade,
	count(sa.cd_solicitacao) as quant_solicitacoes
from
	solicitacao_agendamento sa
    left join tipo_procedimento tp on sa.cd_tp_procedimento = tp.cd_tp_procedimento
    left join solicitacao_agendamento_exame sae on sa.cd_solicitacao = sae.cd_solicitacao
    left join exame_procedimento ep on sae.cd_exame_procedimento = ep.cd_exame_procedimento
    left join procedimento pc on sa.cd_procedimento = pc.cd_procedimento
    left join tipo_procedimento_cla tc on tp.cd_tp_pro_cla = tc.cd_tp_pro_cla
    left join empresa em on sa.unidade = em.empresa
where
	sa.status <> 6 -- RETIRAR AS SOLICITAÇÕES CANCELADAS
	and tp.cd_tp_procedimento in (4141988)
	and sa.dt_solicitacao::date between (current_date - interval '24 months') and current_date
group by 1,2
order by 1 asc

