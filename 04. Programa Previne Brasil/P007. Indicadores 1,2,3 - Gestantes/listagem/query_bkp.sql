--- FINALIZADO PARA ANALISE
--- INDICADOR 1 DO PREVINE BRASIL
--- Proporção de gestantes com pelo menos 6 consultas pré-natal (PN) realizadas, sendo a primeira realizada até a 20ª semana de gestação.

with
	denominador_estimado ("quad_texto","denom_estim") as (
		values
			('2022_Q3',1906),
			('2022_Q2',1906),
			('2022_Q1',1906),
			('2021_Q3',1906),
			('2021_Q2',1906),
			('2021_Q1',1906),
			('2020_Q3',1906),
			('2020_Q2',1906),
			('2020_Q1',1905),
			('2019_Q3',1905),
			('2019_Q2',1845),
			('2019_Q1',1842)
	),
	quad as (
		select
			inicio_quad,
			fim_quad,
			to_char(fim_quad,'YYYY')||
				case
					when to_char(fim_quad, 'MM') = '04' then '_Q1'
					when to_char(fim_quad, 'MM') = '08' then '_Q2'
					when to_char(fim_quad, 'MM') = '12' then '_Q3'
				end as quad_texto
		from (
			select
				coalesce((lag(inicio_quad) over()), fim_quad - interval '4 months')::date as inicio_quad,
				(fim_quad - interval '1 day')::date as fim_quad
			FROM (
				SELECT
					generate_series(date_trunc('year', current_date)::date, current_date + interval '1 year', interval '4 months') as inicio_quad,
					generate_series(date_trunc('year', current_date)::date, current_date + interval '1 year' + interval '4 months', interval '4 months') as fim_quad
			) t1
		) t2
		where
			inicio_quad >= (current_date - interval '1 year')::date
	),
	unidade_equipe as (
        select
            ea2.cd_area as cd_area,
            e2.cd_equipe_area as cd_equipe_area,
            em2.descricao as unidade,
            eed2.descricao as distrito
        from    
            equipe e2
            left join equipe_area ea2 on ea2.cd_equipe_area = e2.cd_equipe_area
            left join empresa em2 on em2.empresa = e2.empresa
            left join end_estruturado_distrito eed2 on em2.cd_end_estruturado_distrito = eed2.cd_end_estruturado_distrito
    ),
	gestantes AS (
		SELECT
			ue1.distrito as distrito_endereco,
			ue1.unidade as unidade_endereco,
			case 
				when ue1.cd_area = 1 then 694::text
				else ue1.cd_area::text end as equipe_endereco,
			ue2.distrito as distrito_lista,
			ue2.unidade as unidade_lista,
			case 
				when ue2.cd_area = 1 then 694::text
				else ue2.cd_area::text end as equipe_lista,
			ds3.descricao as distrito_inicio_pn,
			em3.descricao as unidade_inicio_pn,
			case 
				when ea3.cd_area = 1 then 694::text
				else ea3.cd_area::text end as equipe_inicio_pn,
			uc.cd_usu_cadsus,
			pn.dt_ult_menst AS dum,
			(pn.dt_ult_menst + interval '140 day')::date as ate_20_sem,
			coalesce(pn.dt_fechamento, pn.dt_parto, pn.dt_prov_parto::date, (pn.dt_ult_menst + interval '294 day')::date)::date as dt_final_gest,
			uc.nm_usuario,
			uc.dt_nascimento,
			concat_ws(' | ', uc.celular, uc.nr_telefone, uc.nr_telefone_2) as telefones,
			replace(upper(translate(
                lower(euc.nm_logradouro),
                'áàâãäåāăąèééêëēĕėęěìíîïìĩīĭḩóôõöōŏőùúûüũūŭůäàáâãåæçćĉčöòóôõøüùúûßéèêëýñîìíïş,;/\',
                'aaaaaaaaaeeeeeeeeeeiiiiiiiihooooooouuuuuuuuaaaaaaeccccoooooouuuuseeeeyniiiis    ')), ',', ' ') as nome_logradouro,
            replace(euc.nr_logradouro, ',', ' ') as numero_logradouro, -- 12
            replace(upper(translate(
                lower(euc.nm_comp_logradouro),
                'áàâãäåāăąèééêëēĕėęěìíîïìĩīĭḩóôõöōŏőùúûüũūŭůäàáâãåæçćĉčöòóôõøüùúûßéèêëýñîìíïş,;/\',
                'aaaaaaaaaeeeeeeeeeeiiiiiiiihooooooouuuuuuuuaaaaaaeccccoooooouuuuseeeeyniiiis    ')), ',', ' ') as complemento_logradouro
		FROM
			prenatal pn
			join usuario_cadsus uc ON pn.cd_usu_cadsus = uc.cd_usu_cadsus
			left join endereco_usuario_cadsus euc on euc.cd_endereco = uc.cd_endereco
				and euc.st_ativo = 1
			left join tipo_logradouro_cadsus tlc on tlc.cd_tipo_logradouro = euc.cd_tipo_logradouro
			left join cidade c on c.cod_cid = euc.cod_cid
			--left join usuario_cadsus_cns ucc on ucc.cd_usu_cadsus = uc.cd_usu_cadsus
			-- endereco estruturado
			left join endereco_estruturado ee on ee.cd_endereco_estruturado = euc.cd_endereco_estruturado
			left join equipe_micro_area ema on ema.cd_eqp_micro_area = ee.cd_eqp_micro_area
			-- equipe território
            left join unidade_equipe ue1 on ue1.cd_equipe_area = ema.cd_equipe_area
            -- equipe lista
            left join unidade_equipe ue2 on uc.cd_equipe = ue2.cd_equipe_area
			-- equipe inicio pre-natal
			left join usuarios usu on pn.cd_usuario = usu.cd_usuario
			left join equipe_profissional ep on ep.cd_profissional = usu.cd_profissional
				and ep.dt_entrada <= pn.dt_cadastro::date
				and (ep.dt_desligamento is null or ep.dt_desligamento >= pn.dt_cadastro::date)
			left join equipe e3 on e3.cd_equipe = ep.cd_equipe
				and e3.cd_tp_equipe in ('70','76')
			left join equipe_area ea3 on ea3.cd_equipe_area = e3.cd_equipe_area 
			left join empresa em3 on em3.empresa = e3.empresa
				and em3.cod_atv = 2
			left join end_estruturado_distrito ds3 on em3.cd_end_estruturado_distrito = ds3.cd_end_estruturado_distrito
		WHERE
			pn.desfecho not in (1,2,3,4,5,6,7,9,10)
			or pn.desfecho is null
	),
	gest_c_quad as (
		select distinct
			coalesce(gest.equipe_lista, gest.equipe_endereco, gest.equipe_inicio_pn) as equipe_referencia,
			case
				when gest.equipe_lista is not null
					then gest.unidade_lista
				when gest.equipe_lista is null
					and gest.equipe_endereco is not null
					then gest.unidade_endereco
				else gest.unidade_inicio_pn
				end unidade_referencia,
			case
				when gest.equipe_lista is not null
					then gest.distrito_lista
				when gest.equipe_lista is null
					and gest.equipe_endereco is not null
					then gest.distrito_endereco
				else gest.distrito_inicio_pn
				end distrito_referencia,
			gest.cd_usu_cadsus,
			gest.dum,
			gest.ate_20_sem,
			gest.dt_final_gest,
			quad.inicio_quad,
			quad.fim_quad,
			quad.quad_texto,
			gest.nm_usuario,
			gest.dt_nascimento,
			gest.telefones,
			concat_ws(' ', gest.nome_logradouro, gest.numero_logradouro, gest.complemento_logradouro) as endereco
		from
			gestantes gest
			join quad on gest.dt_final_gest between quad.inicio_quad and quad.fim_quad
	),
	gest_c_atd_exame as (
		select
			g1.*,
			max(
				case
					when a1.cd_cbo similar to '(225|2231|2235)%'
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
					when (a1.dt_atendimento between g1.dum and g1.ate_20_sem)
						and a1.cd_cbo similar to '(225|2231|2235)%' 
					then 1
				else 0
				end
			) as cons_20_sem,
			max(
				case
					when a1.cd_cbo like '2232%'
					then 1
				else 0
				end
			) as cons_odo,
			max(
				case
					when a1.cd_cbo similar to '(225|2231|2235)%'
						and (
							(p1.referencia in ('0202031110','0202031179')
							and (er.dt_resultado is not null 
								or er.ds_resultado is not null
								or er.status = 2)
							)
							or trt.tp_teste = 2
						)
					then 1
				else 0
				end
			) as ex_sifilis,
			max(
				case
					when a1.cd_cbo similar to '(225|2231|2235)%'
						and (
							(p1.referencia in ('0202030300','0202030296')
							and (er.dt_resultado is not null 
								or er.ds_resultado is not null
								or er.status = 2)
							)
							or trt.tp_teste = 0
						)
					then 1
				else 0
				end
			) as ex_hiv,
			count(distinct(
				case
					when a1.cd_cbo similar to '(225|2231|2235)%' 
						then a1.nr_atendimento
					end
			)) as atendimentos
		from
			gest_c_quad g1
			left join atendimento a1 on g1.cd_usu_cadsus = a1.cd_usu_cadsus
				and a1.dt_atendimento::date between g1.dum and g1.dt_final_gest
				and a1.status = 4
			inner join empresa e1 on a1.empresa = e1.empresa
				and e1.cod_atv in (1,2)
			left join ciap ciap on a1.cd_ciap = a1.cd_ciap
			left join teste_rapido tr on tr.nr_atendimento = a1.nr_atendimento
			left join teste_rapido_realizado trr on trr.cd_teste_rapido = tr.cd_teste_rapido
			left join teste_rapido_tipo trt on trt.cd_tp_teste = trr.cd_tp_teste 
				and trt.tp_teste in (0,2)
			left join exame ex on a1.nr_atendimento = ex.nr_atendimento
				and ex.status <> 7
			left join exame_requisicao er on er.cd_exame = ex.cd_exame
			left join exame_procedimento ep on er.cd_exame_procedimento = ep.cd_exame_procedimento
			left join procedimento p1 on ep.cd_procedimento = p1.cd_procedimento
				and p1.referencia in ('0202031110','0202031179','0202030300','0202030296')
		group by
			1,2,3,4,5,6,7,8,9,10,11,12,13,14
	),
	calcula_indicador as (
		select
			coalesce(unidade_referencia, 'SEM UNIDADE DE REFERENCIA') as unidade_referencia,
			coalesce(equipe_referencia, 'SEM EQUIPE DE REFERENCIA') as equipe_referencia,
			quad_texto,
			inicio_quad,
			fim_quad,
			nm_usuario,
			dt_nascimento,
			telefones,
			endereco,
			case
				when conta_previne = 1
					then 'sim'
				else 'não'
			end as conta_previne,
			case
				when cons_20_sem = 1
					then 'sim'
				else 'não'
			end as cons_20_sem,
			atendimentos,
			case
				when ex_sifilis = 1
				and ex_hiv = 1
					then 'sim'
				else 'não'
			end as exames_hiv_sifilis,
			case
				when cons_odo = 1
					then 'sim'
				else 'não'
			end as cons_odo
			
		from
			gest_c_atd_exame
		where
			current_date between inicio_quad and fim_quad
	)
select
	*
from
	calcula_indicador ci
order by
	1,2,3
;