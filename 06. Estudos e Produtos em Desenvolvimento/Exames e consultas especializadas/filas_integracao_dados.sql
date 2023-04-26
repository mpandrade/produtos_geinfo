with 
	-- LISTA AS ESPECIALIDADES, CORRIGIDAS E AGRUPADAS
	especialidades as (
		select distinct 
			case 
				when tp.ds_tp_procedimento like '%LABORAT%' then 'GRUPO - EXAMES LABORATORIAIS'
				when tp.ds_tp_procedimento = 'SMS - CONSULTA EM FISIOTERAPIA - APS' then 'FISIOTERAPIA - APS'
				when tp.ds_tp_procedimento like '%FISIO%' then 'FISIOTERAPIA - ESPECIALIZADA'
				else replace(ltrim(tp.ds_tp_procedimento), 'SMS - ', '')
				end as especialidade,
			tp.cd_tp_procedimento as cd_tp_procedimento
			--tp.ds_tp_procedimento as nome_original,
			--case when tp.situacao = 1 then 'Ativo' else 'Inativo' end as status_tipo_procedimento,
			--tp.regulado as regulado
		from
			tipo_procedimento tp
		where
			tp.ds_tp_procedimento like 'SMS%'
			and tp.situacao = 1
			and tp.cd_tp_procedimento not in (
				-- Tipos de procedimentos que serão excluídos da lista
				373693003,	-- SMS - AMBULATÓRIO TRANS - CONSULTA MÉDICA
				373357677,	-- SMS - AMBULATÓRIO TRANS - PSICOLOGIA
				373692644,	-- SMS - AMBULATÓRIO TRANS - SERVIÇO SOCIAL
				373693480,	-- SMS - AMBULATÓRIO TRANS - TELECONSULTA MÉDICA
				294611221,	-- SMS - CONSULTA EM ACUPUNTURA - POR SESSÃO
				310453674,	-- SMS - CONSULTA EM ANESTESIOLOGIA
				294610333,	-- SMS - CONSULTA EM FONOAUDIOLOGIA - POR SESSÃO
				296934980,	-- SMS - CONSULTA EM NEFROLOGIA - REVISÃO
				36428007,	-- SMS - CONSULTA EM OFTALMOLOGIA - CATARATA - PÓS-OPERATÓRIO
				302421910,	-- SMS - CONSULTA EM OFTALMOLOGIA - PLÁSTICA OCULAR
				109871180,	-- SMS - CONSULTA EM OFTALMOLOGIA PTERÍGIO - RETORNO
				109868113,	-- SMS - CONSULTA EM OFTALMOLOGIA - REFRAÇÃO
				302815756,	-- SMS - CONSULTA EM OFTALMOLOGIA - RETORNO
				421625112,	-- SMS - CONSULTA EM PODOLOGIA
				369778826,	-- SMS - CONSULTA EM PSICOLOGIA AMB INFANTIL - SESSÃO
				437546570,	-- SMS - GRUPO - CIRURGIAS OFTALMOLÓGICAS
				384309898,	-- SMS - GRUPO - EXAMES LABORATORIAIS - AMB PREP
				302423187,	-- SMS - GRUPO - TOMOGRAFIA COMPUTADORIZADA - ONCOLOGIA
				293451999,	-- SMS - SESSÃO FISIOTERAPIA
				332675315,	-- SMS - TELECONSULTA AMBULATÓRIO DE NUTRIÇÃO PARA CASOS COMPLEXOS
				331351965,	-- SMS - TELECONSULTA - DERMATOLOGIA
				399177348,	-- SMS - TELECONSULTA EM FONOAUDIOLOGIA - POR SESSÃO
				332660485,	-- SMS - TELECONSULTA EM GASTROENTEROLOGIA ADULTO
				331307084,	-- SMS - TELECONSULTA EM HEPATOLOGIA
				328004942,	-- SMS - TELECONSULTA EM HOMEOPATIA
				331581142,	-- SMS - TELECONSULTA EM NEUROLOGIA ADULTO
				331298483,	-- SMS - TELECONSULTA EM NEUROLOGIA PEDIATRIA
				329035923,	-- SMS - TELECONSULTA EM NUTROLOGIA INFANTIL
				400083606,	-- SMS - TELECONSULTA EM ORTOPEDIA
				388659206,	-- SMS - TELECONSULTA EM PEDIATRIA
				328113090,	-- SMS - TELECONSULTA EM PSIQUIATRIA - EMAESM
				330027575	-- SMS - TELECONSULTA - PNEUMOLOGIA ADULTO
				)
		order by 1
		),
		-- EXTRAI DADOS SOBRE A FILA ATUAL, TOTAL DE SOLICITAÇÕES E TOTAL DE ATENDIMENTOS NOS ÚLTIMOS 6 MESES
		fila as (
			select 
				esp.especialidade,
				sum(case when sa.status = 1 then 1 else 0 end) as fila_total,
				sum(case when
					(sa.status = 1) and ((sa.tp_consulta = 0)
										or (sa.tp_consulta = 1 and sa.dt_desejada::date < current_date)
										or (sa.tp_consulta = 1 and sa.dt_desejada is null))
					then 1 else 0 end) 
					as prim_consulta_retorno_passado,
				sum(case when 
					(sa.status = 1) and (sa.tp_consulta = 1 and sa.dt_desejada::date >= current_date)
					then 1 else 0 end)
					as retorno_futuro,
				sum(case when 
					(sa.status <> 6) -- Inclui solicitações não reguladas(0), reguladas(1), agendadas(2) e devolvidas(4). Exclui solicitações canceladas(6).
					and (sa.dt_solicitacao::date >= current_date - interval '180 days')
					then 1 else 0 end)
					as solicit_ult_6m,
				sum(case when sa.status = 4 then 1 else 0 end) as devolvidos
			from 
				especialidades esp
				left join solicitacao_agendamento sa on sa.cd_tp_procedimento = esp.cd_tp_procedimento
			where 
				sa.dt_solicitacao::date < current_date -- Exclui dia de hoje e possíveis erros de solicitações com datas futuras
			group by 1
			order by 1
		),
		oferta as (
			select 
				esp.especialidade as especialidade,
				sum(aga.qtdade_atendimento) as vagas_ult_6m
			from 
				especialidades esp
				join agenda ag on esp.cd_tp_procedimento = ag.cd_tp_procedimento 
			    left join agenda_grade agr on ag.cd_agenda = agr.cd_agenda
			    left join agenda_grade_atendimento aga on aga.cd_ag_grade = agr.cd_ag_grade 
			where 
				agr."data"::date >= (current_date - interval '180 days')
			group by 1
		)
select 
	esp.especialidade,
	fila.fila_total,
	fila.prim_consulta_retorno_passado,
	fila.retorno_futuro,
	fila.solicit_ult_6m,
	fila.devolvidos,
	oferta.vagas_ult_6m
from 
	especialidades esp 
	join fila fila on esp.especialidade = fila.especialidade 
	join oferta oferta on esp.especialidade = oferta.especialidade
order by 1
