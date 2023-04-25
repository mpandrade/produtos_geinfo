select
	upper(em2.descricao) as "Origem da Solicitação",
	upper(pro.nm_profissional) as "Prof. Solicitante",
	upper(em.descricao) as "Unid. Responsável",
	upper(tp.ds_tp_procedimento) "Especialidade",
	count(sa.cd_solicitacao) as "Num. devolvidos"
from 
	solicitacao_agendamento sa 
	join tipo_procedimento tp on sa.cd_tp_procedimento = tp.cd_tp_procedimento
	left join empresa em on sa.unidade = em.empresa
    left join empresa em2 on sa.empresa_origem = em2.empresa 
    left join profissional pro on sa.cd_profissional = pro.cd_profissional
where 
	sa.status = 4
    and sa.tp_fila = 2
    and em.cnpj = '82892282000143'
group by 1,2,3,4

