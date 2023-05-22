select 
	case 
		when em.descricao like 'CS %' then 'Centro de Saúde'
		when em.descricao like 'POLICL_NICA %' then 'Policlínica'
		when em.descricao like 'CAPS%' then 'CAPS'
		when em.descricao like 'UNIDADE DE PRONTO AT%' then 'UPA'			
		else 'Outros serviços' 
		end as unidade_responsavel,
	to_char(atd.dt_atendimento, 'MM/YYYY') as mes_ano,
	count(atd.nr_atendimento) as quant_atendimentos,
	count(distinct(atd.cd_usu_cadsus)) as quant_pessoas
from 
	atendimento atd 
	join empresa em on atd.empresa = em.empresa 
where 
	(atd.cd_cid_principal like 'F%' or atd.cd_cid_secundario like 'F%')
	and extract('year' from atd.dt_atendimento) is not null
group by 1,2
order by mes_ano
