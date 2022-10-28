with lista_pacientes as (
select
	rec.nr_atendimento, 
	p.nm_profissional,
	uc.cd_usu_cadsus,
    uc.nm_usuario,
    uc.cpf,
    uc.sg_sexo as sexo,
    uc.dt_nascimento,
    rec.dt_cadastro::date as data_receita,
    ep.ds_prontuario
from
    usuario_cadsus uc
    join receituario rec on uc.cd_usu_cadsus = rec.cd_usu_cadsus
    join receituario_item item on rec.cd_receituario = item.cd_receituario
    join empresa em on rec.empresa = em.empresa 
    join profissional p on rec.cd_profissional = p.cd_profissional 
    join evolucao_prontuario ep on ep.nr_atendimento = rec.nr_atendimento 
    join atendimento atd on rec.nr_atendimento = atd.nr_atendimento
where
    rec.dt_cadastro between '2017-01-01'::date and '2021-10-01'::date
    and em.empresa = 258683
    and atd.cd_cbo like '2232%'
    and ((item.cod_pro in ('4143741', '4144492', '4147679')) or (item.nm_produto like '%B12%'))
--    and eproc.ds_procedimento like '%B12%'
)
select 
li.nm_profissional as profissional,
li.cd_usu_cadsus as cod_usuario,
li.nm_usuario as nome_usuario,
li.cpf as cpf,
li.sexo as sexo,
li.dt_nascimento as data_nascimento,
li.data_receita as data_receita
from lista_pacientes li
order by 2