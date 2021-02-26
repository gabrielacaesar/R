# aula 02 
# professora gabriela 

round(1.3333, digits = 2)  

pi

resultado <- round(pi)

salario <- 1000
aluguel <- 300

sobra_mensal <- salario - aluguel
sobra_mensal

salario <- 1300

100 > 1
100 < 1

1 == 1
1 == 2
1 != 2

nome <- "gabriela"

1 + 1
1 - 1
1 / 3
10 * 3

idade <- "27"

idade <- as.numeric(idade)

falso <- "FALSE"
falso <- as.logical(falso)

list.files()
getwd()

setwd("/Users/gabrielacaesar/Documents/")

Sys.Date()
Sys.time()

aniversario <- "2021-08-27"
aniversario

tempo_faltante <- as.Date(aniversario) - Sys.Date()
tempo_faltante

setwd("/Users/gabrielacaesar/Documents/r_projetos/curso_r_ibpad/")

dir.create("dados-2")

###  %>% 

#######################################

library(tidyverse)
library(readxl) # excel 

getwd()

agenda <- readr::read_csv("dados/agendas_ministerio_comunicacoes/Agenda Ministro - 16-06-2020 a 18-02-2021.csv")

agenda <- read_csv("dados/agendas_ministerio_comunicacoes/Agenda Ministro - 16-06-2020 a 18-02-2021.csv")

glimpse(agenda)



