select 
	tp.ds_tp_procedimento as nome_procedimento,
	sa.dt_solicitacao::date as data_solicitacao,
	sa.cd_solicitacao as cod_solicitacao,
	uc.cd_usu_cadsus as cod_usuario,
	em.descricao as unidade_solicitante,
	sa.classificacao_risco as classificacao_risco 
from 
	solicitacao_agendamento sa 
	join empresa em on sa.empresa_origem = em.empresa 
	join usuario_cadsus uc on sa.cd_usu_cadsus = uc.cd_usu_cadsus 
	join tipo_procedimento tp on sa.cd_tp_procedimento = tp.cd_tp_procedimento 
where sa.status = 1
and sa.tp_fila = 2
and sa.classificacao_risco is null