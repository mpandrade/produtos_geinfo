print(paste0('Iniciando... ', lubridate::now()))

library(tidyverse)
library(lubridate)
library(rstudioapi)
library(DBI)
library(ggplot2)
library(hrbrthemes)
library(readr)
library(fuzzyjoin)
library(bit64)

# Suppress summarise info
options(dplyr.summarise.inform = FALSE)

gc()

setwd(dirname(getActiveDocumentContext()$path))

conn_celk <- dbConnect(drv = RPostgres::Postgres(),
                       port = 5432,
                       host = 'dbsaudeflorianopolisleitura.celk.com.br',
                       dbname = 'florianopolis_saude',
                       user = 'alexandre_silva',
                       password = 'Z4yvpw8Dr6djJ5S3')

# Baixa dados ----
print(paste0('Baixando dados gerais... ', lubridate::now()))
# A expressão "mutate_if(is.integer64, as.numeric)" é usada porque o R não lida bem com algumas colunas que vêm do Postgres
## Dados gerais ----
### População full
usuarios.sql <- read_file('full_usuarios.sql')
usuarios.df <- dbGetQuery(conn = conn_celk, statement = usuarios.sql) %>%
  mutate_if(is.integer64, as.numeric)
### Unidades 
unidades.sql <- read_file('full_unidades.sql')
unidades.df <- dbGetQuery(conn = conn_celk, statement = unidades.sql) %>%
  mutate_if(is.integer64, as.numeric)
### Unidades 
equipes.sql <- read_file('full_equipes.sql')
equipes.df <- dbGetQuery(conn = conn_celk, statement = equipes.sql) %>%
  mutate_if(is.integer64, as.numeric)
equipes.df %>% write_excel_csv2('equipes.csv')
### Profissionais
profissionais.sql <- read_file('full_profissionais.sql')
profissionais.df <- dbGetQuery(conn = conn_celk, statement = profissionais.sql) %>%
  mutate_if(is.integer64, as.numeric)
profissionais.df <- profissionais.df %>%
  mutate(comp_entrada = floor_date(dt_entrada, unit = 'month'),
         comp_desligamento = floor_date(dt_desligamento, unit = 'month'))

## Indicadores estratégicos ----
print(paste0('Baixando dados de indicadores... ', lubridate::now()))
### Indicadores 1, 2, 3 ----
#### Identificação e consultas em gestantes
gestantes.sql <- read_file('ind_123_consultas.sql')
gestantes.df <- dbGetQuery(conn = conn_celk, statement = gestantes.sql) %>%
  mutate_if(is.integer64, as.numeric)
#### Consultas em gestantes
gestantes_exames_lab.sql <- read_file('ind_123_exames_lab.sql')
gestantes_exames_lab.df <- dbGetQuery(conn = conn_celk, statement = gestantes_exames_lab.sql) %>%
  mutate_if(is.integer64, as.numeric)
#### Consultas em gestantes
gestantes_tr_icp.sql <- read_file('ind_123_tr_icp.sql')
gestantes_tr_icp.df <- dbGetQuery(conn = conn_celk, statement = gestantes_tr_icp.sql) %>%
  mutate_if(is.integer64, as.numeric)
#### Consultas em gestantes
gestantes_tr_trr.sql <- read_file('ind_123_tr_trr.sql')
gestantes_tr_trr.df <- dbGetQuery(conn = conn_celk, statement = gestantes_tr_trr.sql) %>%
  mutate_if(is.integer64, as.numeric)

### Indicador 4 ----
coletas_cp.sql <- read_file('ind_4_coletas.sql')
coletas_cp.df <- dbGetQuery(conn = conn_celk, statement = coletas_cp.sql) %>%
  mutate_if(is.integer64, as.numeric)

