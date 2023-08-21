select 
	a.cd_profissional,
	a.cd_cbo,
	date_trunc('month', a.dt_atendimento)::date as mes,
	count(distinct uc.cd_usu_cadsus) as pessoas_consultadas,
	count(distinct case when eqa.cd_area is not null and length(uc.cpf) = 11 then uc.cd_usu_cadsus end) as pessoas_cadastro_completo
from 
	atendimento a
	join empresa e on e.empresa = a.empresa 
	join usuario_cadsus uc on uc.cd_usu_cadsus = a.cd_usu_cadsus 
	-- Joins para equipe de acompanhamento	
	left join endereco_usuario_cadsus euc on euc.cd_endereco = uc.cd_endereco
	left join equipe eq on uc.cd_equipe = eq.cd_equipe
	left join equipe_area eqa on eq.cd_equipe_area = eqa.cd_equipe_area
where 
	a.dt_atendimento >= date_trunc('month', current_date) - interval '1 year'
	and a.dt_atendimento < date_trunc('month', current_date)
	and uc.st_vivo = 1
	and uc.st_excluido = 0
	and uc.cd_municipio_residencia = 420540	
	and uc.flag_unificado = 0
	and uc.situacao in (0,1)
	and e.cod_atv = 2
group by 1, 2, 3

