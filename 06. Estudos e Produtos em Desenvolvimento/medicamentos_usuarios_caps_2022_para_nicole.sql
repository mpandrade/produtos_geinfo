with pacientes_caps as (
	select distinct 
		uc.cd_usu_cadsus
	from 
		atendimento atd 
		join usuario_cadsus uc on atd.cd_usu_cadsus = uc.cd_usu_cadsus 
	where 
		atd.dt_atendimento::date between '2022-01-01'::date and '2022-12-31'::date
		and atd.empresa in (195955,195959,195961,195957)
	)
select 
	pro.descricao,
	tr.nm_receita,
	sum(dmi.quantidade_prescrita) as quant_prescrita,
	sum(dmi.quantidade_dispensada) as quant_dispensada
from 
	dispensacao_medicamento dm 
	join dispensacao_medicamento_item dmi on dm.nr_dispensacao = dmi.nr_dispensacao 
	join produtos pro on dmi.cod_pro = pro.cod_pro
	left join tipo_receita tr on pro.cd_receita = tr.cd_receita 
where 
	dm.dt_dispensacao::date between '2022-01-01'::date and '2022-12-31'::date
	and dm.cd_usu_cadsus_destino in (select cd_usu_cadsus from pacientes_caps)
group by 1,2
order by 1