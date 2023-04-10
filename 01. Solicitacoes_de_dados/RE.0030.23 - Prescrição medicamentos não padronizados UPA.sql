	select 
		replace(em.descricao, 'UNIDADE DE PRONTO ATENDIMENTO - ', '') as unidade,
		pro.nm_profissional,
		rec.dt_cadastro::date as data_prescricao,
		rec.cd_usu_cadsus as cod_usuario,
		rec.cd_receituario as cod_receita,
		ri.nm_produto as medicamento
	from
		receituario rec 
		join profissional pro on rec.cd_profissional = pro.cd_profissional 
		left join dispensacao_medicamento dm on rec.cd_receituario = dm.cd_receituario 
		join receituario_item ri on rec.cd_receituario = ri.cd_receituario 
		join empresa em on rec.empresa = em.empresa 
	where 
		rec.dt_receituario::date between '2023-01-01'::date and '2023-03-31'::date
		and rec.cd_receita = 4402315
		and rec.empresa in (259033,4272619,259035)
		and ri.cod_pro is null
order by 2,3 asc
