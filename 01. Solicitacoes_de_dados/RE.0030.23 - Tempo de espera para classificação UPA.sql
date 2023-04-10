with 
	chegada_classificacao as (
		select 
			em.empresa,
			atd.nr_atendimento_principal,
			atd.cd_usu_cadsus,
			atd.dt_chegada as horario_chegada,
			min(atd.dt_atendimento) as horario_classificacao
		from 
			atendimento atd
			join empresa em on atd.empresa = em.empresa 			
			join procedimento pro on atd.cd_procedimento = pro.cd_procedimento
		where 
			atd.empresa in (259033,4272619,259035)
			and date_trunc('month',atd.dt_chegada::date) = date_trunc('month',(current_date - interval '1 month'))
			and atd.classificacao_risco <> 4 --retorno
			and pro.cd_procedimento in (1227,4681)
			and atd.status = 4 --atendimentos concluídos
		group by 1,2,3,4
		)
select 
	em.descricao as unidade,
	date_trunc('second',avg((horario_classificacao - horario_chegada))) as tempo_ate_classificacao
from 
	chegada_classificacao cc
	join empresa em on cc.empresa = em.empresa 
group by 1


