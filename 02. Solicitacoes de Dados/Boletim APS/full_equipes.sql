select 
	em.descricao as unidade,
	ea.cd_area as equipe
from 
	equipe e
	join equipe_area ea on ea.cd_equipe_area = e.cd_equipe_area
	join empresa em on em.empresa = e.empresa 