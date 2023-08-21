with
	devolucoes as (select
			sa.cd_profissional,
			e.descricao as unidade,
			sa.cd_solicitacao,
			sa.dt_solicitacao,
			max(sao.dt_ocorrencia::date) as dt_ultima_devolucao,
			case when sao.cd_solicitacao_ocorrencia is not null then 1 else 0 end as fl_devolvido
		from 
			solicitacao_agendamento sa 
			left join solicitacao_ag_ocorrencia sao on sao.cd_solicitacao = sa.cd_solicitacao 
				and sao.ds_ocorrencia like '%Devolvida pela Regulação%'
			join empresa e on e.empresa = sa.empresa_origem 
		where 
			sa.dt_solicitacao:: date >= current_date - interval '1 year'
			and sa.dt_solicitacao:: date < date_trunc('month', current_date)
			and e.cod_atv = 2
		group by 1, 2, 3, 4, 6),
	respostas as (select 
			d.cd_profissional,
			d.unidade,
			d.cd_solicitacao,
			dt_solicitacao,
			fl_devolvido,
			case
				when sao.dt_ocorrencia::date <= d.dt_ultima_devolucao + interval '7 days' then 1
				else 0 end as fl_respondido
		from 
			devolucoes d
			left join solicitacao_ag_ocorrencia sao on sao.cd_solicitacao = d.cd_solicitacao
				and d.fl_devolvido = 1
				and (sao.ds_ocorrencia like '%Reenviada para Regulação%'
					or sao.ds_ocorrencia like '%Cancelada%'))
select 
	cd_profissional,
	unidade,
    date_trunc('month', dt_solicitacao)::date as mes,
    count(distinct cd_solicitacao) as inseridos,
    count(distinct case when fl_devolvido = 1 then cd_solicitacao end) as devolvidos,
    count(distinct case when fl_respondido = 1 then cd_solicitacao end) as respondidos
from 
	respostas
group by 1, 2, 3