### Indicador 5 ----
aplicacao_vac.sql <- read_file('ind_5_aplicacoes.sql')
aplicacao_vac.df <- dbGetQuery(conn = conn_celk, statement = aplicacao_vac.sql) %>%
  mutate_if(is.integer64, as.numeric)

### Indicadores 6, 7 ----
#### Identificação por CID
has_cid.sql <- read_file('ind_67_has_dm_id_cid.sql')
has_cid.df <- dbGetQuery(conn = conn_celk, statement = has_cid.sql) %>%
  mutate_if(is.integer64, as.numeric)
#### Identificação por lista de problemas
has_prob.sql <- read_file('ind_67_has_dm_id_prob.sql')
has_prob.df <- dbGetQuery(conn = conn_celk, statement = has_prob.sql) %>%
  mutate_if(is.integer64, as.numeric)
#### Identificação por receitas
has_rece.sql <- read_file('ind_67_has_dm_id_rece.sql')
has_rece.df <- dbGetQuery(conn = conn_celk, statement = has_rece.sql) %>%
  mutate_if(is.integer64, as.numeric)
#### Identificação por lista de problemas
has_dm_consultas.sql <- read_file('ind_67_has_dm_consultas.sql')
has_dm_consultas.df <- dbGetQuery(conn = conn_celk, statement = has_dm_consultas.sql) %>%
  mutate_if(is.integer64, as.numeric)
#### Identificação por receitas
has_pa.sql <- read_file('ind_6_afericao_pa.sql')
has_pa.df <- dbGetQuery(conn = conn_celk, statement = has_pa.sql) %>%
  mutate_if(is.integer64, as.numeric)
#### Identificação por receitas
dm_a1c.sql <- read_file('ind_7_solicitacao_a1c.sql')
dm_a1c.df <- dbGetQuery(conn = conn_celk, statement = dm_a1c.sql) %>%
  mutate_if(is.integer64, as.numeric)

### Indicador 9 ----
producao.sql <- read_file('ind_9_dom_2_ind12346.sql')
producao.df <- dbGetQuery(conn = conn_celk, statement = producao.sql) %>%
  mutate_if(is.integer64, as.numeric)

### Indicador 10 ----
#### Identificação
hiv_id.sql <- read_file('ind_10_hiv_id.sql')
hiv_id.df <- dbGetQuery(conn = conn_celk, statement = hiv_id.sql) %>%
  mutate_if(is.integer64, as.numeric) %>%
  mutate(fl_hiv = 1)
#### Consultas
hiv_cons.sql <- read_file('ind_10_hiv_consultas.sql')
hiv_cons.df <- dbGetQuery(conn = conn_celk, statement = hiv_cons.sql) %>%
  mutate_if(is.integer64, as.numeric)

### Indicador 12 ----
resolutividade.sql <- read_file('ind_12_full.sql')
resolutividade.df <- dbGetQuery(conn = conn_celk, statement = resolutividade.sql) %>%
  mutate_if(is.integer64, as.numeric)

### Indicador 13 ----
vinculo.sql <- read_file('ind_13_full.sql')
vinculo.df <- dbGetQuery(conn = conn_celk, statement = vinculo.sql) %>%
  mutate_if(is.integer64, as.numeric)

### Indicadores 14, 15 ----
reg.sql <- read_file('ind_1415_full.sql')
reg.df <- dbGetQuery(conn = conn_celk, statement = reg.sql) %>%
  mutate_if(is.integer64, as.numeric)

### Indicador 16 ----
sm.sql <- read_file('ind_16_full.sql')
sm.df <- dbGetQuery(conn = conn_celk, statement = sm.sql) %>%
  mutate_if(is.integer64, as.numeric)

print(paste0('Coletando dados de produção... ', lubridate::now()))

## Dados de produção ----
### Indicador 5 ----
vacinas.sql <- read_file('full_vacinas_aplicadas.sql')
vacinas.df <- dbGetQuery(conn = conn_celk, statement = vacinas.sql) %>%
  mutate_if(is.integer64, as.numeric)

