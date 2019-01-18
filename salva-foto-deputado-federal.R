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
install.packages("purrr")
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
library(purrr)

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


# criando um novo diretório em downloads
# entrando neste novo diretório
setwd("~/Downloads/")
dir.create("deputados-new")
setwd("~/Downloads/deputados-new")


# loop para baixar todos os arquivos de fotos
# acessa o xml e pega a url dentro de 'urlFoto'
# e ignora links que não funcionam
i <- 1
while(i <= 514) {
  tryCatch({
    url <- deputados$uri[i]
    api_content <- rawToChar(GET(url)$content)
    pessoa_info <- jsonlite::fromJSON(api_content)
    pessoa_foto <- pessoa_info$dados$ultimoStatus$urlFoto
    download.file(pessoa_foto, basename(pessoa_foto), mode = "wb", header = TRUE)
    Sys.sleep(5)
  }, error = function(e) return(NULL)
  )
  i <- i + 1
}


photos <- list.files(
  recursive = TRUE,
  full.names = TRUE
)


# loop para renomear as fotos
# em vez de id, queremos 'name-lower'
for (p in photos) {
  id <- basename(p)
  id <- gsub(".jpg$", "", id)
  name <- deputados$name_lower[match(id, basename(deputados$uri))]
  fname <- paste0(dirname(p), "/", name, ".jpg")
  file.rename(p, fname)
  
  #optional
  cat("renaming", basename(p), "to", name, "\n")
}


### em andamento
# falta descobrir quais deputados tiveram erro na foto
# temos 271 fotos neste momento
## à espera de câmara dos deputados subir as demais fotos
