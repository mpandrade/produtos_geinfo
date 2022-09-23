library(DBI)
library(glue)
library(tidyverse)
library(dbplyr)
library(magrittr) 
library(readr)
library(bigrquery)
library(logr)


#Iniciar log 
###########################################################################################
# Create temp file location
tmp <- file.path("/home/ss/R/atualizacao_cadastral/", "test.log")

# Open log
lf <- log_open(tmp)



# Conectando --------------------------------------------------------------
#Conectando na base da geinfo
conn_celk <- dbConnect(drv = RPostgres::Postgres(),
                       port = 5432,
                       host = 'dbsaudeflorianopolisleitura.celk.com.br',
                       dbname = 'florianopolis_saude',
                       user = 'alexandre_silva',
                       password = 'Z4yvpw8Dr6djJ5S3')



conn_big <- bigrquery::dbConnect(
  bigquery(),
  project = "atualizacao-cadastral-360216",
  dataset = "cadastros",
  billing = "115936702880649416570"
)

##########################################################################################
#Produção
##########################################################################################
query <- read_lines("/home/ss/R/atualizacao_cadastral/query.sql") %>%
  glue_collapse(sep = "\n")


base <- dbGetQuery(conn = conn_celk, statement = query) 


#Agrupar fila, atendidos e faltas - usar script de faltas do deniz - status

base %>%
  DBI::dbWriteTable(conn = conn_big, "cadastros_incompletos",
                    overwrite = T,
                    append = F,
                    row.names = T, #para gerar uma pk
                    value = .)

# Desconectando -----------------------------------------------------------
dbDisconnect(conn_celk)
dbDisconnect(conn_big)


#Finalizar log 
###########################################################################################
log_print("cron bem-sucedido")
log_close()
