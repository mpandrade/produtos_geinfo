-- Tuberculose
with 
	notificacoes as (select
			ra.cd_usu_cadsus,
			a.dt_atendimento,
			sum(1) over (partition by ra.cd_usu_cadsus order by a.dt_atendimento range between interval '1 year' preceding and interval '1 second' preceding) as fl_novo_grupo
		from 
			registro_agravo ra 
			join usuario_cadsus uc on uc.cd_usu_cadsus = ra.cd_usu_cadsus 
			join atendimento a on a.nr_atendimento = ra.nr_atendimento 
		where 
			ra.cd_cid ~ 'A1[5-8]|M900|M011|M490|N330|N740|N741|O980|P370'
			and uc.st_vivo = 1
			and uc.st_excluido = 0
			and uc.cd_municipio_residencia = 420540
			and uc.flag_unificado = 0
			and uc.situacao in (0,1)),
	casos as (select 
			cd_usu_cadsus,
			dt_atendimento::date as dt_inicio
		from 
			notificacoes n
		where 
			fl_novo_grupo is null),
	prescricao as (select 
			c.cd_usu_cadsus,
			c.dt_inicio::date as dt_inicio,
			sum(case when ri.cod_pro in ('4147492') then ri.dias_tratamento else 0 end) as dias_rhze,
			sum(case when ri.cod_pro in ('4148050', '4031', '4013', '4143596', '4143339', '4143340') then ri.dias_tratamento else 0 end) as dias_rh
		from
			casos c
			left join receituario r on r.cd_usu_cadsus = c.cd_usu_cadsus 
				and r.dt_receituario >= c.dt_inicio
			left join receituario_item ri on ri.cd_receituario = r.cd_receituario 
		group by 1, 2)
select 
	*
from 
	prescricao p