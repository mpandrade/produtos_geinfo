# AMBIENTE ----------------------------------------------------------------------------
options(scipen=999)
gc()
set.seed(1)
setwd("/home/ss/covid/robo_notifica_novo")
getwd()


# PACOTES -----------------------------------------------------------------------------
library(jsonlite)
library(readr)
library(tidyverse)
library(DBI)
library(glue)
library(tidyverse)
library(dbplyr)
library(magrittr) 
library(readr)
library(botor)
library(bigrquery)


# CONEXÃO E EXTRAÇÃO DE DADOS ---------------------------------------------------------
conn_celk <- dbConnect(drv = RPostgres::Postgres(),
                       port = 5432,
                       host = '...',
                       dbname = '...',
                       user = '...',
                       password = '...')
query <- read_lines("query.sql") %>%
  glue_collapse(sep = "\n")

base <- dbGetQuery(conn = conn_celk, statement = query)

#Conectando na base da geinfo
conn_big <- bigrquery::dbConnect(
  bigquery(),
  project = "...",
  dataset = "...",
  billing = "..."
)

mun <- dplyr::tbl(conn_big, "municipio_uf") %>%
  collect()

mun <- mun %>% 
  select(id_municipio, id_municipio_6) %>%
  unique()

robonotifica <- base
robonotifica <- merge(robonotifica, mun, by.x = "codigoMunicipio", by.y = "id_municipio_6", all.x = T)
robonotifica$codigoMunicipio <- as.character(robonotifica$id_municipio)
robonotifica$id_municipio <- NULL

## DADOS SINTOMAS ---------------------------------------------------------------------
robonotifica$sintoma_10 <- ifelse(robonotifica$sintoma_10 == "1", "10", 0)
robonotifica$sintoma_9 <- ifelse(robonotifica$sintoma_9 == "1", "9", 0)
robonotifica$sintoma_8 <- ifelse(robonotifica$sintoma_8 == "1", "8", 0)
robonotifica$sintoma_7 <- ifelse(robonotifica$sintoma_7 == "1", "7", 0)
robonotifica$sintoma_6 <- ifelse(robonotifica$sintoma_6 == "1", "6", 0)
robonotifica$sintoma_5 <- ifelse(robonotifica$sintoma_5 == "1", "5", 0)
robonotifica$sintoma_4 <- ifelse(robonotifica$sintoma_4 == "1", "4", 0)
robonotifica$sintoma_3 <- ifelse(robonotifica$sintoma_3 == "1", "3", 0)
robonotifica$sintoma_2 <- ifelse(robonotifica$sintoma_2 == "1", "2", 0)
robonotifica$sintoma_1 <- ifelse(robonotifica$sintoma_1 == "1", "1", 0)

codigoSintomas <- list()
for(i in 1:nrow(robonotifica)){
  codigoSintomas[[i]] <- c(
    ifelse(robonotifica$sintoma_1[i] == "1", robonotifica$sintoma_1[i], NA),
    ifelse(robonotifica$sintoma_2[i] == "2", robonotifica$sintoma_2[i], NA),
    ifelse(robonotifica$sintoma_3[i] == "3", robonotifica$sintoma_3[i], NA),
    ifelse(robonotifica$sintoma_4[i] == "4", robonotifica$sintoma_4[i], NA),
    ifelse(robonotifica$sintoma_5[i] == "5", robonotifica$sintoma_5[i], NA),
    ifelse(robonotifica$sintoma_6[i] == "6", robonotifica$sintoma_6[i], NA),
    ifelse(robonotifica$sintoma_7[i] == "7", robonotifica$sintoma_7[i], NA),
    ifelse(robonotifica$sintoma_8[i] == "8", robonotifica$sintoma_8[i], NA),
    ifelse(robonotifica$sintoma_9[i] == "9", robonotifica$sintoma_9[i], NA),
    ifelse(robonotifica$sintoma_10[i] == "10", robonotifica$sintoma_10[i], NA))
}
for(i in 1:nrow(robonotifica)){
  codigoSintomas[[i]] <- na.omit(codigoSintomas[[i]])
}

robonotifica$codigoSintomas <- codigoSintomas
robonotifica$sintoma_1 <- NULL
robonotifica$sintoma_2 <- NULL
robonotifica$sintoma_3 <- NULL
robonotifica$sintoma_4 <- NULL
robonotifica$sintoma_5 <- NULL
robonotifica$sintoma_6 <- NULL
robonotifica$sintoma_7 <- NULL
robonotifica$sintoma_8 <- NULL
robonotifica$sintoma_9 <- NULL
robonotifica$sintoma_10 <- NULL


