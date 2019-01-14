# passo a passo
# importar um df com os links da API com as infos de cada deputado
# criar uma coluna 'name-lower', com o nome de cada deputado em lower, sem acento, separado com traço
# acrescentar a coluna 'name-lower' ao df antigo
# acessar o xml e pegar a url dentro de 'urlFoto'
# salvar foto com o nome contido dentro da coluna 'name-lower'
# repetir procedimento para cada um dos 513 deputados eleitos

# etapa 1
## carregando as bibliotecas
install.packages("abjutils")
install.packages("stringr")
install.packages("XML")
install.packages("xml2")
install.packages("methods")
install.packages(c("httr", "jsonlite", "lubridate"))
library(dplyr)
library(readr)
library(readxl)
library(data.table)
library(abjutils)
library(stringr)
library(XML)
library(xml2)
library(methods)
library(httr)
library(jsonlite)
library(lubridate)

getwd()
setwd("~/Downloads")

# importamos o csv
deputados <- fread("dep-legislatura56-14jan2019.csv")

# tiramos a acentuação
deputados_sem_acentuacao <- as.data.frame(abjutils::rm_accent(deputados$nome))
colnames(deputados_sem_acentuacao) <- "nome_deputado"

# convertemos para lower
deputados_sem_acentuacao <- as.data.frame(tolower(deputados_sem_acentuacao$nome_deputado))
colnames(deputados_sem_acentuacao) <- "nome_deputado"

# substituímos espaço por hífen
deputados_sem_acentuacao <- as.data.frame(sub(" ", "-", deputados_sem_acentuacao$nome_deputado))
colnames(deputados_sem_acentuacao) <- "name_lower"

# acrescentamos nova coluna ao antigo dataframe
deputados[,'name_lower'] <- deputados_sem_acentuacao

# deletamos colunas desnecessárias
deputados$idLegislaturaInicial <- NULL
deputados$idLegislaturaFinal <- NULL
deputados$cpf <- NULL
deputados$siglaSexo <- NULL
deputados$urlRedeSocial <- NULL
deputados$urlWebsite <- NULL
deputados$dataNascimento <- NULL
deputados$dataFalecimento <- NULL
deputados$municipioNascimento <- NULL

# acessar o xml e pegar a url dentro de 'urlFoto'

url <- "https://dadosabertos.camara.leg.br/api/v2/deputados/66179"

