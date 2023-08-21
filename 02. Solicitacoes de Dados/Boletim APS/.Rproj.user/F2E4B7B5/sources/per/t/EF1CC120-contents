library(tidyverse)
library(lubridate)
library(rstudioapi)
library(knitr)
library(ggplot2)
library(ggthemes)

# setwd(dirname(getActiveDocumentContext()$path))

mes.atual <- floor_date(today(), unit = 'month')

if(!file.exists(paste0('ind_mensal_eqp.', mes.atual, '.csv')) |
   !file.exists(paste0('ind_pontual_eqp.', mes.atual, '.csv'))) {
  source('boletim.R')
} else {
  ind_mensal.eqp.df <- read.csv2(paste0('ind_mensal_eqp.', mes.atual, '.csv')) %>%
    mutate(mes = as.Date(mes))
  ind_pontual.eqp.df <- read.csv2(paste0('ind_pontual_eqp.', mes.atual, '.csv'))
  ind_cid.eqp.df <- read.csv2(paste0('ind_cid_eqp.', mes.atual, '.csv'))
  equipes.df <- read.csv2('equipes.csv')
}

ind_mensal.eqp.final <- ind_mensal.eqp.df %>%
  mutate(ind_1.1 = round(ind_1.num / ind_1.den * 100, 2),
         ind_1.2 = round(ind_2.num / ind_2.den * 100, 2),
         ind_1.3 = round(ind_3.num / ind_3.den * 100, 2),
         ind_1.4 = round(ind_4.num / ind_4.den * 100, 2),
         ind_1.5 = round(ind_5.num / ind_5.den * 100, 2),
         ind_1.6 = round(ind_6.num / ind_6.den * 100, 2),
         ind_1.7 = round(ind_7.num / ind_7.den * 100, 2),
         ind_1.10 = round(ind_10.num / ind_10.den * 100, 2),
         ind_1.12 = round((1 - (ind_12.num / ind_12.den)) * 100, 2),
         ind_1.14 = round(ind_14.num / ind_14.den * 100, 2),
         ind_1.15 = round(ind_15.num / ind_15.den * 100, 2)) %>%
  select(unidade,
         equipe,
         mes,
         ind_1.1,
         ind_1.2,
         ind_1.3,
         ind_1.4,
         ind_1.5,
         ind_1.6,
         ind_1.7,
         ind_1.10,
         ind_1.12,
         ind_1.14,
         ind_1.15,
         ind_2.1,
         ind_2.2,
         ind_2.3,
         ind_2.4,
         ind_2.5,
         ind_2.6,
         ind_2.7) %>%
  arrange(unidade, equipe, mes)

ind_mensal.und.final <- ind_mensal.eqp.df %>%
  group_by(unidade, mes) %>%
  summarise_if(is.numeric, sum, na.rm = T) %>%
  mutate(ind_1.1 = round(ind_1.num / ind_1.den * 100, 2),
         ind_1.2 = round(ind_2.num / ind_2.den * 100, 2),
         ind_1.3 = round(ind_3.num / ind_3.den * 100, 2),
         ind_1.4 = round(ind_4.num / ind_4.den * 100, 2),
         ind_1.5 = round(ind_5.num / ind_5.den * 100, 2),
         ind_1.6 = round(ind_6.num / ind_6.den * 100, 2),
         ind_1.7 = round(ind_7.num / ind_7.den * 100, 2),
         ind_1.10 = round(ind_10.num / ind_10.den * 100, 2),
         ind_1.12 = round((1 - (ind_12.num / ind_12.den)) * 100, 2),
         ind_1.14 = round(ind_14.num / ind_14.den * 100, 2),
         ind_1.15 = round(ind_15.num / ind_15.den * 100, 2)) %>%
  select(unidade,
         mes,
         ind_1.1,
         ind_1.2,
         ind_1.3,
         ind_1.4,
         ind_1.5,
         ind_1.6,
         ind_1.7,
         ind_1.10,
         ind_1.12,
         ind_1.14,
         ind_1.15,
         ind_2.1,
         ind_2.2,
         ind_2.3,
         ind_2.4,
         ind_2.5,
         ind_2.6,
         ind_2.7) %>%
  arrange(unidade, mes)


