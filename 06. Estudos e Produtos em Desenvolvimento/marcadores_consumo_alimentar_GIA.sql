select
	em.descricao as unidade_atendimento,
	uc.cd_usu_cadsus as cod_usuario,
	uc.nm_usuario,
	to_char(uc.dt_nascimento, 'dd/mm/YYYY') as data_nascimento,
	ciap.referencia as ciap,
	upper(pro.nm_profissional) as profissional,
	upper(tc.ds_cbo) as categoria
from 	
	esus_marcadores_consumo_alimentar emca
	left join empresa em on emca.empresa = em.empresa
	left join profissional pro on emca.cd_profissional = pro.cd_profissional
	left join tabela_cbo tc on emca.cd_cbo = tc.cd_cbo
	left join usuario_cadsus uc on emca.cd_usu_cadsus = uc.cd_usu_cadsus
	left join atendimento atd on emca.nr_atendimento = atd.nr_atendimento
	left join ciap ciap on atd.cd_ciap = ciap.cd_ciap 
where
	emca.dt_atendimento::date >= '2023-01-01'::date