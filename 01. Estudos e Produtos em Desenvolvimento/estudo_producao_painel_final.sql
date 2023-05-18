with 
	cbo_deduplicado as (
		SELECT 
				profch.cd_profissional,
				tc.ds_cbo,
				CASE 
					WHEN tc.cd_cbo similar TO '(225|2231)%' AND tc.cd_cbo NOT IN ('2231F9') THEN 'Médico'
					WHEN tc.cd_cbo = '2231F9' 	THEN 	'Médico Residente'
					WHEN tc.cd_cbo like '2235%' 	THEN 	'Enfermeiro'
					WHEN tc.cd_cbo like '2232%' 	THEN 	'Odontólogo'
					WHEN tc.cd_cbo like '3222%' 	THEN 	'Técnico de Enfermagem'
					WHEN tc.cd_cbo like '3224%' 	THEN 	'Técnico de Odontologia' 
					WHEN tc.cd_cbo similar TO '(2236|2234)%' OR tc.cd_cbo IN ('225180','2241E1','251605','223710','251510','225133','225124')	THEN	'NASF' --'Fisioterapeuta'
					ELSE 'Outros' 
				END AS profissional
			FROM 
				profissional_carga_horaria profch
				join tabela_cbo tc on profch.cd_cbo = tc.cd_cbo 
			WHERE (cd_profissional, dt_atualizacao)
				IN (SELECT cd_profissional, MAX(dt_atualizacao)
					FROM profissional_carga_horaria
					GROUP BY cd_profissional)
	),
fonte_dados as (
	select 
	atd.dt_atendimento::date as dt,
	atd.cd_usu_cadsus as cd_usu_cadsus,
	'ATD' || atd.nr_atendimento as cod_atendimento,
	atd.empresa as unidade,
	pro.ds_procedimento,
	atd.cd_profissional
from 
	atendimento atd  
	left join procedimento pro on atd.cd_procedimento = pro.cd_procedimento 
where 
	atd.status = 4
and 
	atd.dt_atendimento::date >= '2019-03-01'::date

union all 

select 
	va.dt_aplicacao::date as dt,
	va.cd_usu_cadsus as cd_usu_cadsus,
	'VAC' || va.cd_vac_aplicacao as cod_atendimento,
	va.empresa as unidade,
	'VACINAÇÃO' as ds_procedimento,
	va.cd_profissional_aplicacao as cd_profissional
from 
	vac_aplicacao va  
where 
	va.dt_aplicacao::date >= '2019-03-01'::date
	and va.flag_historico = 0
union all 

select 
	dm.dt_dispensacao::date as dt,
	dm.cd_usu_cadsus_destino as cd_usu_cadsus,
	'DME' || dm.nr_dispensacao as cod_atendimento,
	dm.empresa as unidade,
	'DISPENSAÇÃO DE MEDICAMENTO' as ds_procedimento,
	dm.cd_profissional
from 
	dispensacao_medicamento dm  
where 
	dm.dt_dispensacao::date >= '2019-03-01'::date
)
select 
	date_trunc('month', fd.dt)::date as mes,
	fd.cd_usu_cadsus,
	uc.sg_sexo as sexo,
	extract('year' from age(fd.dt,uc.dt_nascimento)) as idade,
	case 
		when extract('year' from age(fd.dt,uc.dt_nascimento)) < 1 then 'Menor de 1 ano'
		when extract('year' from age(fd.dt,uc.dt_nascimento)) between 1 and 5 then '01 a 05 anos'
		when extract('year' from age(fd.dt,uc.dt_nascimento)) between 6 and 10 then '06 a 10 anos'
		when extract('year' from age(fd.dt,uc.dt_nascimento)) between 11 and 15 then '11 a 15 anos'
		when extract('year' from age(fd.dt,uc.dt_nascimento)) between 16 and 20 then '16 a 20 anos'
		when extract('year' from age(fd.dt,uc.dt_nascimento)) between 21 and 25 then '21 a 25 anos'
		when extract('year' from age(fd.dt,uc.dt_nascimento)) between 26 and 30 then '26 a 30 anos'
		when extract('year' from age(fd.dt,uc.dt_nascimento)) between 31 and 35 then '31 a 35 anos'
		when extract('year' from age(fd.dt,uc.dt_nascimento)) between 36 and 40 then '36 a 40 anos'
		when extract('year' from age(fd.dt,uc.dt_nascimento)) between 41 and 45 then '41 a 45 anos'
		when extract('year' from age(fd.dt,uc.dt_nascimento)) between 46 and 50 then '46 a 50 anos'
		when extract('year' from age(fd.dt,uc.dt_nascimento)) between 51 and 55 then '51 a 55 anos'
		when extract('year' from age(fd.dt,uc.dt_nascimento)) between 56 and 60 then '56 a 60 anos'
		when extract('year' from age(fd.dt,uc.dt_nascimento)) between 61 and 65 then '61 a 65 anos'
		when extract('year' from age(fd.dt,uc.dt_nascimento)) between 66 and 70 then '66 a 70 anos'
		when extract('year' from age(fd.dt,uc.dt_nascimento)) between 71 and 75 then '71 a 75 anos'
		when extract('year' from age(fd.dt,uc.dt_nascimento)) between 76 and 80 then '76 a 80 anos'
		when extract('year' from age(fd.dt,uc.dt_nascimento)) between 81 and 85 then '81 a 85 anos'
		when extract('year' from age(fd.dt,uc.dt_nascimento)) between 86 and 90 then '86 a 90 anos'
		when extract('year' from age(fd.dt,uc.dt_nascimento)) between 91 and 95 then '91 a 95 anos'
		when extract('year' from age(fd.dt,uc.dt_nascimento)) between 96 and 100 then '96 a 100 anos'
		when extract('year' from age(fd.dt,uc.dt_nascimento)) > 100 then 'Maior de 100 anos'
	end	as faixa_etaria,
	fd.cod_atendimento,
	em.descricao as unidade,
	case 
		when em.cod_atv = 2 then 'Centro de Saúde'
		when em.descricao LIKE 'POLIC%' then 'Policlínica'
		when em.descricao LIKE 'UNIDADE DE PRONTO%' then 'UPA'
		when em.descricao like '%CEDRA%' THEN 'CEDRA'
		when em.descricao LIKE '%CAPS%' THEN 'CAPS'
		when em.descricao LIKE 'ALÔ SAÚDE' THEN 'Alô Saúde'
		else 'Outros'
	END AS tipo_unidade,
	ds_procedimento,
	cd.profissional,
	cd.ds_cbo
from 
	fonte_dados fd
	join empresa em on fd.unidade = em.empresa 
	join usuario_cadsus uc on fd.cd_usu_cadsus = uc.cd_usu_cadsus 
	join cbo_deduplicado cd on fd.cd_profissional = cd.cd_profissional
	