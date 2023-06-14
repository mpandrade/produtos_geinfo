select 
	uc.cd_usu_cadsus,
	agah.cd_ag_gra_atendimento,
	extract('year' from age(agah.dt_agendamento::date,uc.dt_nascimento)) as idade,
	uc.sg_sexo as sexo,
	upper(tlc.ds_tipo_logradouro) || ' ' || upper(euc.nm_logradouro) as logradouro,
    euc.nr_logradouro as numero,
    upper(euc.nm_bairro) as bairro,
    c.descricao as municipio,
    e.sigla as estado,
	em.descricao as unidade_origem,
	em2.descricao as unidade_executante,
	agah.dt_agendamento,
	to_char(agah.dt_agendamento, 'MM-YYYY') as mes_ano,
	case 
		when extract('dow' from agah.dt_agendamento) = 0 then 'Domingo'
		when extract('dow' from agah.dt_agendamento) = 1 then '2a'
		when extract('dow' from agah.dt_agendamento) = 2 then '3a'
		when extract('dow' from agah.dt_agendamento) = 3 then '4a'
		when extract('dow' from agah.dt_agendamento) = 4 then '5a'
		when extract('dow' from agah.dt_agendamento) = 5 then '6a'
		when extract('dow' from agah.dt_agendamento) = 6 then 'Sábado'
	end as dia_semana,
	to_char(agah.dt_agendamento, 'HH24:MI') as horario,
	tp.ds_tp_procedimento as especialidade,
	pro.nm_profissional,
	case 
		when agah.status = 1 then 'Agendado'
		when agah.status = 2 then 'Concluído'
		when agah.status = 3 then 'Cancelado'
		when agah.status = 4 then 'Falta' 
		when agah.status = 5 then 'Remanejado' 
	end as status
from 
	agenda_gra_ate_horario agah 
	left join agenda_grade_atendimento aga on agah.cd_ag_gra_atendimento = aga.cd_ag_gra_atendimento 
	left join agenda_grade agr on aga.cd_ag_grade = agr.cd_ag_grade 
	left join agenda ag on ag.cd_agenda = agr.cd_agenda 
	left join tipo_procedimento tp on agah.cd_tp_procedimento = tp.cd_tp_procedimento
	left join atendimento atd on agah.nr_atendimento = atd.nr_atendimento 
	left join usuario_cadsus uc on agah.cd_usu_cadsus = uc.cd_usu_cadsus
    left join endereco_usuario_cadsus euc on uc.cd_endereco = euc.cd_endereco
    left join tipo_logradouro_cadsus tlc on euc.cd_tipo_logradouro = tlc.cd_tipo_logradouro
    left join cidade c on euc.cod_cid = c.cod_cid
    left join estado e on c.cod_est = e.cod_est
	left join empresa em on agah.empresa_origem = em.empresa
	left join empresa em2 on ag.empresa = em2.empresa
	left join profissional pro on agah.cd_profissional = pro.cd_profissional
where 
	agah.dt_agendamento::date between '2022-05-01'::date and '2023-05-31'::date
	and ag.tp_agenda = 'C'
	and tp.ds_tp_procedimento like 'SMS%'
	