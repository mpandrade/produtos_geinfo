-- Solicitada exclusão da Poli Norte
-- No Excel, foram aplicados filtros para obter o valor sigtap médio dos exames realizados

with valores as (
select
	pro.referencia,
	comp.vl_sa as valor1,
	comp.vl_sp as valor2
from
	procedimento_competencia comp
left join procedimento pro on
	comp.cd_procedimento = pro.cd_procedimento
where
	comp.dt_competencia = '2022-05-01'
)

select
	sa.cd_solicitacao as solicitacoes,
	em.descricao as unidade_origem,
	tpc.ds_tp_pro_cla as classificacao_procedimento,
	pro.ds_procedimento as descricao_procedimento,
	tp.ds_tp_procedimento as descricao_tipo_procedimento,
	pro2.ds_procedimento as descricao_exame,
	coalesce(pro2.referencia, pro.referencia) as sigtap,
	case
		when agah.status = 1 then 'agendado'
		when agah.status = 2 then 'concluído_executado'
		when agah.status = 3 then 'cancelado'
		when agah.status = 4 then 'nao_compareceu'
		when agah.status = 5 then 'remanejado'
	end as status_agenda,
	v.valor1 as valor_sigtap_unitario,
	v.valor2 as valor_rp_unitario
from
	agenda_gra_ate_horario agah
	left join solicitacao_agendamento sa on	sa.cd_solicitacao = agah.cd_solicitacao
	left join usuario_cadsus_cns ucc on sa.cd_usu_cadsus = ucc.cd_usu_cadsus 
	left join empresa em on	sa.empresa_origem = em.empresa
	left join tipo_procedimento tp on sa.cd_tp_procedimento = tp.cd_tp_procedimento
	left join procedimento pro on sa.cd_procedimento = pro.cd_procedimento
	left join procedimento_grupo pg on pro.cd_grupo = pg.cd_grupo
	left join solicitacao_agendamento_exame sae on sae.cd_solicitacao = sa.cd_solicitacao
	left join exame_procedimento ep on sae.cd_exame_procedimento = ep.cd_exame_procedimento
	left join procedimento pro2 on ep.cd_procedimento = pro2.cd_procedimento
	left join procedimento_grupo pg2 on	pro2.cd_grupo = pg2.cd_grupo
	left join valores v on coalesce(pro2.referencia, pro.referencia) = v.referencia
	left join tipo_procedimento_cla tpc on tpc.cd_tp_pro_cla = tp.cd_tp_pro_cla 
where
	agah.dt_agendamento::date between '2022-01-01'::date and '2022-12-31'::date
	and tp.ds_tp_procedimento like 'SMS%'
	and ucc.st_excluido = 0
	and em.empresa in (258687,258681,258683)