### Indicador 7 ----
dispensacoes.sql <- read_file('full_dispensacoes.sql')
dispensacoes.df <- dbGetQuery(conn = conn_celk, statement = dispensacoes.sql) %>%
  mutate_if(is.integer64, as.numeric)

print(paste0('Coletando dados de caracterização da população... ', lubridate::now()))

## Caracterização da população ----
### Indicadores 8, 9 ----
tb.sql <- read_file('dom3_ind89_tb.sql')
tb.df <- dbGetQuery(conn = conn_celk, statement = tb.sql) %>%
  mutate_if(is.integer64, as.numeric)

### Indicador 15 ----
cid.sql <- read_file('full_cid.sql')
cid.df <- dbGetQuery(conn = conn_celk, statement = cid.sql) %>%
  mutate_if(is.integer64, as.numeric)

# Base de indicadores ----
## Cria sequência de datas ----
dt_final <- floor_date(today(), unit = 'months') %m-% months(1)
dt_inicial <- floor_date(today(), unit = 'months') %m-% years(1)
datas <- seq(dt_inicial, dt_final, by = 'month')
ind.df <- as.data.frame(datas) %>%
  rename(mes = datas) %>%
  mutate(eom = (mes %m+% months(1)) - days(1))

## Indicadores estratégicos ----
print(paste0('Calculando indicadores... ', lubridate::now()))

### Indicadores 1, 2, 3 ----
ind_1.123.df <- gestantes.df %>%
  left_join(gestantes_exames_lab.df, by = c('cd_usu_cadsus', 'cd_prenatal', 'mes_fechamento')) %>%
  left_join(gestantes_tr_icp.df, by = c('cd_usu_cadsus', 'cd_prenatal', 'mes_fechamento'), suffix = c('.lab', '.tr')) %>%
  left_join(gestantes_tr_trr.df, by = c('cd_usu_cadsus', 'cd_prenatal', 'mes_fechamento')) %>%
  mutate_if(is.integer64, as.numeric) %>%
  mutate_if(is.numeric, coalesce, 0) %>%
  group_by(cd_usu_cadsus, mes_fechamento) %>%
  summarise(ind_1 = sum(consultas_12s > 0 & consultas_ges >= 6),
            ind_2 = sum((fl_ex_hiv.lab + fl_ex_hiv.tr + fl_ex_hiv) > 0 & (fl_ex_sif.lab + fl_ex_sif.tr + fl_ex_sif) > 0),
            ind_3 = sum(consultas_odo > 0)) %>%
  left_join(usuarios.df, by = 'cd_usu_cadsus') %>%
  group_by(unidade, equipe, mes_fechamento) %>%
  summarise(ind_1.num = sum(ind_1),
            ind_1.den = n(),
            ind_2.num = sum(ind_2),
            ind_2.den = ind_1.den,
            ind_3.num = sum(ind_3),
            ind_3.den = ind_1.den) %>%
  rename(mes = mes_fechamento)

### Indicador 4 ----
usuarios.ind_4.stage <- usuarios.df[usuarios.df$sg_sexo == 'F' &
                                      usuarios.df$dt_nascimento >= min(ind.df$mes) %m-% years(64) &
                                      usuarios.df$dt_nascimento <= max(ind.df$eom) %m-% years(25),]

ind_1.4.df <- ind.df %>%
  cross_join(usuarios.ind_4.stage) %>%
  filter(dt_nascimento >= mes %m-% years(64) &
           dt_nascimento <= eom %m-% years(25)) %>%
  mutate(bop = mes %m-% years(4)) %>%
  left_join(coletas_cp.df,
            join_by(cd_usu_cadsus, bop <= dt_cp, mes > dt_cp)) %>%
  group_by(mes, unidade, equipe, cd_usu_cadsus) %>%
  summarise(coletas = sum(!is.na(dt_cp))) %>%
  group_by(mes, unidade, equipe) %>%
  summarise(ind_4.num = sum(coletas > 0),
            ind_4.den = n())

