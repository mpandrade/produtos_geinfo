-- Quanto custa a medicação dispensada para quem foi atendido na UPA Norte com CID F

select 
	pro.descricao,
	sum(dmi.quantidade_dispensada) as quant_dispensada
from 
	receituario_item ri 
	join receituario r on r.cd_receituario = ri.cd_receituario 
	join atendimento atd on r.nr_atendimento = atd.nr_atendimento 
	join produtos pro on ri.cod_pro = pro.cod_pro 
	join dispensacao_medicamento dm on dm.cd_receituario = r.cd_receituario 
	join dispensacao_medicamento_item dmi on dm.nr_dispensacao = dmi.nr_dispensacao 
where 
	(atd.cd_cid_principal like 'F%' or atd.cd_cid_secundario like 'F%')
	and atd.empresa = 259033
	and extract('year' from atd.dt_atendimento) = 2022
group by 1