# passo a passo
# importar um df com os links da API com as infos de cada deputado
# criar uma coluna 'name-lower', com o nome de cada deputado em lower, sem acento, separado com traço
# acrescentar a coluna 'name-lower' ao df antigo
# acessar o xml e pegar a url dentro de 'urlFoto'
# salvar foto com o id de cada deputado
# repetir procedimento para cada um dos 513 deputados eleitos

# trocar o id de cada deputado por 'name-lower'


# etapa 1
## carregando as bibliotecas
install.packages("abjutils")
install.packages("stringr")
install.packages("XML")
install.packages("xml2")
install.packages("methods")
install.packages("httr")
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
library(httr)

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

### em andamento
# criamos uma coluna apenas com o id de cada deputado
deputados_id <- strsplit(deputados$uri, "/deputados/")
deputados_id <- deputados_id[2]

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


while(i <= 514) {
  url <- deputados$uri[i]
  api_content <- rawToChar(GET(url)$content)
  pessoa_info <- jsonlite::fromJSON(api_content)
  pessoa_foto <- pessoa_info$dados$ultimoStatus$urlFoto
  download.file(pessoa_foto, basename(pessoa_foto), mode = "wb")
  Sys.sleep(0.3)
  i <- i + 1
}