### Indicador 5 ----
usuarios.ind_5.stage <- usuarios.df[usuarios.df$dt_nascimento >= min(ind.df$mes) %m-% years(1) &
                                      usuarios.df$dt_nascimento <= max(ind.df$eom) %m-% years(1),]

ind_1.5.df <- ind.df %>%
  cross_join(usuarios.ind_5.stage) %>%
  filter(dt_nascimento >= mes %m-% years(1) &
           dt_nascimento <= eom %m-% years(1)) %>%
  mutate(bop = mes %m-% years(4)) %>%
  left_join(aplicacao_vac.df,
            join_by(cd_usu_cadsus, bop <= dt_aplicacao, mes > dt_aplicacao)) %>%
  group_by(mes, unidade, equipe, cd_usu_cadsus) %>%
  summarise(vip = sum(vac_vip, na.rm = T),
            penta = sum(vac_penta, na.rm = T)) %>%
  group_by(mes, unidade, equipe) %>%
  summarise(ind_5.num = sum(vip > 0 & penta > 0),
            ind_5.den = n())

### Indicador 6 ----
#### Base de HAS
has.df <- has_cid.df[has_cid.df$fl_has == 1,] %>%
  union_all(has_prob.df[has_prob.df$fl_has == 1,]) %>%
  union_all(has_rece.df[has_rece.df$fl_has == 1,]) %>%
  group_by(cd_usu_cadsus) %>%
  summarise(dt_inicial = min(dt_inicial)) %>%
  left_join(usuarios.df, by = 'cd_usu_cadsus')

#### Indicador
ind_1.6.df <- ind.df %>%
  cross_join(has.df) %>%
  filter(dt_nascimento <= eom %m-% years(18) &
           (is.na(dt_inicial) | dt_inicial <= mes)) %>% 
  mutate(bop = mes %m-% months(6)) %>%
  left_join(has_dm_consultas.df,
            join_by(cd_usu_cadsus, bop <= dt_atendimento, mes > dt_atendimento)) %>%
  group_by(mes, unidade, equipe, cd_usu_cadsus, bop) %>%
  summarise(consultas_has = sum(!is.na(dt_atendimento))) %>%
  left_join(has_pa.df,
          join_by(cd_usu_cadsus, bop <= dt_atendimento, mes > dt_atendimento)) %>%
  group_by(mes, unidade, equipe, cd_usu_cadsus, consultas_has) %>%
  summarise(afericao_pa = sum(!is.na(dt_atendimento))) %>%
  group_by(mes, unidade, equipe) %>%
  summarise(ind_6.num = sum(consultas_has > 0 & afericao_pa > 0),
            ind_6.den = n())

### Indicador 7 ----
#### Base de DM
dm.df <- has_cid.df[has_cid.df$fl_dm == 1,] %>%
  union_all(has_prob.df[has_prob.df$fl_dm == 1,]) %>%
  union_all(has_rece.df[has_rece.df$fl_dm == 1,]) %>%
  group_by(cd_usu_cadsus) %>%
  summarise(dt_inicial = min(dt_inicial)) %>%
  left_join(usuarios.df, by = 'cd_usu_cadsus')

#### Indicador
ind_1.7.df <- ind.df %>%
  cross_join(dm.df) %>%
  filter(dt_nascimento <= eom %m-% years(18) &
           (is.na(dt_inicial) | dt_inicial <= mes)) %>% 
  mutate(bop = mes %m-% months(6)) %>%
  left_join(has_dm_consultas.df,
            join_by(cd_usu_cadsus, bop <= dt_atendimento, mes > dt_atendimento)) %>%
  group_by(mes, unidade, equipe, cd_usu_cadsus, bop) %>%
  summarise(consultas_dm = sum(!is.na(dt_atendimento))) %>%
  left_join(dm_a1c.df,
            join_by(cd_usu_cadsus, bop <= dt_solicitacao, mes > dt_solicitacao)) %>%
  group_by(mes, unidade, equipe, cd_usu_cadsus, consultas_dm) %>%
  summarise(a1c = sum(!is.na(dt_solicitacao))) %>%
  group_by(mes, unidade, equipe) %>%
  summarise(ind_7.num = sum(consultas_dm > 0 & a1c > 0),
            ind_7.den = n())

