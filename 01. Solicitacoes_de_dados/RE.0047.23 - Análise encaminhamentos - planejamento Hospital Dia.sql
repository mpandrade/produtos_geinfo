/* RE.0047.23 - Encaminhamentos realizados entre abril/22 a março/23,
por idade, especialidade, profissional, unidade de origem.
Objetivo: Planejamento do Hospital Dia.
*/


with dados as (
	select 
		case 
			when em.descricao like 'CS %' then 'Centro de Saúde'
			when em.descricao like 'POLICL_NICA %' then 'Policlínica'
			when em.descricao like 'CAPS%' then 'CAPS'
			when em.descricao like 'CEDRA%' then 'CEDRA'
			when em.descricao like 'UNIDADE DE PRONTO AT%' then 'UPA'
			when em.descricao like 'CTD COVID%' or em.descricao like 'CENTRO DE TRIAGEM%' then 'CTD'			
			else 'Outros serviços' 
			end as unidade_responsavel,
		case 
			when em2.descricao like 'CS %' then 'Centro de Saúde'
			when em2.descricao like 'POLICL_NICA %' then 'Policlínica'
			when em2.descricao like 'CAPS%' then 'CAPS'
			when em2.descricao like 'CEDRA%' then 'CEDRA'
			when em2.descricao like 'UNIDADE DE PRONTO AT%' then 'UPA'
			when em2.descricao like 'CTD COVID%' or em2.descricao like 'CENTRO DE TRIAGEM%' then 'CTD'			
			else 'Outros serviços' 
			end as unidade_origem,			
		case 
			when atd.cd_cbo similar to '(225|2231)%' then 'Medico'
			when atd.cd_cbo like '2235%' then 'Enfermeiro'
			when atd.cd_cbo like '2232%' then 'Odonto'
			when atd.cd_cbo = '223710' then 'Nutricionista'
			when atd.cd_cbo = '221510' then 'Psicologo'
			when atd.cd_cbo = '251605' then 'Assistente Social'
			when atd.cd_cbo like '2241%' then 'Prof. Educacao Fisica'
			when atd.cd_cbo like '2234%' then 'Farmaceutico'
			when atd.cd_cbo like '2236%' then 'Fisioterapeuta'
			else 'Outros profissionais' 
			end as profissional,
	tp.ds_tp_procedimento as tipo_procedimento,
		case 
			when extract('year' from age(sa.dt_cadastro::date,uc.dt_nascimento)) < 1 then 'menor_1a'
			when extract('year' from age(sa.dt_cadastro::date,uc.dt_nascimento)) between 1 and 9 then '01-09'
			when extract('year' from age(sa.dt_cadastro::date,uc.dt_nascimento)) between 10 and 19 then '10-29'
			when extract('year' from age(sa.dt_cadastro::date,uc.dt_nascimento)) between 20 and 39 then '20-39'
			when extract('year' from age(sa.dt_cadastro::date,uc.dt_nascimento)) between 40 and 59 then '40-59'
			when extract('year' from age(sa.dt_cadastro::date,uc.dt_nascimento)) between 60 and 79 then '60-79'
			when extract('year' from age(sa.dt_cadastro::date,uc.dt_nascimento)) >= 80 then '80+'
		end as idade,
		coalesce(sa.cd_cid, atd.cd_cid_principal) as cd_cid,
		count(sa.cd_solicitacao) as num_encaminhamentos
	from 
		solicitacao_agendamento sa
		left join atendimento atd on sa.nr_atendimento_origem = atd.nr_atendimento 
		join usuario_cadsus uc on sa.cd_usu_cadsus = uc.cd_usu_cadsus  
		join tipo_procedimento tp on sa.cd_tp_procedimento = tp.cd_tp_procedimento 
		left join empresa em on sa.unidade = em.empresa
		left join empresa em2 on sa.empresa_origem = em2.empresa 
		
	where 
		sa.dt_cadastro::date between '2022-04-01'::date and '2023-03-31'::date
	group by 1,2,3,4,5,6
)

select 
	unidade_responsavel,
	unidade_origem,
	profissional,
	tipo_procedimento,
	idade,
	c.nm_cid,
	num_encaminhamentos
from 
	dados d
	left join cid c on d.cd_cid = c.cd_cid 