with lista_pacientes as (
select 
distinct(uc.cd_usu_cadsus) as usuario
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
	pro.nm_profissional as profissional,
	li.usuario as cod_usuario,
	uc.nm_usuario as nome_usuario,
	uc.cpf as cpf,
	uc.sg_sexo as sexo,
	uc.dt_nascimento as data_nascimento,
	ep.dt_registro,
	ep.ds_prontuario as evolucao
from
	lista_pacientes li
	join atendimento atd on li.usuario = atd.cd_usu_cadsus 
	join usuario_cadsus uc on li.usuario = uc.cd_usu_cadsus 
	join evolucao_prontuario ep on ep.nr_atendimento = atd.nr_atendimento 
	join profissional pro on atd.cd_profissional = pro.cd_profissional 
where 
	atd.cd_profissional = 295453
order by 1