library(tidyverse)
library(lubridate)
library(rstudioapi)
library(DBI)
library(bit64)
library(openxlsx)

options(dplyr.summarise.inform = FALSE)

gc()

setwd(dirname(getActiveDocumentContext()$path))

conn_celk <- dbConnect(drv = RPostgres::Postgres(),
                       port = 5432,
                       host = 'dbsaudeflorianopolisleitura.celk.com.br',
                       dbname = 'florianopolis_saude',
                       user = 'alexandre_silva',
                       password = 'Z4yvpw8Dr6djJ5S3')


# Versão anterior (válida até junho) ----
atd.query <- read_file('painel_v2_atd.sql')
atd.df <- dbGetQuery(conn = conn_celk, statement = atd.query) %>%
  mutate_if(is.integer64, as.numeric)

rec_v2.query <- read_file('painel_v2_rec.sql')
rec_v2.df <- dbGetQuery(conn = conn_celk, statement = rec_v2.query) %>%
  mutate_if(is.integer64, as.numeric)

cad_v2.query <- read_file('painel_v2_cad.sql')
cad_v2.df <- dbGetQuery(conn = conn_celk, statement = cad_v2.query) %>%
  mutate_if(is.integer64, as.numeric)

prep_v2.query <- read_file('painel_v2_prep.sql')
prep_v2.df <- dbGetQuery(conn = conn_celk, statement = prep_v2.query) %>%
  mutate_if(is.integer64, as.numeric)

cad_v2.df <- cad_v2.df %>%
  mutate(ind_12 = round(cad_incompletos / total_cadastros_novos * 100, 2))

resultado_atd.v2 <- atd.df %>%
  rename(unidade = descricao,
         mes_referencia = mes_atendimento) %>%
  mutate(cor = case_when(ds_primeira_cl_risco == 'Emergência' ~ 'Vermelho',
                         ds_primeira_cl_risco == 'Muito urgente' ~ 'Laranja',
                         ds_primeira_cl_risco == 'Urgente' ~ 'Amarelo',
                         ds_primeira_cl_risco == 'Pouco Urgente' ~ 'Verde',
                         ds_primeira_cl_risco == 'Não Urgente' ~ 'Azul'),
         tempo_cl_risco = difftime(dt_primeira_cl_risco, dt_chegada, units = 'mins'),
         tempo_atend = difftime(dt_primeiro_atend_medico, dt_primeira_cl_risco, units = 'mins')) %>%
  filter(!is.na(mes_referencia) &
           mes_referencia < floor_date(today(),
                                        unit = 'month')) %>%
  group_by(unidade, mes_referencia) %>%
  summarise(ind_1.1 = sum(qt_atend_medico),
            ind_1.2 = sum(qt_atend_cl_risco),
            ind_2.4 = round(mean(tempo_cl_risco, na.rm = T), 2),
            ind_2.5 = round(mean(tempo_atend[cor == 'Vermelho'], na.rm = T), 2),
            ind_2.6 = round(mean(tempo_atend[cor == 'Laranja'], na.rm = T), 2),
            ind_2.7 = round(mean(tempo_atend[cor == 'Amarelo'], na.rm = T), 2),
            ind_2.8 = round(mean(tempo_atend[cor == 'Verde'], na.rm = T), 2),
            ind_2.9 = round(mean(tempo_atend[cor == 'Azul'], na.rm = T), 2),
            quant_atend_pep = sum(qt_atend_medico[fl_cid_exposicao_hiv == 1]),
            ind_2.11 = round((1 - (sum(qt_atend_medico[fl_cid_especifico == 1]) / ind_1.1)) * 100, 2)) %>%
  rowwise() %>%
  mutate(quant_disp_pep = sum(prep_v2.df$dispensacoes[prep_v2.df$unidade == unidade &
                                                         prep_v2.df$mes_referencia == mes_referencia], na.rm = T),
         ind_2.10 = round(quant_disp_pep / quant_atend_pep * 100, 2),
         ind_2.12 = mean(cad_v2.df$ind_12[cad_v2.df$unidade == unidade &
                                            cad_v2.df$mes_referencia == mes_referencia], na.rm = T)) %>%
  ungroup() %>%
  select(-starts_with('quant_'))

resultado.v2 <- rec_v2.df %>%
  mutate(ind_2.16 = round(dispensacoes / receitas * 100, 2)) %>%
  inner_join(resultado_atd.v2, by = c('mes_referencia', 'unidade')) %>%
  select(-c(receitas, dispensacoes)) %>%
  arrange(unidade, mes_referencia) %>%
  select(unidade,
         mes_referencia,
         ind_1.1,
         ind_1.2,
         ind_2.4,
         ind_2.5,
         ind_2.6,
         ind_2.7,
         ind_2.8,
         ind_2.9,
         ind_2.10,
         ind_2.11,
         ind_2.12,
         ind_2.16)

# Cria arquivo de saída ----
result.list <- list(
  'Modelo a partir de 2023-07' = resultado.v2[resultado.v2$mes_referencia >= as.Date('2023-07-01'),]
)

write.xlsx(result.list, file = paste0('indicadores_upas_', today(), '.xlsx'))