### Indicador 8 ----
#### Cálculo estático (apenas último período)
ind_1.8.df <- usuarios.df %>%
  mutate_if(is.integer64, as.numeric) %>%
  group_by(unidade, equipe) %>%
  summarise(ind_8.num = sum(cons_m_e_o_1_ano > 0 & fl_cpf_registrado == 1),
            ind_8.den = sum(cons_m_e_o_1_ano > 0))

### Indicador 9 ----
#### Cálculo estático (apenas último período)
ind_9.staging.df <- producao.df %>%
  # filter(grepl('^2232', cd_cbo)) %>%
  filter(mes < floor_date(today(), unit = 'month') &
           mes >= floor_date(today(), unit = 'month') %m-% years(1))

ind_1.9.df <- usuarios.df %>%
  filter((cons_med_aps + cons_odo_aps + cons_enf_aps) > 0) %>%
  left_join(ind_9.staging.df, by = 'cd_usu_cadsus') %>%
  group_by(equipe, unidade) %>%
  summarise(ind_9.1.num = n_distinct(cd_usu_cadsus[!is.na(consultas) & grepl('^2232', cd_cbo)]),
            ind_9.2.num = n_distinct(cd_usu_cadsus[!is.na(consultas) & grepl('^(225|2231)', cd_cbo)]),
            ind_9.3.num = n_distinct(cd_usu_cadsus[!is.na(consultas) & grepl('^2235', cd_cbo)]),
            ind_9.den = n_distinct(cd_usu_cadsus))

### Indicador 10 ----
ind_1.10.df <- ind.df %>%
  cross_join(hiv_id.df) %>%
  filter(mes > dt_inicial) %>%
  mutate(bop = mes %m-% months(6)) %>%
  left_join(hiv_cons.df,
            join_by(cd_usu_cadsus, bop <= mes_atd, mes > mes_atd)) %>%
  left_join(usuarios.df, by = 'cd_usu_cadsus') %>%
  group_by(mes, cd_usu_cadsus, equipe, unidade) %>%
  summarise(cons_aps = max(!is.na(consultas))) %>%
  group_by(mes, equipe, unidade) %>%
  summarise(ind_10.num = sum(cons_aps > 0),
            ind_10.den = n())

### Indicador 12 ----
ind_1.12.df <- resolutividade.df %>%
  inner_join(profissionais.df,
             join_by(cd_profissional,
                     mes >= comp_entrada,
                     mes < comp_desligamento)) %>%
  rename(unidade = unidade.y) %>%
  group_by(mes, unidade, equipe) %>%
  summarise(ind_12.num = sum(consultas_nr),
            ind_12.den = sum(consultas))

### Indicador 13 ----
#### Cálculo estático (apenas último período)
ind_1.13.df <- usuarios.df %>%
  group_by(unidade, equipe) %>%
  summarise(ind_13.num = sum(cons_med_upa_ano > 0 & cons_med_aps_ano == 0),
            ind_13.den = sum(cons_med_upa_ano > 0 | cons_med_aps_ano > 0))

### Indicadores 14, 15 ----
ind_1.1415.df <- reg.df %>%
  inner_join(profissionais.df,
             join_by(cd_profissional,
                     mes >= comp_entrada,
                     mes < comp_desligamento)) %>%
  rename(unidade = unidade.y) %>%
  group_by(mes, unidade, equipe) %>%
  summarise(ind_14.num = sum(devolvidos),
            ind_14.den = sum(inseridos),
            ind_15.num = sum(respondidos),
            ind_15.den = sum(devolvidos))

