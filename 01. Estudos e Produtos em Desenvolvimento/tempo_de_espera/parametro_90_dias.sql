with 
	datas as (
		select generate_series('2019-01-01'::date,date_trunc('month',current_date),interval '1 month')::date as mes_ano
	),
	solicitacoes as (
	select
        sa.cd_solicitacao,
        sa.status,
        sa.dt_cadastro::date as inclusao,
        agah.dt_cadastro::date as agendamento,
    	case
      	  when tp.ds_tp_procedimento like '%LABORAT%' then 'GRUPO - EXAMES LABORATORIAIS'
      	  when tp.ds_tp_procedimento like '%FISIO%' then 'CONSULTA EM FISIOTERAPIA'
       	  else ltrim(replace(ltrim(tp.ds_tp_procedimento), 'SMS - ', ''))
    	end as nome_grupo
    from
        solicitacao_agendamento sa
        left join tipo_procedimento tp on sa.cd_tp_procedimento = tp.cd_tp_procedimento
        left join agenda_gra_ate_horario agah on sa.cd_solicitacao = agah.cd_solicitacao
	where
        tp.ds_tp_procedimento like 'SMS%' -- APENAS PROCEDIMENTOS DAS FILAS DA SMS, FILTRADAS PELOS NOMES 
        and sa.status in (1,2)
        and sa.tp_fila = 2
    	and tp.cd_tp_procedimento not in (  -- FILAS DESATIVADAS, LISTA VALIDADA PELA REGULAÇÃO
			373693003,	--SMS - AMBULATÓRIO TRANS - CONSULTA MÉDICA
			373357677,	--SMS - AMBULATÓRIO TRANS - PSICOLOGIA
			373692644,	--SMS - AMBULATÓRIO TRANS - SERVIÇO SOCIAL
			373693480,	--SMS - AMBULATÓRIO TRANS - TELECONSULTA MÉDICA
			109862259,	--SMS - CAPSULOTOMIA A YAG LASER
			294611221,	--SMS - CONSULTA EM ACUPUNTURA - POR SESSÃO
			310453674,	--SMS - CONSULTA EM ANESTESIOLOGISTA
			294610333,	--SMS - CONSULTA EM FONOAUDIOLOGIA - POR SESSÃO
			296934980,	--SMS - CONSULTA EM NEFROLOGIA - REVISÃO
			36428007,	--SMS - CONSULTA EM OFTALMOLOGIA - CATARATA - PÓS-OPERATÓRIO
			302421689,	--SMS - CONSULTA EM OFTALMOLOGIA - CÓRNEA
			302421830,	--SMS - CONSULTA EM OFTALMOLOGIA - ESTRABISMO
			302421910,	--SMS - CONSULTA EM OFTALMOLOGIA - PLÁSTICA OCULAR
			109868113,	--SMS - CONSULTA EM OFTALMOLOGIA - REFRAÇÃO
			302815756,	--SMS - CONSULTA EM OFTALMOLOGIA - RETORNO
			109871180,	--SMS - CONSULTA EM OFTALMOLOGIA PTERÍGIO - RETORNO
			369778826,	--SMS - CONSULTA EM PSICOLOGIA AMB INFANTIL - SESSÃO
			304517664,	--SMS - CONSULTA EM UROLOGIA TRANSPLANTE RENAL
			334085,		--SMS - CONSULTA ODONTO PCTE NECESSIDADES ESPECIAIS
			379166031,	--SMS - CONSULTA PÓS TRANSPLANTE RENAL
			335481,		--SMS - CURATIVO GRAU II C/ OU S/ DEBRIDAMENTO
			437546570,	--SMS - GRUPO - CIRURGIAS OFTALMOLÓGICAS
			302423187,	--SMS - GRUPO - TOMOGRAFIA COMPUTADORIZADA - ONCOLOGIA
			384355444,	--SMS - HEMOGRAMA DENGUE/ARBOVIROSES
			331351965,	--SMS - TELECONSULTA - DERMATOLOGIA
			330027575,	--SMS - TELECONSULTA - PNEUMOLOGIA ADULTO
			399177348,	--SMS - TELECONSULTA EM FONOAUDIOLOGIA - POR SESSÃO
			332660485,	--SMS - TELECONSULTA EM GASTROENTEROLOGIA ADULTO
			334003382,	--SMS - TELECONSULTA EM INFECTOLOGIA - RETORNO
			388659206,	--SMS - TELECONSULTA EM PEDIATRIA
			331581142,	--SMS - TELECONSULTA EM NEUROLOGIA ADULTO
			342864050	--SMS - TRANSPORTE DE PACIENTE INTRADIÁRIO            
			)
     order by 1
	 )
select 
	 nome_grupo,
	 d.mes_ano,
	 sum(case 
		when d.mes_ano < inclusao then 0
	 	when d.mes_ano > agendamento then 0
		when (agendamento is not null and d.mes_ano between inclusao and agendamento)
			 or (agendamento is null and d.mes_ano > inclusao) then 
	 			(case when (d.mes_ano - inclusao) between 0 and 90 then 1 else 0 end)
	 	else 0
	 end) as espera_ate_90_dias,
	 sum(case 
		when d.mes_ano < inclusao then 0
	 	when d.mes_ano > agendamento then 0
		when (agendamento is not null and d.mes_ano between inclusao and agendamento) 
			 or (agendamento is null and d.mes_ano > inclusao) then 
	 			(case when (d.mes_ano - inclusao) > 90 then 1 else 0 end)
	 else 0
	 end) as espera_maior_90_dias	 
from 
	solicitacoes s
	cross join datas d
group by 1,2
order by 1,2