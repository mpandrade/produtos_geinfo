select
	va.dt_aplicacao::date as dt_aplicacao,
	va.cd_usu_cadsus,
	case when tv.cd_vacina in ('3127216','81982','1550322') then 1 else 0 end as vac_vip,
	case when tv.cd_vacina in ('1550326','81985','1550322') then 1 else 0 end as vac_penta
from 
	vac_aplicacao va  
	left join tipo_vacina tv on tv.cd_vacina = va.cd_vacina
where 
	va.status = 1
	and va.cd_doses = 3
	and (tv.cd_vacina in ('3127216','81982','1550322')
		or tv.cd_vacina in ('1550326','81985','1550322'))