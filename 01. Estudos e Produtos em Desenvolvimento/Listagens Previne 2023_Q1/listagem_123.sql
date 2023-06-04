
   with 
	dia_mes ("q","inicio","fim") as (
		values
			('_Q1','-01-01','-04-30'),
			('_Q2','-05-01','-08-31'),
			('_Q3','-09-01','-12-31')),
 	ano as (
 		select 
 			generate_series(2019,2022,1) as ano),
 	quad as (
	 	select
			ano||q as quad_texto,
			(ano||inicio)::date as inicio_quad,
			(ano||fim)::date as fim_quad
		from 
			dia_mes cross join ano
		where -- Filtro para o quad atual
			ano||q = '2022_Q3'
    ),
    gestantes AS (
    select 
   		pn.cd_usu_cadsus,
   		pn.dt_ult_menst AS dum,
		(pn.dt_ult_menst + interval '90 day')::date as ate_12_sem,
		coalesce((pn.dt_prov_parto::date + interval '14 day')::date, (pn.dt_ult_menst + interval '294 day')::date)::date as dt_final_gest,
		least(pn.dt_fechamento, coalesce(pn.dt_parto, (pn.dt_prov_parto::date + interval '14 day')::date, (pn.dt_ult_menst + interval '294 day')::date))::date as dt_encer_gest,
    	q.inicio_quad,
		q.fim_quad,
		q.quad_texto,
		pn.desfecho
    from	
    	prenatal pn
    	join quad q on true
    where 
    	(pn.desfecho not in (1,2,3,4,5,6,7,8,9,10) or pn.desfecho is null)
    	and coalesce((pn.dt_prov_parto::date + interval '14 day')::date, (pn.dt_ult_menst + interval '294 day')::date)::date between q.inicio_quad and q.fim_quad
    ),
        gestantes_hiv as ( -- cte para selecionar as paciente que já¡ tinham cid b24, e não fizeram durante a gestação exames hiv
		select
			g2.cd_usu_cadsus,
			1 as hiv
		from 
			gestantes g2
			join atendimento a on g2.cd_usu_cadsus = a.cd_usu_cadsus 
		where 
			a.cd_cid_principal = 'B24'
	)
    select 
    	g1.cd_usu_cadsus,
    	uc.dt_nascimento,
    	g1.quad_texto,
    	g1.inicio_quad,
    	g1.fim_quad,
    	coalesce(em.descricao, em2.descricao,'SEM UNIDADE') as unidade,
		coalesce(eqa.cd_area::text, eqa2.cd_area::text, 'SEM EQUIPE') as equipe,
    		max(
				case
					when a1.cd_cbo similar to '(225|2231|2235)%'
						and e1.cod_atv = 2
						and (a1.dum_gestante is not null
							or a1.idade_gestacional is not null)
						and ((a1.cd_cid_principal in 
								('O11', 'O120', 'O121', 'O122', 'O13', 'O140', 'O141', 'O149', 'O150',
								'O151', 'O159', 'O16', 'O200', 'O208', 'O209', 'O210', 'O211', 'O212',
								'O218', 'O219', 'O220', 'O221', 'O222', 'O223', 'O224', 'O225', 'O228',
								'O229', 'O230', 'O231', 'O232', 'O233', 'O234', 'O235',
								'O239', 'O299', 'O300', 'O301', 'O302', 'O308', 'O309', 'O311', 'O312',
								'O318', 'O320', 'O321', 'O322', 'O323', 'O324', 'O325', 'O326', 'O328',
								'O329', 'O330', 'O331', 'O332', 'O333', 'O334', 'O335', 'O336', 'O337',
								'O338', 'O752', 'O753', 'O990', 'O991', 'O992', 'O993', 'O994', 'O240',
								'O241', 'O242', 'O243', 'O244', 'O249', 'O25', 'O260', 'O261', 'O263',
								'O264', 'O265', 'O268', 'O269', 'O280', 'O281', 'O282', 'O283', 'O284',
								'O285', 'O288', 'O289', 'O290', 'O291', 'O292', 'O293', 'O294', 'O295',
								'O296', 'O298', 'O009', 'O339', 'O340', 'O341', 'O342', 'O343', 'O344',
								'O345', 'O346', 'O347', 'O348', 'O349', 'O350', 'O351', 'O352', 'O353',
								'O354', 'O355', 'O356', 'O357', 'O358', 'O359', 'O360', 'O361', 'O362',
								'O363', 'O365', 'O366', 'O367', 'O368', 'O369', 'O40', 'O410', 'O411',
								'O418', 'O419', 'O430', 'O431', 'O438', 'O439', 'O440', 'O441', 'O460',
								'O468', 'O469', 'O470', 'O471', 'O479', 'O48', 'O995', 'O996', 'O997',
								'Z640', 'O00', 'O10', 'O12', 'O14', 'O15', 'O20', 'O21', 'O22', 'O23',
								'O24', 'O26', 'O28', 'O29', 'O30', 'O31', 'O32', 'O33', 'O34', 'O35', 'O36',
								'O41', 'O43', 'O44', 'O46', 'O47', 'O98', 'Z34', 'Z35', 'Z36', 'Z321',
								'Z33', 'Z340', 'Z348', 'Z349', 'Z350', 'Z351', 'Z352', 'Z353', 'Z354',
								'Z357', 'Z358', 'Z359')
							or a1.cd_cid_secundario in 
								('O11', 'O120', 'O121', 'O122', 'O13', 'O140', 'O141', 'O149', 'O150',
								'O151', 'O159', 'O16', 'O200', 'O208', 'O209', 'O210', 'O211', 'O212',
								'O218', 'O219', 'O220', 'O221', 'O222', 'O223', 'O224', 'O225', 'O228',
								'O229', 'O230', 'O231', 'O232', 'O233', 'O234', 'O235',
								'O239', 'O299', 'O300', 'O301', 'O302', 'O308', 'O309', 'O311', 'O312',
								'O318', 'O320', 'O321', 'O322', 'O323', 'O324', 'O325', 'O326', 'O328',
								'O329', 'O330', 'O331', 'O332', 'O333', 'O334', 'O335', 'O336', 'O337',
								'O338', 'O752', 'O753', 'O990', 'O991', 'O992', 'O993', 'O994', 'O240',
								'O241', 'O242', 'O243', 'O244', 'O249', 'O25', 'O260', 'O261', 'O263',
								'O264', 'O265', 'O268', 'O269', 'O280', 'O281', 'O282', 'O283', 'O284',
								'O285', 'O288', 'O289', 'O290', 'O291', 'O292', 'O293', 'O294', 'O295',
								'O296', 'O298', 'O009', 'O339', 'O340', 'O341', 'O342', 'O343', 'O344',
								'O345', 'O346', 'O347', 'O348', 'O349', 'O350', 'O351', 'O352', 'O353',
								'O354', 'O355', 'O356', 'O357', 'O358', 'O359', 'O360', 'O361', 'O362',
								'O363', 'O365', 'O366', 'O367', 'O368', 'O369', 'O40', 'O410', 'O411',
								'O418', 'O419', 'O430', 'O431', 'O438', 'O439', 'O440', 'O441', 'O460',
								'O468', 'O469', 'O470', 'O471', 'O479', 'O48', 'O995', 'O996', 'O997',
								'Z640', 'O00', 'O10', 'O12', 'O14', 'O15', 'O20', 'O21', 'O22', 'O23',
								'O24', 'O26', 'O28', 'O29', 'O30', 'O31', 'O32', 'O33', 'O34', 'O35', 'O36',
								'O41', 'O43', 'O44', 'O46', 'O47', 'O98', 'Z34', 'Z35', 'Z36', 'Z321',
								'Z33', 'Z340', 'Z348', 'Z349', 'Z350', 'Z351', 'Z352', 'Z353', 'Z354',
								'Z357', 'Z358', 'Z359')
							or ciap.referencia in 
								('W03', 'W05', 'W29', 'W71', 'W78', 'W79', 'W80', 'W81', 'W84', 'W85'))
						or a1.cd_cla_atendimento = 119103)
					then 1
				else 0
				end
			) as conta_previne,
			max(
				case
					when (a1.dt_atendimento between g1.dum and g1.ate_12_sem)
						and e1.cod_atv = 2
						and a1.cd_cbo similar to '(225|2231|2235)%' 
					then 1
				else 0
				end
			) as cons_12_sem,
			max(
				case
					when a1.cd_cbo like '2232%'
					and e1.cod_atv = 2
					then 1
				else 0
				end
			) as cons_odo,
			max(
				case when 
					a1.cd_cbo similar to '(225|2231|2235)%'
					and ((p1.cd_procedimento in (1143,1144,419,421,422,423,426) and (er.dt_resultado is not null or er.ds_resultado is not null or er.status = 2))
					or p2.cd_procedimento in (1143,1144,419,421,422,423,426) 
					or trt.tp_teste = 2)
					then 1
					else 0
				end) as ex_sifilis,
			max(
				case when
					a1.cd_cbo similar to '(225|2231|2235)%'
					and ((p1.cd_procedimento in (1140,1141,315,340,341,412,417) and (er.dt_resultado is not null or er.ds_resultado is not null or er.status = 0))
					or p2.cd_procedimento in (1140,1141,315,340,341,412,417) 
					or trt.tp_teste = 0
					or geh.hiv=1)							
					then 1
					else 0
				end) as ex_hiv,
			count(distinct(
				case
					when a1.cd_cbo similar to '(225|2231|2235)%'
						and e1.cod_atv = 2
						then a1.nr_atendimento
					end
			)) as atendimentos
    	from
    		gestantes g1
    		left join usuario_cadsus uc ON g1.cd_usu_cadsus = uc.cd_usu_cadsus
    		left join atendimento a1 on g1.cd_usu_cadsus = a1.cd_usu_cadsus
    		left join empresa e1 on a1.empresa = e1.empresa 
    		left join ciap ciap on a1.cd_ciap = a1.cd_ciap
    		left join endereco_usuario_cadsus euc on euc.cd_endereco = uc.cd_endereco
			-- Joins para equipe de acompanhamento	
			left join equipe eq on uc.cd_equipe = eq.cd_equipe
			left join equipe_area eqa on eq.cd_equipe_area = eqa.cd_equipe_area
			left join empresa em on eq.empresa = em.empresa 
			-- Joins para equipe definida pelo endereÃ§o estruturado	
			left join endereco_estruturado ee on euc.cd_endereco_estruturado = ee.cd_endereco_estruturado 
			left join equipe_micro_area ema on ema.cd_eqp_micro_area = ee.cd_eqp_micro_area 
			left join equipe_area eqa2 on ema.cd_equipe_area = eqa2.cd_equipe_area 
			left join empresa em2 on ema.empresa = em2.empresa
			--
			left join item_conta_paciente icp on a1.nr_atendimento = icp.nr_atendimento
			left join procedimento p2 on icp.cd_procedimento = p2.cd_procedimento
			left join teste_rapido tr on tr.nr_atendimento = a1.nr_atendimento
			left join teste_rapido_realizado trr on trr.cd_teste_rapido = tr.cd_teste_rapido
			left join teste_rapido_tipo trt on trt.cd_tp_teste = trr.cd_tp_teste 
			left join exame ex on a1.nr_atendimento = ex.nr_atendimento
			left join exame_requisicao er on er.cd_exame = ex.cd_exame
			left join exame_procedimento ep on er.cd_exame_procedimento = ep.cd_exame_procedimento
			left join procedimento p1 on ep.cd_procedimento = p1.cd_procedimento
			left join gestantes_hiv geh on geh.cd_usu_cadsus = g1.cd_usu_cadsus
		where 
			uc.flag_unificado = 0
			and euc.st_ativo = 1
			--and g1.cd_usu_cadsus in (634581,456613,1568747,827114)
			and uc.st_vivo = 1
			and uc.cd_municipio_residencia = 420540
			and uc.situacao in (0,1)
			and a1.dt_atendimento::date between g1.dum and g1.dt_encer_gest
			and (e1.cod_atv = 2 or e1.empresa in (258687,258681,258683,258685))
   		group by 1,2,3,4,5,6,7

	