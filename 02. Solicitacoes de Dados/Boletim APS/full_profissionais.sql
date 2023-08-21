with
	-- dados crus
	lot_raw as (select distinct
		    ep.cd_profissional,
		    upper(p.nm_profissional) as nm_profissional,
		    p.cpf,
		    ep.dt_entrada::date as dt_entrada,
			lead(ep.dt_entrada::date) over (partition by ep.cd_profissional order by ep.dt_entrada::date) as dt_entrada_prox,
		    ep.dt_desligamento::date as dt_desligamento,
			lag(ep.dt_desligamento::date) over (partition by ep.cd_profissional order by ep.dt_entrada::date) as dt_desligamento_ant,
			e1.empresa as cd_unidade,
			e1.descricao as unidade,
			lag(e1.descricao) over (partition by ep.cd_profissional order by ep.dt_entrada::date) as unidade_ant,
		    eqap.cd_area::text as equipe,
			lag(eqap.cd_area::text) over (partition by ep.cd_profissional order by ep.dt_entrada::date) as equipe_ant,
			eed2.descricao as distrito
		from
		    equipe_profissional ep
		    join equipe eqp on eqp.cd_equipe = ep.cd_equipe 
		    join empresa e1 on eqp.empresa = e1.empresa
		    join equipe_area eqap on eqap.cd_equipe_area = eqp.cd_equipe_area
		    join profissional p on p.cd_profissional = ep.cd_profissional 
			left join end_estruturado_distrito eed2 on e1.cd_end_estruturado_distrito = eed2.cd_end_estruturado_distrito
		where
		    eqp.cd_tp_equipe in ('70', '76', '71')),
	-- ajustando a data de desligamento (às vezes não tem o desligamento no Celk e tem períodos simultâneos)
    lot_adj as (select 
			cd_profissional,
			nm_profissional,
			cpf,
			dt_entrada,
			coalesce(dt_desligamento, dt_entrada_prox - interval '1 day', current_date)::date as dt_desligamento,
			lag(coalesce(dt_desligamento, dt_entrada_prox - interval '1 day', current_date)::date) over (partition by cd_profissional order by dt_entrada) as dt_desligamento_ant,
			cd_unidade,
			unidade,
			unidade_ant,
			equipe,
			equipe_ant,
			distrito
		from
			lot_raw),
	-- criando um novo ciclo cada vez que muda de unidade ou equipe ou cada vez que tem um intervalo maior que um dia sem estar em equipe alguma 
	lot_grp as (select 
			*,
			sum(case 
				when dt_desligamento_ant is null then 1
				when dt_entrada - dt_desligamento_ant > 1 then 1
				when unidade <> unidade_ant then 1
				when equipe <> equipe_ant then 1
				else 0
			end) over (partition by cd_profissional order by dt_entrada rows between unbounded preceding and current row) as ciclo
		from
			lot_adj),
	-- pega a m~´inima data de entrada e máxima data de saída por ciclo
	lotacoes as (select distinct
			cd_profissional,
			nm_profissional,
			cpf,
			cd_unidade,
			unidade,
			equipe,
			distrito,
			min(dt_entrada) over (partition by cd_profissional, ciclo) as dt_entrada,
			max(dt_desligamento) over (partition by cd_profissional, ciclo) as dt_desligamento
		from 
			lot_grp
		order by cd_profissional, dt_entrada)
select 
	*
from 
	lotacoes