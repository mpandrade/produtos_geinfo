select
	to_char(sa.dt_solicitacao, 'MM/YYYY') as mes_ano_solicitacao,
	tp.ds_tp_procedimento as especialidade,
	ep.ds_procedimento as tipo,
	case 
		when tp.cd_tp_procedimento in (338291) then 'Petiátrico'
		else 'Adulto'
		end as grupo_idade,
	case when sa.tp_fila = 1 then 'cronológica' else 'regulada' end as tipo_fila,
    case 
    	when sa.status = 0 then 'não regulado'
    	when sa.status = 1 then 'regulado_na_fila'
    	when sa.status = 2 then 'agendado'
    	when sa.status in (4,9) then 'devolvido'
    else sa.status::text
    end as status_solicitacao,
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
	and tp.cd_tp_procedimento in (420317317,333072,302432167,338291)
	and sa.dt_solicitacao::date between (current_date - interval '12 months') and current_date
group by 1,2,3,4,5,6

