/*
OBSERVAÇÕES - JÁ DISCUTIDAS COM ANDRÉ/REGULAÇÃO:
- Regulação irá enviar o nome dos Reguladores que devem entrar na listagem
- Nas solicitações, constam apenas as solicitações autorizadas. O regulador que autorizou fica "responsável" pela solicitação, 
mesmo que tenha ocorrência de outros reguladores.
- Nas ocorrências, constam todas as ocorrências, não somente de solicitações autorizadas.
- No cálculo do tempo médio, sao.cd_tp_ocorrencia=2 significa que são ocorrências do tipo Regulação, excluindo as 
ocorrências do tipo "Solicitação".
- No cálculo do tempo, são consideradas todas as solicitações com pelo menos uma ocorrência. Como há JOIN com a 
tabela de primeira_regulação, só são consideradas portanto as solicitações com pelo menos uma ocorrência do tipo 2 (Regulação).
*/




-- PRODUÇÃO DE REGULADORES
with 
	reguladores as (
		select 
			distinct(sa.cd_usu_autorizador) as cod_regulador
		from 
			solicitacao_agendamento sa
		where sa.dt_solicitacao::date >= '2022-01-01'::date
		),
	ocorrencias as (
		select
			to_char(sao.dt_ocorrencia::date,'MM-YYYY') as mes,
			sao.cd_usuario as cod_regulador,
			upper(tp.ds_tp_procedimento) as tipo_procedimento,
			count(sao.cd_solicitacao_ocorrencia) as quant_ocorrencias
		from 
			solicitacao_ag_ocorrencia sao 
			join solicitacao_agendamento sa on sa.cd_solicitacao = sao.cd_solicitacao
			join tipo_procedimento tp on sa.cd_tp_procedimento = tp.cd_tp_procedimento
		where 
			sao.dt_ocorrencia::date between '2022-01-01'::date and '2022-12-31'::date
			and sao.cd_usuario in (select * from reguladores)
		group by 1,2,3
	),
	solicitacoes as (
		select
			to_char(sa.dt_cadastro::date,'MM-YYYY') as mes,
			sa.cd_usu_autorizador as cod_regulador,
			upper(tp.ds_tp_procedimento) as tipo_procedimento,
			coalesce(count(sa.cd_solicitacao),0) as quant_solicit_autorizadas
		from 
			solicitacao_agendamento sa 
			join tipo_procedimento tp on sa.cd_tp_procedimento = tp.cd_tp_procedimento
		where 
			sa.dt_autorizador::date between '2022-01-01'::date and '2022-12-31'::date
		group by 1,2,3
	)
select 
	oc.mes,
	usu.nm_usuario,
	oc.tipo_procedimento,
	oc.quant_ocorrencias,
	coalesce(sol.quant_solicit_autorizadas,0) as quant_solicit_autorizadas
from 
	ocorrencias oc
	left join solicitacoes sol on oc.cod_regulador = sol.cod_regulador and oc.tipo_procedimento = sol.tipo_procedimento and oc.mes = sol.mes
	join usuarios usu on oc.cod_regulador = usu.cd_usuario



-- TEMPO DE REGULAÇÃO
with 
	primeira_reg as (
		select 
			sa.cd_solicitacao,
			min(sao.cd_solicitacao_ocorrencia) as cod_min_reg
		from 
			solicitacao_ag_ocorrencia sao 
			join solicitacao_agendamento sa on sa.cd_solicitacao = sao.cd_solicitacao
		where sao.cd_tp_ocorrencia = 2
		and sa.dt_cadastro::date between '2022-01-01'::date and '2022-12-31'::date
		group by 1
		order by 1
	),
	tempos as (
		select
			sa.cd_solicitacao,
		 	sao.dt_ocorrencia::date - sa.dt_cadastro::date as tempo,
		 	sao.cd_usuario as cod_regulador,
		 	upper(usu.nm_usuario) as regulador
		from 
			solicitacao_ag_ocorrencia sao 
			join solicitacao_agendamento sa on sa.cd_solicitacao = sao.cd_solicitacao 
			join usuarios usu on sao.cd_usuario = usu.cd_usuario
			join primeira_reg pr on sao.cd_solicitacao_ocorrencia = pr.cod_min_reg
		where 
			sa.dt_cadastro::date between '2022-01-01'::date and '2022-12-31'::date
			and sao.dt_ocorrencia is not null 
)
select
	regulador,
	round(sum(tempo)::numeric / count(*),2) as media
from 
	tempos
group by 1
order by 2 asc




