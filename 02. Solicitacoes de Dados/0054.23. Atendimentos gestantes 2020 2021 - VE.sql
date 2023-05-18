select 
	uc.cd_usu_cadsus as cod_usuario,
	uc.nm_usuario as nome_gestante,
	uc.dt_nascimento as dt_nascimento,
	uc.nm_mae as nome_mae,
	atd.nr_atendimento as nr_atendimento,
	atd.dt_atendimento::date as dt_atendimento,
	upper(tc.ds_cbo) as categoria_profissional,
	em.descricao as unidade
from
	usuario_cadsus uc   
	join atendimento atd on uc.cd_usu_cadsus = atd.cd_usu_cadsus 
	join empresa em on atd.empresa = em.empresa 
	join tabela_cbo tc on atd.cd_cbo = tc.cd_cbo 
where
	extract('year' from atd.dt_atendimento) in (2020,2021)
	and atd.flag_gestante = 1
	and em.cnpj = '82892282000143'
	and atd.status = 4
order by nome_gestante, dt_atendimento


-- observação: verificar por que há atendimentos com tipo_atendimento 'VACINAS'
-- Atendimento......natureza_tipo....tipo_atendimento