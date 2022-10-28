with lista_pacientes as (
select
	distinct(uc.cd_usu_cadsus) as cd_usu_cadsus
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
p.nm_profissional as profissional,
uc.cd_usu_cadsus as cod_usuario,
uc.nm_usuario as nome_usuario,
uc.cpf::text as cpf,
uc.sg_sexo as sexo,
to_char(uc.dt_nascimento, 'dd/mm/YYYY') as data_nascimento,
eproc.ds_procedimento as exame,
eproc.cd_exame_procedimento,
to_char(ex.dt_cadastro, 'dd/mm/YYYY') as data_pedido,
to_char(er.dt_resultado, 'dd/mm/YYYY') as data_resultado,
er.ds_resultado as resultado
from
	lista_pacientes li
	join usuario_cadsus uc on uc.cd_usu_cadsus = li.cd_usu_cadsus
	join exame ex on ex.cd_usu_cadsus = li.cd_usu_cadsus 
    join exame_requisicao er on er.cd_exame = ex.cd_exame 
    join exame_procedimento eproc on er.cd_exame_procedimento = eproc.cd_exame_procedimento
    join profissional p on ex.cd_profissional = p.cd_profissional 
where 
  eproc.ds_procedimento like '%B12%'
order by 2