ind_mensal.mun.final <- ind_mensal.eqp.df %>%
  mutate(escopo = 'Municipio') %>%
  group_by(escopo, mes) %>%
  summarise_if(is.numeric, sum, na.rm = T) %>%
  mutate(ind_1.1 = round(ind_1.num / ind_1.den * 100, 2),
         ind_1.2 = round(ind_2.num / ind_2.den * 100, 2),
         ind_1.3 = round(ind_3.num / ind_3.den * 100, 2),
         ind_1.4 = round(ind_4.num / ind_4.den * 100, 2),
         ind_1.5 = round(ind_5.num / ind_5.den * 100, 2),
         ind_1.6 = round(ind_6.num / ind_6.den * 100, 2),
         ind_1.7 = round(ind_7.num / ind_7.den * 100, 2),
         ind_1.10 = round(ind_10.num / ind_10.den * 100, 2),
         ind_1.12 = round((1 - (ind_12.num / ind_12.den)) * 100, 2),
         ind_1.14 = round(ind_14.num / ind_14.den * 100, 2),
         ind_1.15 = round(ind_15.num / ind_15.den * 100, 2)) %>%
  select(escopo,
         mes,
         ind_1.1,
         ind_1.2,
         ind_1.3,
         ind_1.4,
         ind_1.5,
         ind_1.6,
         ind_1.7,
         ind_1.10,
         ind_1.12,
         ind_1.14,
         ind_1.15,
         ind_2.1,
         ind_2.2,
         ind_2.3,
         ind_2.4,
         ind_2.5,
         ind_2.6,
         ind_2.7) %>%
  arrange(mes)

ind_pontual.eqp.final <- ind_pontual.eqp.df %>%
  mutate(ind_1.8 = round(ind_8.num / ind_8.den * 100, 2),
         ind_1.9.1 = round(ind_9.1.num / ind_9.den * 100, 2),
         ind_1.9.2 = round(ind_9.2.num / ind_9.den * 100, 2),
         ind_1.9.3 = round(ind_9.3.num / ind_9.den * 100, 2),
         ind_1.13 = round(ind_13.num / ind_13.den * 100, 2),
         ind_1.16 = round(ind_16.num / ind_16.den * 100, 2),
         ind_3.8 = round(ind_3.7 / ind_3.1 * 100, 2),
         ind_3.10 = round(ind_3.9 / ind_3.1 * 100, 2),
         ind_3.12 = round(ind_3.11 / ind_3.1 * 100, 2)) %>%
  select(unidade,
         equipe,
         ind_1.8,
         ind_1.9.1,
         ind_1.9.2,
         ind_1.9.3,
         ind_1.13,
         ind_1.16,
         ind_3.1,
         ind_3.2,
         ind_3.3,
         ind_3.4,
         ind_3.5,
         ind_3.6,
         ind_3.7,
         ind_3.8,
         ind_3.9,
         ind_3.10,
         ind_3.11,
         ind_3.12,
         ind_3.13,
         ind_3.14) %>%
  arrange(unidade, equipe)

