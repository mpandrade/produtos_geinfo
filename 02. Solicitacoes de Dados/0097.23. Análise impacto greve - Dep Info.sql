
-- ATENDIMENTOS

with
    cbo as (
        select 
            p.cd_profissional,
            max(pch.cd_cbo) as CBO
        from 
            profissional p 
            join profissional_carga_horaria pch on p.cd_profissional = pch.cd_profissional 
            join tabela_cbo tc on pch.cd_cbo = tc.cd_cbo 
            group by 1
            order by p.cd_profissional
        )

select
	CASE 
		WHEN em.descricao LIKE 'CS %' THEN 'Centro de Saúde'
		WHEN em.descricao LIKE 'POLIC%' THEN 'Policlínica'
		WHEN em.descricao LIKE 'UNIDADE DE PRONTO%' THEN 'UPA'
		WHEN em.descricao LIKE '%CEDRA%' THEN 'CEDRA'
		WHEN em.descricao LIKE '%CAPS%' THEN 'CAPS'
		WHEN em.descricao LIKE 'ALÔ SAÚDE' THEN 'Alô Saúde'
		ELSE 'Outros'
		END AS tipo_unidade,   
	em.descricao as unidade,
	case 
        when atd.cd_cbo similar to '(225|2231)%' then 'Medico'
        when atd.cd_cbo like '2235%' then 'Enfermeiro'
        when atd.cd_cbo like '2232%' then 'Dentista'
        when atd.cd_cbo like '3222%' then 'Tec_enf'
        when atd.cd_cbo like '3224%' then 'Tec_odonto' 
        else 'Outros' end as profissional,
	atd.dt_atendimento::date as dt_atd,
	'Atendimento/Consulta' as tp_atd,
	count(*) as quant
from 
	atendimento atd 
	join empresa em on em.empresa = atd.empresa
	join natureza_procura_tp_atendimento npta on npta.cd_nat_proc_tp_atendimento = atd.cd_nat_proc_tp_atendimento
	join tipo_atendimento ta on npta.cd_tp_atendimento = ta.cd_tp_atendimento
where 
	atd.dt_atendimento::date between '2023-05-01'::date and '2023-06-09'::date
	and atd.status = 4
	and ta.ds_tipo_atendimento <> 'VACINAS'
group by 1,2,3,4

union all

-- APLICAÇÕES DE VACINA

select 
CASE 
		WHEN em.descricao LIKE 'CS %' THEN 'Centro de Saúde'
		WHEN em.descricao LIKE 'POLIC%' THEN 'Policlínica'
		WHEN em.descricao LIKE 'UNIDADE DE PRONTO%' THEN 'UPA'
		WHEN em.descricao LIKE '%CEDRA%' THEN 'CEDRA'
		WHEN em.descricao LIKE '%CAPS%' THEN 'CAPS'
		WHEN em.descricao LIKE 'ALÔ SAÚDE' THEN 'Alô Saúde'
		ELSE 'Outros'
		END AS tipo_unidade,   
	em.descricao as unidade,
	case 
        when cbo similar to '(225|2231)%' then 'Medico'
        when cbo like '2235%' then 'Enfermeiro'
        when cbo like '2232%' then 'Dentista'
        when cbo like '3222%' then 'Tec_enf'
        when cbo like '3224%' then 'Tec_odonto' 
        else 'Outros' end as profissional,
	va.dt_aplicacao::date as dt_atd,
	'Vacinação' as tp_atd,
	count(*) as quant
from
    vac_aplicacao va
    join empresa em on va.empresa = em.empresa
    join tipo_vacina tv on tv.cd_vacina = va.cd_vacina
    left join cbo on va.cd_profissional_aplicacao = cbo.cd_profissional
where
    va.dt_aplicacao::date between '2023-05-01'::date and '2023-06-09'::date
    and tv.tipo_esus in (85, 86, 87, 88) -- Covid
    and va.flag_historico = 0 -- Seleciona somente vacinas aplicadas na rede
group by 1,2,3,4

union all 

-- DISPENSAÇÕES DE MEDICAMENTO

select 
CASE 
		WHEN em.descricao LIKE 'CS %' THEN 'Centro de Saúde'
		WHEN em.descricao LIKE 'POLIC%' THEN 'Policlínica'
		WHEN em.descricao LIKE 'UNIDADE DE PRONTO%' THEN 'UPA'
		WHEN em.descricao LIKE '%CEDRA%' THEN 'CEDRA'
		WHEN em.descricao LIKE '%CAPS%' THEN 'CAPS'
		WHEN em.descricao LIKE 'ALÔ SAÚDE' THEN 'Alô Saúde'
		ELSE 'Outros'
		END AS tipo_unidade,   
	em.descricao as unidade,
	case 
        when cbo similar to '(225|2231)%' then 'Medico'
        when cbo like '2235%' then 'Enfermeiro'
        when cbo like '2232%' then 'Dentista'
        when cbo like '3222%' then 'Tec_enf'
        when cbo like '3224%' then 'Tec_odonto' 
        else 'Outros' end as profissional,
	dm.dt_dispensacao::date as dt_atd,
	'Dispensação Medicamentos' as tp_atd,
	count(*) as quant
from
    dispensacao_medicamento dm    
    join empresa em on em.empresa = dm.empresa
    left join cbo on dm.cd_profissional = cbo.cd_profissional
where
 	dt_dispensacao::date between '2023-05-01'::date and '2023-06-09'::date
group by 1,2,3,4
