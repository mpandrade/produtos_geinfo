select 
	case 
		when sa.tp_consulta = 0 then 'Primeira Consulta'	
		when sa.tp_consulta = 1 then 'Retorno'
	end as tipo_consulta,
	case 
		when sa.dt_desejada::date < current_date then 'passou data' 
		when sa.dt_desejada is null then 'data não informada'
		else 'data futura' end as data_desejada, 
	--tp.ds_tp_procedimento,
	count(sa.cd_solicitacao) as quant_solicitacoes
from 
	solicitacao_agendamento sa
	join tipo_procedimento tp on sa.cd_tp_procedimento = tp.cd_tp_procedimento 
where 
	sa.dt_solicitacao::date >= '2023-01-01'::date
	and tp.ds_tp_procedimento like 'SMS%'
	and tp.situacao = 1
	and sa.status = 1
group by 1,2

/*
solicitacao_agendamento;status;0;nao_regulado
solicitacao_agendamento;status;1;regulado
solicitacao_agendamento;status;2;agendado
solicitacao_agendamento;status;4;devolvido
solicitacao_agendamento;status;6;cancelado
solicitacao_agendamento;tp_fila;1;cronologica
solicitacao_agendamento;tp_fila;2;regulacao

*/