## DADOS CONDICOES --------------------------------------------------------------------
robonotifica$condicao_1 <- ifelse(robonotifica$condicao_1 == "1", "1", 0)
robonotifica$condicao_2 <- ifelse(robonotifica$condicao_2 == "1", "2", 0)
robonotifica$condicao_3 <- ifelse(robonotifica$condicao_3 == "1", "3", 0)
robonotifica$condicao_4 <- ifelse(robonotifica$condicao_4 == "1", "4", 0)
robonotifica$condicao_5 <- ifelse(robonotifica$condicao_5 == "1", "5", 0)
robonotifica$condicao_6 <- ifelse(robonotifica$condicao_6 == "1", "6", 0)
robonotifica$condicao_7 <- ifelse(robonotifica$condicao_7 == "1", "7", 0)
robonotifica$condicao_8 <- ifelse(robonotifica$condicao_8 == "1", "8", 0)
robonotifica$condicao_9 <- ifelse(robonotifica$condicao_9 == "1", "9", 0)

codigoCondicoes <- list()
for(i in 1:nrow(robonotifica)){
  codigoCondicoes[[i]] <- c(
    ifelse(robonotifica$condicao_1[i] == "1", robonotifica$condicao_1[i], NA),
    ifelse(robonotifica$condicao_2[i] == "2", robonotifica$condicao_2[i], NA),
    ifelse(robonotifica$condicao_3[i] == "3", robonotifica$condicao_3[i], NA),
    ifelse(robonotifica$condicao_4[i] == "4", robonotifica$condicao_4[i], NA),
    ifelse(robonotifica$condicao_5[i] == "5", robonotifica$condicao_5[i], NA),
    ifelse(robonotifica$condicao_6[i] == "6", robonotifica$condicao_6[i], NA),
    ifelse(robonotifica$condicao_7[i] == "7", robonotifica$condicao_7[i], NA),
    ifelse(robonotifica$condicao_8[i] == "8", robonotifica$condicao_8[i], NA),
    ifelse(robonotifica$condicao_9[i] == "9", robonotifica$condicao_9[i], NA))
}
for(i in 1:nrow(robonotifica)){
  codigoCondicoes[[i]] <- na.omit(codigoCondicoes[[i]])
}

robonotifica$codigoCondicoes <- codigoCondicoes
robonotifica$condicao_1 <- NULL
robonotifica$condicao_2 <- NULL
robonotifica$condicao_3 <- NULL
robonotifica$condicao_4 <- NULL
robonotifica$condicao_5 <- NULL
robonotifica$condicao_6 <- NULL
robonotifica$condicao_7 <- NULL
robonotifica$condicao_8 <- NULL
robonotifica$condicao_9 <- NULL


# DADOS TESTES -----------------------------------------------------------------------------
testes <- list()
robonotifica$loteTeste <- NA
for(i in 1:nrow(robonotifica)){
  testes[[i]] <- data_frame(
    codigoTipoTeste = robonotifica$codigoTipoTeste[i],
    codigoEstadoTeste = robonotifica$codigoEstadoTeste[i],
    dataColetaTeste = robonotifica$dataColetaTeste[i],
    codigoResultadoTeste = robonotifica$codigoResultadoTeste[i],
    loteTeste = robonotifica$loteTeste[i],
    codigoFabricanteTeste = robonotifica$codigoFabricanteTeste[i])
}

robonotifica$testes <- testes 
robonotifica$codigoTipoTeste <- NULL
robonotifica$codigoEstadoTeste <- NULL
robonotifica$dataColetaTeste <- NULL
robonotifica$codigoResultadoTeste <- NULL
robonotifica$loteTeste <- NULL
robonotifica$codigoFabricanteTeste <- NULL

# GERANDO ARQUIVO JSON ---------------------------------------------------------------------
floripa_js <- toJSON(robonotifica,
                     na = "null",
                     pretty = T,
                     dataframe = "rows")

nome_arquivo <- paste0('sc_florianopolis_covid19_', Sys.Date(), '.json')

write(floripa_js, nome_arquivo)


# DESCONECTANDO ----------------------------------------------------------------------------
dbDisconnect(conn_celk)


