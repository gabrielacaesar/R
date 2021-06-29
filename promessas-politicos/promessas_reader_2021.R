# leitura de pacotes
library(tidyverse)
library(readxl)
library(googledrive)

# pasta para LISTA DE PLANILHAS - PROMESSAS
dir.create(paste0("planilhas_promessas_", Sys.Date()))
setwd(paste0("planilhas_promessas_", Sys.Date()))
getwd()

# download de LISTA DE PLANILHAS - PROMESSAS
drive_auth(email = "gabriela.caesar.g1@gmail.com")
drive_download(file = as_id("1VTMW_lAkSr7_njX3-hnWvd-FdvP4j-0QbVzzE4W30IU"), type = "csv")

# leitura de LISTA DE PLANILHAS - PROMESSAS
## ABA - GOVERNADORES
arquivo <- list.files()
lista_planilhas <- read_csv(arquivo)

# tratamento LISTA DE PLANILHAS - PROMESSAS
lista_planilhas_tidy <- lista_planilhas %>%
  janitor::clean_names() %>%
  select(1:3) %>%
  mutate(link = basename(link))

# pasta POR UF
dir.create(paste0("por_uf"))
setwd(paste0("por_uf"))
getwd()

# download POR UF
for(i in 1:27){
drive_download(file = as_id(lista_planilhas_tidy$link[i]), type = "xlsx")
}

# read POR UF
att_nova <- list.files(pattern = "*xlsx") %>%
  set_names() %>%
  map_df(read_xlsx, 
         sheet = 1,
         col_names = TRUE,
         .id = "arquivo")

# verificar ERROS em STATUS
erro_status <- att_nova %>%
  filter(!status %in% c("cumpriu", "nao-cumpriu-ainda", "em-parte", "nao-avaliada"))

