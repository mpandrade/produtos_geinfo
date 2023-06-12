select
	to_char(sa.dt_solicitacao, 'MM/YYYY') as mes_ano_solicitacao,
	tp.ds_tp_procedimento as especialidade,
	case when sa.tp_fila = 1 then 'cronológica' else 'regulada' end as tipo_fila,
    case when sa.tp_consulta = 0 then '1a consulta' else 'retorno' end as tipo_consulta,
    case 
    	when sa.status = 0 then 'não regulado'
    	when sa.status = 1 then 'regulado_na_fila'
    	when sa.status = 2 then 'agendado'
    	when sa.status in (4,9) then 'devolvido'
    else sa.status::text
    end as status_solicitacao,
    coalesce(cr.descricao,'Sem classificação') as classificacao_risco,
	count(sa.cd_solicitacao) as quant_solicitacoes
from
	solicitacao_agendamento sa
    left join tipo_procedimento tp on sa.cd_tp_procedimento = tp.cd_tp_procedimento
    left join procedimento pc on tp.cd_procedimento = pc.cd_procedimento
    left join tipo_procedimento_cla tc on tp.cd_tp_pro_cla = tc.cd_tp_pro_cla
    left join empresa em on sa.unidade = em.empresa
    left join classificacao_risco cr on sa.classificacao_risco = cr.cd_classificacao_risco
where
	sa.status <> 6 -- RETIRAR AS SOLICITAÇÕES CANCELADAS
	and (tp.ds_tp_procedimento like '%ULTRASSONO%OBST%' or tp.ds_tp_procedimento like '%USG%DOPPLER%')
	and sa.dt_solicitacao::date between '2020-01-01'::date and current_date
group by 1,2,3,4,5,6