-- ATENDIMENTOS

select
	em.descricao,
	count(*) as quant,
	case when atd.status = 4 then 'finalizado' 
	when atd.status = 5 then 'cancelado' 
	when atd.status = 8 then 'fechado sem atendimento'
	end as status
from 
	atendimento atd 
	join empresa em on em.empresa = atd.empresa
where 
	atd.dt_atendimento::date between '2023-05-31'::date and '2023-06-07'::date
	and em.cod_atv = 70 -- CAPS
	and atd.cd_procedimento not in (4740,4745)
group by 1,3
order by 1



-- ATENDIMENTOS

select
	em.descricao,
	atd.dt_atendimento as dt_atendimento,
	count(*) as quant
from 
	atendimento atd 
	join empresa em on em.empresa = atd.empresa
where 
	atd.dt_atendimento::date between '2023-05-01'::date and '2023-06-07'::date
	and atd.status = 4 -- Finalizados
	and em.cod_atv = 70 -- CAPS
	and atd.cd_procedimento not in (4740,4745)
group by 1,2
order by 1,2




select
	em.descricao,
	atd.nr_atendimento,
	case when atd.status = 4 then 'finalizado' 
	when atd.status = 5 then 'cancelado' 
	when atd.status = 8 then 'fechado sem atendimento'
	end as status,
	pro.ds_procedimento
from 
	atendimento atd 
	join empresa em on em.empresa = atd.empresa
	join procedimento pro on atd.cd_procedimento = pro.cd_procedimento
where 
	atd.dt_atendimento::date between '2023-05-31'::date and '2023-06-07'::date
	and em.cod_atv = 70
	and atd.cd_procedimento not in (4740,4745)




	select
	em.descricao as unidade,
	atg.data_hora_inicio,
	atg.assunto,
	tag.ds_tp_atv_grupo as tipo_atividade_grupo,
	case 
		when atg.situacao = 0 then 'pendente'
		when atg.situacao = 2 then 'concluído'
		when atg.situacao = 3 then 'cancelado'
	end as status,
	atg.qtd_participantes
from 
	atividade_grupo atg
	join empresa em on em.empresa = atg.empresa
	join tipo_atividade_grupo tag on atg.cd_tp_atv_grupo = tag.cd_tp_atv_grupo 
where 
	em.cod_atv = 70
	and atg.data_hora_inicio::date between '2023-05-01'::date and '2023-06-07'::date
order by 1,2