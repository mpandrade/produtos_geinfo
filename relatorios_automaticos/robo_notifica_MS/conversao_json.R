# Setando ambiente --------------------------------------------------------
options(scipen=999)
gc()
set.seed(1)
setwd("/home/ss/covid/data")
getwd()

# Pacotes -----------------------------------------------------------------
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



# Conexao com a base ------------------------------------------------------
#Conectando na base da celk
conn_celk <- dbConnect()


query <- read_lines("script_dados_covid_datasus_v6_diario.sql") %>%
        glue_collapse(sep = "\n")


robonotifica <- dbGetQuery(conn = conn_celk, statement = query)

# robonotifica <- read_delim("robonotifica.csv", 
#                            delim = ";", escape_double = FALSE, locale = locale(encoding = "WINDOWS-1252"), 
#                            trim_ws = TRUE, guess_max = 0)

robonotifica$sintoma_10 <- ifelse(robonotifica$sintoma_10 == "1", "10", 0)
robonotifica$sintoma_9 <- ifelse(robonotifica$sintoma_9 == "1", "9", 0)
robonotifica$sintoma_8 <- ifelse(robonotifica$sintoma_8 == "1", "8", 0)
robonotifica$sintoma_7 <- ifelse(robonotifica$sintoma_7 == "1", "7", 0)

codigoSintomas <- list()
for(i in 1:nrow(robonotifica)){
        codigoSintomas[[i]] <- c(ifelse(robonotifica$sintoma_7[i] == "7", robonotifica$sintoma_7[i], NA),
                                  ifelse(robonotifica$sintoma_8[i] == "8", robonotifica$sintoma_8[i], NA),
                                  ifelse(robonotifica$sintoma_9[i] == "9", robonotifica$sintoma_9[i], NA),
                                  ifelse(robonotifica$sintoma_10[i] == "10", robonotifica$sintoma_10[i], NA))
}
for(i in 1:nrow(robonotifica)){
        codigoSintomas[[i]] <- na.omit(codigoSintomas[[i]])
}

robonotifica$codigoSintomas <- codigoSintomas
robonotifica$sintoma_10 <- NULL
robonotifica$sintoma_9 <- NULL
robonotifica$sintoma_8 <- NULL
robonotifica$sintoma_7 <- NULL

testes <- list()
for(i in 1:nrow(robonotifica)){
        testes[[i]] <- data.frame("codigoTipoTeste" = robonotifica$codigoTipoTeste[i], 
                         "codigoEstadoTeste" = robonotifica$codigoEstadoTeste[i],
                         "dataColetaTeste" = robonotifica$dataColetaTeste[i],
                         "codigoResultadoTeste" = robonotifica$codigoResultadoTeste[i],
                         "loteTeste" = robonotifica$loteTeste[i],
                         "codigoFabricanteTeste" = robonotifica$codigoFabricanteTeste[i]) 
}
robonotifica$testes <- testes 
robonotifica$codigoTipoTeste <- NULL
robonotifica$codigoEstadoTeste <- NULL
robonotifica$dataColetaTeste <- NULL
robonotifica$codigoResultadoTeste <- NULL
robonotifica$loteTeste <- NULL
robonotifica$codigoFabricanteTeste <- NULL

floripa_js <- toJSON(robonotifica,
                     na = "null",
                     pretty = T,
                     dataframe = "rows")
#print(floripa_js)

nome_arquivo <- paste0('sc_florianopolis_covid19_', Sys.Date(), '.json')


write(floripa_js, nome_arquivo)

# Desconectando -----------------------------------------------------------
dbDisconnect(conn_celk)