### Indicadores 16 ----
#### Cálculo estático (apenas último período)
ind_1.16.df <- sm.df %>%
  filter(fl_outros_dx == 0) %>%
  inner_join(usuarios.df,
             by = 'cd_usu_cadsus') %>%
  group_by(unidade, equipe) %>%
  summarise(ind_16.num = sum(consultas_aps > 0 & consultas_nao_aps == 0),
            ind_16.den = n())

print(paste0('Calculando dados de produção... ', lubridate::now()))

## Dados de produção ----
### Indicadores 1, 2, 3, 4, 6 ----
ind_2.12346 <- producao.df %>%
  mutate(categoria = case_when(grepl('^(225|2231)', cd_cbo) ~ 'Med',
                               grepl('^2235', cd_cbo) ~ 'Enf',
                               grepl('^2232', cd_cbo) ~ 'Odo',
                               T ~ 'TEnf')) %>%
  inner_join(profissionais.df,
             join_by(cd_profissional,
                     mes >= comp_entrada,
                     mes < comp_desligamento)) %>%
  group_by(mes, unidade, equipe) %>%
  summarise(ind_2.1 = sum(consultas),
            ind_2.2 = sum(consultas[categoria == 'Med']),
            ind_2.3 = sum(consultas[categoria == 'Enf']),
            ind_2.4 = sum(consultas[categoria == 'Odo']),
            ind_2.6 = sum(procedimentos[categoria == 'TEnf'])) 

### Indicador 5 ----
ind_2.5.df <- vacinas.df %>%
  mutate(mes = floor_date(dt_aplicacao, unit = 'month')) %>%
  inner_join(usuarios.df, by = 'cd_usu_cadsus') %>%
  group_by(mes, unidade, equipe) %>%
  summarise(ind_2.5 = n())

### Indicador 7 ----
ind_2.7.df <- dispensacoes.df %>%
  rename(ind_2.7 = quantidade,
         unidade = unidade_paciente,
         equipe = equipe_paciente)

print(paste0('Calculando caracterização da população ', lubridate::now()))

## Caracterização da população ----
has_dm_id.df <- has_cid.df %>%
  union(has_prob.df) %>%
  union(has_rece.df)

tb_id.df <- tb.df %>%
  filter(dt_inicio <= (floor_date(today(), unit = 'month') %m-% months(6)) |
           dias_rhze < 56 | dias_rh < 120) %>%
  group_by(cd_usu_cadsus) %>%
  summarise(dt_inicio = max(dt_inicio)) %>%
  mutate(fl_tb = 1)

gestantes_id.df <- gestantes.df %>%
  filter(dt_fechamento >= floor_date(today(), unit = 'month')) %>%
  group_by(cd_usu_cadsus) %>%
  summarise(cd_prenatal = max(cd_prenatal))

sm_id.df <- sm.df %>%
  group_by(cd_usu_cadsus) %>%
  summarise(dt_inicial = min(dt_inicial)) %>%
  mutate(fl_sm = 1)