ind_pontual.und.final <- ind_pontual.eqp.df %>%
  group_by(unidade) %>%
  summarise_if(is.numeric, sum, na.rm = T) %>%
  mutate(ind_1.8 = round(ind_8.num / ind_8.den * 100, 2),
         ind_1.9.1 = round(ind_9.1.num / ind_9.den * 100, 2),
         ind_1.9.2 = round(ind_9.2.num / ind_9.den * 100, 2),
         ind_1.9.3 = round(ind_9.3.num / ind_9.den * 100, 2),
         ind_1.13 = round(ind_13.num / ind_13.den * 100, 2),
         ind_1.16 = round(ind_16.num / ind_16.den * 100, 2),
         ind_3.8 = round(ind_3.7 / ind_3.1 * 100, 2),
         ind_3.10 = round(ind_3.9 / ind_3.1 * 100, 2),
         ind_3.12 = round(ind_3.11 / ind_3.1 * 100, 2)) %>%
  select(unidade,
         ind_1.8,
         ind_1.9.1,
         ind_1.9.2,
         ind_1.9.3,
         ind_1.13,
         ind_1.16,
         ind_3.1,
         ind_3.2,
         ind_3.3,
         ind_3.4,
         ind_3.5,
         ind_3.6,
         ind_3.7,
         ind_3.8,
         ind_3.9,
         ind_3.10,
         ind_3.11,
         ind_3.12,
         ind_3.13,
         ind_3.14) %>%
  arrange(unidade)

ind_pontual.mun.final <- ind_pontual.eqp.df %>%
  mutate(escopo = 'Municipio') %>%
  group_by(escopo) %>%
  summarise_if(is.numeric, sum, na.rm = T) %>%
  mutate(ind_1.8 = round(ind_8.num / ind_8.den * 100, 2),
         ind_1.9.1 = round(ind_9.1.num / ind_9.den * 100, 2),
         ind_1.9.2 = round(ind_9.2.num / ind_9.den * 100, 2),
         ind_1.9.3 = round(ind_9.3.num / ind_9.den * 100, 2),
         ind_1.13 = round(ind_13.num / ind_13.den * 100, 2),
         ind_1.16 = round(ind_16.num / ind_16.den * 100, 2),
         ind_3.8 = round(ind_3.7 / ind_3.1 * 100, 2),
         ind_3.10 = round(ind_3.9 / ind_3.1 * 100, 2),
         ind_3.12 = round(ind_3.11 / ind_3.1 * 100, 2)) %>%
  select(escopo,
         ind_1.8,
         ind_1.9.1,
         ind_1.9.2,
         ind_1.9.3,
         ind_1.13,
         ind_1.16,
         ind_3.1,
         ind_3.2,
         ind_3.3,
         ind_3.4,
         ind_3.5,
         ind_3.6,
         ind_3.7,
         ind_3.8,
         ind_3.9,
         ind_3.10,
         ind_3.11,
         ind_3.12,
         ind_3.13,
         ind_3.14)

