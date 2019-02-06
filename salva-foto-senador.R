# objetivo
## acessar a página de cada senador
## salvar a foto de cada senador
## renomear o arquivo da foto
## substituir o 'id' pelo nome em lower, com traço

library(data.table)
library(rvest)
library(lubridate)
library(stringr)
library(dplyr)
library(RCurl)
library(XML)
library(httr)
library(purrr)
# link que contém todos os senadores em exercício
url <- "https://www25.senado.leg.br/web/senadores/em-exercicio/-/e/por-nome"


# get all url on the webpage
url2 <- getURL(url)
parsed <- htmlParse(url2)
links <- xpathSApply(parsed,path = "//a",xmlGetAttr,"href")

links <- do.call(rbind.data.frame, links) 

colnames(links)[1] <- "links" 


# filtering to get the urls of the senators
links_senador <- links %>%
  filter(links %like% "/senadores/senador/")

links_senador <- data.frame(links_senador)


# creating a new directory for the pics
setwd("~/Downloads/")
dir.create("senadores-new")
setwd("~/Downloads/senadores-new")


######################### loop

i <- 1
while(1 <= 81){
  tryCatch({
    # defining the row of each senator
    foto_webpage <- data.frame(links_senador$links[i])
    # renaming the column's name
    colnames(foto_webpage) <- "links" 
    # getting all images of html page
    # filtering the photo which we want
    html <- as.character(foto_webpage$links) %>%
      httr::GET() %>%
      xml2::read_html() %>%
      rvest::html_nodes("img") %>%
      map(xml_attrs) %>%
      map_df(~as.list(.)) %>%
      filter(src %like% "senadores/img/fotos-oficiais/") %>%
      as.data.frame(html)
    # downloading the photo
    foto_senador <- html$src
    download.file(foto_senador, basename(foto_senador), mode = "wb", header = TRUE)
    Sys.sleep(5)
  }, error = function(e) return(NULL)
  )
  i <- i + 1
}


################### renomear as fotos

# 1. criar um DF com o nome e a url do perfil
# 2. tirar acentos, colocar em lower e com traço os nomes
# 3. substituir 'id' por 'name_lower'

url <- "https://www25.senado.leg.br/web/senadores/em-exercicio/-/e/por-nome"

file <- read_html(url)
tables <- html_nodes(file, "table")
table1 <- html_table(tables[1], fill = TRUE, header = T)


# pegamos apenas a primeira coluna
table1_df <- as.data.frame(table1)[1]


# tiramos a acentuação
table1_df_sem_acentuacao <- as.data.frame(iconv(table1_df$Nome, from = "UTF-8", to = "ASCII//TRANSLIT"))
colnames(table1_df_sem_acentuacao) <- "senador_lower"


# colocamos em caixa baixa
table1_df_lower <- as.data.frame(tolower(table1_df_sem_acentuacao$senador_lower))
colnames(table1_df_lower) <- "senador_lower"


# trocamos o espaço por hifen
table_name_final <- as.data.frame(gsub(" ", "-", table1_df_lower$senador_lower))


# no DF com os links, nós mantemos apenas os IDs
id_split <- as.data.frame(gsub("https://www25.senado.leg.br/web/senadores/senador/-/perfil/", "senador", links_senador$links))


# juntamos os DF com os links e os nomes
table_dfs_final <- cbind(table_name_final, id_split)
colnames(table_dfs_final)[1] <- "name_lower"
colnames(table_dfs_final)[2] <- "id_senador"


################# renomeando os arquivos

setwd("~/Downloads/senadores-new")

changeName<- function(old_name, new_name){
  
  file.rename(paste0(old_name,'.jpg'), paste0(new_name,'.jpg'))
}


mapply(changeName, table_dfs_final$id_senador,table_dfs_final$name_lower)