ind_3 <- usuarios.df %>%
  left_join(has_dm_id.df, by = 'cd_usu_cadsus') %>%
  left_join(hiv_id.df, by = 'cd_usu_cadsus') %>%
  left_join(tb_id.df, by = 'cd_usu_cadsus') %>% 
  left_join(gestantes_id.df, by = 'cd_usu_cadsus') %>% 
  left_join(sm_id.df, by = 'cd_usu_cadsus') %>% 
  group_by(unidade, equipe) %>%
  summarise(ind_3.1 = sum((cons_med_aps + cons_enf_aps + cons_odo_aps) > 0),
            ind_3.2 = sum(cons_med_aps > 0),
            ind_3.3 = sum(cons_enf_aps > 0),
            ind_3.4 = sum(cons_odo_aps > 0),
            ind_3.5 = sum((cons_med_aps + cons_enf_aps + cons_odo_aps) > 0 &
                            dt_nascimento >= (floor_date(today(), unit = 'month') %m-% years(5))),
            ind_3.6 = sum((cons_med_aps + cons_enf_aps + cons_odo_aps) > 0 &
                            dt_nascimento <= (floor_date(today(), unit = 'month') %m-% years(65))),
            ind_3.7 = sum(fl_has > 0 | fl_dm > 0, na.rm = T),
            ind_3.9 = sum(fl_hiv > 0, na.rm = T),
            ind_3.11 = sum(fl_tb > 0, na.rm = T),
            ind_3.13 = sum(!is.na(cd_prenatal)),
            ind_3.14 = sum(!is.na(fl_sm)))

### Item 15 ----
lista_cid.df <- read.csv2('lista_cids.csv')

ind_3.15.df <- cid.df %>%
  filter(!is.na(cid) & cid != '<NA>') %>%
  mutate(cid = case_when(cid == 'J09' ~ 'J10',
                         cid == 'W46' ~ 'Z20',
                         T ~ cid)) %>%
  left_join(lista_cid.df, by = c('cid' = 'CD_CID')) %>%
  mutate(CD_GRUPO = case_when(cid == 'U09' | cid ==  'U89' ~ 'U09',
                              T ~ CD_GRUPO),
         DS_GRUPO = case_when(cid == 'U09' | cid ==  'U89' ~ 'COVID-19',
                              T ~ DS_GRUPO)) %>%
  group_by(unidade, equipe, CD_GRUPO, DS_GRUPO) %>%
  summarise(consultas = sum(consultas)) %>%
  arrange(unidade, equipe, desc(consultas)) %>% 
  group_by(unidade, equipe) %>%
  slice_head(n = 10) %>%
  rename(cd_grupo_cid = CD_GRUPO,
         nm_grupo_cid = DS_GRUPO)

print(paste0('Criando estrutura final de dados... ', lubridate::now()))

# Estrutura final de dados ----
## Indicadores de extração mensal ----
indicadores_mensal.df <- ind_1.123.df %>%
  full_join(ind_1.4.df) %>%
  full_join(ind_1.5.df) %>%
  full_join(ind_1.6.df) %>%
  full_join(ind_1.7.df) %>%
  full_join(ind_1.10.df) %>%
  full_join(ind_1.12.df) %>%
  full_join(ind_1.1415.df) %>%
  full_join(ind_2.12346) %>%
  full_join(ind_2.5.df) %>%
  full_join(ind_2.7.df)

## indicadores de extração isolada ----
indicadores_pontual.df <- ind_1.8.df %>%
  full_join(ind_1.9.df) %>%
  full_join(ind_1.13.df) %>%
  full_join(ind_1.16.df) %>%
  full_join(ind_3)

print(paste0('Criando estrutura por equipe... ', lubridate::now()))

# Cria estruturas para equipe isolada
mes.atual <- floor_date(today(), unit = 'month')

ind_mensal.eqp.df <- indicadores_mensal.df %>%
  # filter(equipe == equipe.analise) %>%
  filter(mes < floor_date(today(), unit = 'month') &
           mes >= floor_date(today(), unit = 'month') %m-% years(1))
ind_mensal.eqp.df %>%
  write_excel_csv2(paste0('ind_mensal_eqp.', mes.atual, '.csv'))

ind_pontual.eqp.df <- indicadores_pontual.df
ind_pontual.eqp.df %>%
  write_excel_csv2(paste0('ind_pontual_eqp.', mes.atual, '.csv'))

ind_3.15.df %>%
  write_excel_csv2(paste0('ind_cid_eqp.', mes.atual, '.csv'))