dados_equipe <- function(equipe){
  equipe.analise <- equipe
  unidade.analise <- equipes.df$unidade[equipes.df$equipe == equipe]
  
  ind_mensal.eqp <- ind_mensal.eqp.final %>%
    filter(equipe == equipe.analise) %>%
    ungroup()
  ind_mensal.und <- ind_mensal.und.final %>%
    filter(unidade == unidade.analise) %>%
    ungroup()
  ind_mensal.mun <- ind_mensal.mun.final %>%
    ungroup()
  
  ind_pontual.eqp <- ind_pontual.eqp.final %>%
    filter(equipe == equipe.analise) %>%
    ungroup()
  ind_pontual.und <- ind_pontual.und.final %>%
    filter(unidade == unidade.analise) %>%
    ungroup()
  ind_pontual.mun <- ind_pontual.mun.final %>%
    ungroup()

  ind_3.15 <- ind_cid.eqp.df %>%
    filter(equipe == 300) %>%
    mutate(freq = round(prop.table(consultas) * 100, 2)) %>%
    select(cd_grupo_cid, nm_grupo_cid, consultas, freq)
  
  ind_1.1 <- select(ind_mensal.eqp, mes, ind_1.1) %>%
    inner_join(select(ind_mensal.und, mes, ind_1.1), by = 'mes') %>%
    inner_join(select(ind_mensal.mun, mes, ind_1.1), by = 'mes') %>%
    `colnames<-`(c('mes',
                   'equipe',
                   'unidade',
                   'municipio'))
  
  ind_1.2 <- select(ind_mensal.eqp, mes, ind_1.2) %>%
    inner_join(select(ind_mensal.und, mes, ind_1.2), by = 'mes') %>%
    inner_join(select(ind_mensal.mun, mes, ind_1.2), by = 'mes') %>%
    `colnames<-`(c('mes',
                   'equipe',
                   'unidade',
                   'municipio'))
  
  ind_1.3 <- select(ind_mensal.eqp, mes, ind_1.3) %>%
    inner_join(select(ind_mensal.und, mes, ind_1.3), by = 'mes') %>%
    inner_join(select(ind_mensal.mun, mes, ind_1.3), by = 'mes') %>%
    `colnames<-`(c('mes',
                   'equipe',
                   'unidade',
                   'municipio'))
  
  ind_1.4 <- select(ind_mensal.eqp, mes, ind_1.4) %>%
    inner_join(select(ind_mensal.und, mes, ind_1.4), by = 'mes') %>%
    inner_join(select(ind_mensal.mun, mes, ind_1.4), by = 'mes') %>%
    `colnames<-`(c('mes',
                   'equipe',
                   'unidade',
                   'municipio'))
  
  ind_1.5 <- select(ind_mensal.eqp, mes, ind_1.5) %>%
    inner_join(select(ind_mensal.und, mes, ind_1.5), by = 'mes') %>%
    inner_join(select(ind_mensal.mun, mes, ind_1.5), by = 'mes') %>%
    `colnames<-`(c('mes',
                   'equipe',
                   'unidade',
                   'municipio'))
  
  ind_1.6 <- select(ind_mensal.eqp, mes, ind_1.6) %>%
    inner_join(select(ind_mensal.und, mes, ind_1.6), by = 'mes') %>%
    inner_join(select(ind_mensal.mun, mes, ind_1.6), by = 'mes') %>%
    `colnames<-`(c('mes',
                   'equipe',
                   'unidade',
                   'municipio'))
  
  ind_1.7 <- select(ind_mensal.eqp, mes, ind_1.7) %>%
    inner_join(select(ind_mensal.und, mes, ind_1.7), by = 'mes') %>%
    inner_join(select(ind_mensal.mun, mes, ind_1.7), by = 'mes') %>%
    `colnames<-`(c('mes',
                   'equipe',
                   'unidade',
                   'municipio'))
  
  ind_1.10 <- select(ind_mensal.eqp, mes, ind_1.10) %>%
    inner_join(select(ind_mensal.und, mes, ind_1.10), by = 'mes') %>%
    inner_join(select(ind_mensal.mun, mes, ind_1.10), by = 'mes') %>%
    `colnames<-`(c('mes',
                   'equipe',
                   'unidade',
                   'municipio'))
  
  ind_1.12 <- select(ind_mensal.eqp, mes, ind_1.12) %>%
    inner_join(select(ind_mensal.und, mes, ind_1.12), by = 'mes') %>%
    inner_join(select(ind_mensal.mun, mes, ind_1.12), by = 'mes') %>%
    `colnames<-`(c('mes',
                   'equipe',
                   'unidade',
                   'municipio'))
  
  ind_1.14 <- select(ind_mensal.eqp, mes, ind_1.14) %>%
    inner_join(select(ind_mensal.und, mes, ind_1.14), by = 'mes') %>%
    inner_join(select(ind_mensal.mun, mes, ind_1.14), by = 'mes') %>%
    `colnames<-`(c('mes',
                   'equipe',
                   'unidade',
                   'municipio'))
  
  ind_1.15 <- select(ind_mensal.eqp, mes, ind_1.15) %>%
    inner_join(select(ind_mensal.und, mes, ind_1.15), by = 'mes') %>%
    inner_join(select(ind_mensal.mun, mes, ind_1.15), by = 'mes') %>%
    `colnames<-`(c('mes',
                   'equipe',
                   'unidade',
                   'municipio'))
  
  ind_2.1 <- select(ind_mensal.eqp, mes, ind_2.1) %>%
    inner_join(select(ind_mensal.und, mes, ind_2.1), by = 'mes') %>%
    inner_join(select(ind_mensal.mun, mes, ind_2.1), by = 'mes') %>%
    `colnames<-`(c('mes',
                   'equipe',
                   'unidade',
                   'municipio'))
  
  ind_2.2 <- select(ind_mensal.eqp, mes, ind_2.2) %>%
    inner_join(select(ind_mensal.und, mes, ind_2.2), by = 'mes') %>%
    inner_join(select(ind_mensal.mun, mes, ind_2.2), by = 'mes') %>%
    `colnames<-`(c('mes',
                   'equipe',
                   'unidade',
                   'municipio'))
  
  ind_2.3 <- select(ind_mensal.eqp, mes, ind_2.3) %>%
    inner_join(select(ind_mensal.und, mes, ind_2.3), by = 'mes') %>%
    inner_join(select(ind_mensal.mun, mes, ind_2.3), by = 'mes') %>%
    `colnames<-`(c('mes',
                   'equipe',
                   'unidade',
                   'municipio'))
  
  ind_2.4 <- select(ind_mensal.eqp, mes, ind_2.4) %>%
    inner_join(select(ind_mensal.und, mes, ind_2.4), by = 'mes') %>%
    inner_join(select(ind_mensal.mun, mes, ind_2.4), by = 'mes') %>%
    `colnames<-`(c('mes',
                   'equipe',
                   'unidade',
                   'municipio'))
  
  ind_2.5 <- select(ind_mensal.eqp, mes, ind_2.5) %>%
    inner_join(select(ind_mensal.und, mes, ind_2.5), by = 'mes') %>%
    inner_join(select(ind_mensal.mun, mes, ind_2.5), by = 'mes') %>%
    `colnames<-`(c('mes',
                   'equipe',
                   'unidade',
                   'municipio'))
  
  ind_2.6 <- select(ind_mensal.eqp, mes, ind_2.6) %>%
    inner_join(select(ind_mensal.und, mes, ind_2.6), by = 'mes') %>%
    inner_join(select(ind_mensal.mun, mes, ind_2.6), by = 'mes') %>%
    `colnames<-`(c('mes',
                   'equipe',
                   'unidade',
                   'municipio'))
  
  ind_2.7 <- select(ind_mensal.eqp, mes, ind_2.7) %>%
    inner_join(select(ind_mensal.und, mes, ind_2.7), by = 'mes') %>%
    inner_join(select(ind_mensal.mun, mes, ind_2.7), by = 'mes') %>%
    `colnames<-`(c('mes',
                   'equipe',
                   'unidade',
                   'municipio'))
  
  ind_1.8 <- select(ind_pontual.eqp, ind_1.8) %>%
    cross_join(select(ind_pontual.und, ind_1.8)) %>%
    cross_join(select(ind_pontual.mun, ind_1.8)) %>%
    `colnames<-`(c('equipe',
                   'unidade',
                   'municipio'))
  
  ind_1.9.1 <- select(ind_pontual.eqp, ind_1.9.1) %>%
    cross_join(select(ind_pontual.und, ind_1.9.1)) %>%
    cross_join(select(ind_pontual.mun, ind_1.9.1)) %>%
    `colnames<-`(c('equipe',
                   'unidade',
                   'municipio'))
  
  ind_1.9.2 <- select(ind_pontual.eqp, ind_1.9.2) %>%
    cross_join(select(ind_pontual.und, ind_1.9.2)) %>%
    cross_join(select(ind_pontual.mun, ind_1.9.2)) %>%
    `colnames<-`(c('equipe',
                   'unidade',
                   'municipio'))
  
  ind_1.9.3 <- select(ind_pontual.eqp, ind_1.9.3) %>%
    cross_join(select(ind_pontual.und, ind_1.9.3)) %>%
    cross_join(select(ind_pontual.mun, ind_1.9.3)) %>%
    `colnames<-`(c('equipe',
                   'unidade',
                   'municipio'))
  
  ind_1.13 <- select(ind_pontual.eqp, ind_1.13) %>%
    cross_join(select(ind_pontual.und, ind_1.13)) %>%
    cross_join(select(ind_pontual.mun, ind_1.13)) %>%
    `colnames<-`(c('equipe',
                   'unidade',
                   'municipio'))
  
  ind_1.16 <- select(ind_pontual.eqp, ind_1.16) %>%
    cross_join(select(ind_pontual.und, ind_1.16)) %>%
    cross_join(select(ind_pontual.mun, ind_1.16)) %>%
    `colnames<-`(c('equipe',
                   'unidade',
                   'municipio'))
  
  ind_3.1 <- select(ind_pontual.eqp, ind_3.1) %>%
    cross_join(select(ind_pontual.und, ind_3.1)) %>%
    cross_join(select(ind_pontual.mun, ind_3.1)) %>%
    `colnames<-`(c('equipe',
                   'unidade',
                   'municipio'))
  
  ind_3.2 <- select(ind_pontual.eqp, ind_3.2) %>%
    cross_join(select(ind_pontual.und, ind_3.2)) %>%
    cross_join(select(ind_pontual.mun, ind_3.2)) %>%
    `colnames<-`(c('equipe',
                   'unidade',
                   'municipio'))
  
  ind_3.3 <- select(ind_pontual.eqp, ind_3.3) %>%
    cross_join(select(ind_pontual.und, ind_3.3)) %>%
    cross_join(select(ind_pontual.mun, ind_3.3)) %>%
    `colnames<-`(c('equipe',
                   'unidade',
                   'municipio'))
  
  ind_3.4 <- select(ind_pontual.eqp, ind_3.4) %>%
    cross_join(select(ind_pontual.und, ind_3.4)) %>%
    cross_join(select(ind_pontual.mun, ind_3.4)) %>%
    `colnames<-`(c('equipe',
                   'unidade',
                   'municipio'))
  
  ind_3.5 <- select(ind_pontual.eqp, ind_3.5) %>%
    cross_join(select(ind_pontual.und, ind_3.5)) %>%
    cross_join(select(ind_pontual.mun, ind_3.5)) %>%
    `colnames<-`(c('equipe',
                   'unidade',
                   'municipio'))
  
  ind_3.6 <- select(ind_pontual.eqp, ind_3.6) %>%
    cross_join(select(ind_pontual.und, ind_3.6)) %>%
    cross_join(select(ind_pontual.mun, ind_3.6)) %>%
    `colnames<-`(c('equipe',
                   'unidade',
                   'municipio'))
  
  ind_3.7 <- select(ind_pontual.eqp, ind_3.7) %>%
    cross_join(select(ind_pontual.und, ind_3.7)) %>%
    cross_join(select(ind_pontual.mun, ind_3.7)) %>%
    `colnames<-`(c('equipe',
                   'unidade',
                   'municipio'))
  
  ind_3.8 <- select(ind_pontual.eqp, ind_3.8) %>%
    cross_join(select(ind_pontual.und, ind_3.8)) %>%
    cross_join(select(ind_pontual.mun, ind_3.8)) %>%
    `colnames<-`(c('equipe',
                   'unidade',
                   'municipio'))
  
  ind_3.9 <- select(ind_pontual.eqp, ind_3.9) %>%
    cross_join(select(ind_pontual.und, ind_3.9)) %>%
    cross_join(select(ind_pontual.mun, ind_3.9)) %>%
    `colnames<-`(c('equipe',
                   'unidade',
                   'municipio'))
  
  ind_3.10 <- select(ind_pontual.eqp, ind_3.10) %>%
    cross_join(select(ind_pontual.und, ind_3.10)) %>%
    cross_join(select(ind_pontual.mun, ind_3.10)) %>%
    `colnames<-`(c('equipe',
                   'unidade',
                   'municipio'))
  
  ind_3.11 <- select(ind_pontual.eqp, ind_3.11) %>%
    cross_join(select(ind_pontual.und, ind_3.11)) %>%
    cross_join(select(ind_pontual.mun, ind_3.11)) %>%
    `colnames<-`(c('equipe',
                   'unidade',
                   'municipio'))
  
  ind_3.12 <- select(ind_pontual.eqp, ind_3.12) %>%
    cross_join(select(ind_pontual.und, ind_3.12)) %>%
    cross_join(select(ind_pontual.mun, ind_3.12)) %>%
    `colnames<-`(c('equipe',
                   'unidade',
                   'municipio'))
  
  ind_3.13 <- select(ind_pontual.eqp, ind_3.13) %>%
    cross_join(select(ind_pontual.und, ind_3.13)) %>%
    cross_join(select(ind_pontual.mun, ind_3.13)) %>%
    `colnames<-`(c('equipe',
                   'unidade',
                   'municipio'))
  
  ind_3.14 <- select(ind_pontual.eqp, ind_3.14) %>%
    cross_join(select(ind_pontual.und, ind_3.14)) %>%
    cross_join(select(ind_pontual.mun, ind_3.14)) %>%
    `colnames<-`(c('equipe',
                   'unidade',
                   'municipio'))
  
  return(list(ind_1.1 = ind_1.1,
              ind_1.2 = ind_1.2,
              ind_1.3 = ind_1.3,
              ind_1.4 = ind_1.4,
              ind_1.5 = ind_1.5,
              ind_1.6 = ind_1.6,
              ind_1.7 = ind_1.7,
              ind_1.10 = ind_1.10,
              ind_1.12 = ind_1.12,
              ind_1.14 = ind_1.14,
              ind_1.15 = ind_1.15,
              ind_2.1 = ind_2.1,
              ind_2.2 = ind_2.2,
              ind_2.3 = ind_2.3,
              ind_2.4 = ind_2.4,
              ind_2.5 = ind_2.5,
              ind_2.6 = ind_2.6,
              ind_2.7 = ind_2.7,
              ind_1.8 = ind_1.8,
              ind_1.9.1 = ind_1.9.1,
              ind_1.9.2 = ind_1.9.2,
              ind_1.9.3 = ind_1.9.3,
              ind_1.13 = ind_1.13,
              ind_1.16 = ind_1.16,
              ind_3.1 = ind_3.1,
              ind_3.2 = ind_3.2,
              ind_3.3 = ind_3.3,
              ind_3.4 = ind_3.4,
              ind_3.5 = ind_3.5,
              ind_3.6 = ind_3.6,
              ind_3.7 = ind_3.7,
              ind_3.8 = ind_3.8,
              ind_3.9 = ind_3.9,
              ind_3.10 = ind_3.10,
              ind_3.11 = ind_3.11,
              ind_3.12 = ind_3.12,
              ind_3.13 = ind_3.13,
              ind_3.14 = ind_3.14,
              ind_3.15 = ind_3.15))
}

painel <- dados_equipe(equipe = equipe)
painel <- painel[c('ind_1.1',
                   'ind_1.2',
                   'ind_1.3',
                   'ind_1.4',
                   'ind_1.5',
                   'ind_1.6',
                   'ind_1.7',
                   'ind_1.8',
                   'ind_1.9.1',
                   'ind_1.9.2',
                   'ind_1.9.3',
                   'ind_1.10',
                   'ind_1.12',
                   'ind_1.13',
                   'ind_1.14',
                   'ind_1.15',
                   'ind_1.16',
                   'ind_2.1',
                   'ind_2.2',
                   'ind_2.3',
                   'ind_2.4',
                   'ind_2.5',
                   'ind_2.6',
                   'ind_2.7',
                   'ind_3.1',
                   'ind_3.2',
                   'ind_3.3',
                   'ind_3.4',
                   'ind_3.5',
                   'ind_3.6',
                   'ind_3.7',
                   'ind_3.8',
                   'ind_3.9',
                   'ind_3.10',
                   'ind_3.11',
                   'ind_3.12',
                   'ind_3.13',
                   'ind_3.14',
                   'ind_3.15')]

