select 
	em.descricao as unidade,
	tp.ds_tp_procedimento as procedimento,
	count(sa.*)
from 
solicitacao_agendamento sa 
join empresa em on sa.unidade = em.empresa
join tipo_procedimento tp on sa.cd_tp_procedimento = tp.cd_tp_procedimento 
where sa.dt_solicitacao::date between '2022-03-01'::date and '2023-03-31'::date
and tp.situacao = 1
and tp.ds_tp_procedimento like '%TELEDERMATO%'
and sa.status <> 6
and em.cod_atv = 2
group by 1,2