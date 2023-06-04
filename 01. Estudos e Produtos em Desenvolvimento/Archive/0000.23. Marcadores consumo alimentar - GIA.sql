-- Define os dados principais dos marcadores de consumo alimentar, com peso e altura do dia do registro
with main_data as (
select
	em.descricao as unidade_atendimento,
	uc.cd_usu_cadsus as cod_usuario,
	uc.nm_usuario,
	uc.sg_sexo as sexo,
	uc.apelido as nome_social,
	to_char(uc.dt_nascimento, 'dd/mm/YYYY') as data_nascimento,
	ciap.referencia as ciap,
	upper(pro.nm_profissional) as profissional,
	upper(tc.ds_cbo) as categoria,
	atd.dt_atendimento::date as data_registro_marcador,
	ap.peso,
	ap.altura
from 	
	esus_marcadores_consumo_alimentar emca
	left join empresa em on emca.empresa = em.empresa
	left join profissional pro on emca.cd_profissional = pro.cd_profissional
	left join tabela_cbo tc on emca.cd_cbo = tc.cd_cbo
	left join usuario_cadsus uc on emca.cd_usu_cadsus = uc.cd_usu_cadsus
	left join atendimento atd on emca.nr_atendimento = atd.nr_atendimento
	left join atendimento_primario ap on emca.nr_atendimento = ap.nr_atendimento 
	left join ciap ciap on atd.cd_ciap = ciap.cd_ciap 
where
	emca.dt_atendimento::date >= '2022-09-01'::date
), 

-- Verifica qual o último registro de peso e altura dos usuários 
max_altura_peso as (
  select 
    atd.dt_atendimento::date as data_ult_peso_altura,
    atd.cd_usu_cadsus,
    ap.peso,
    ap.altura,
    row_number() over (partition by atd.cd_usu_cadsus order by atd.dt_atendimento desc) as row_num
  from 
    atendimento_primario ap 
    join atendimento atd on ap.nr_atendimento = atd.nr_atendimento 
    join main_data md on atd.cd_usu_cadsus = md.cod_usuario
  where 
    ap.peso is not null 
    and ap.altura is not null 
)

-- Junta os dados de marcador de consumo alimentar com o último peso e altura registrados para cada usuário
select 
  md.*,
  malt.data_ult_peso_altura,
  malt.peso,
  malt.altura
from 
  main_data md
left join max_altura_peso malt on md.cod_usuario = malt.cd_usu_cadsus
where 
  malt.row_num = 1 or malt.row_num is null