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

# verificar ERROS em CATEGORIA
erro_cat <- att_nova %>%
  filter(categoria %in% c("Infraestrutura", "Transparência"))

# verificar ERROS em TEMA
erro_tema <- att_nova %>%
  filter(tema %in% c("Mobilidade Urbana", "infraestrutura", "Administracão", "Educação e Cultura",
                     "Meio Ambiente", "Meio Ambiente e Agronegócio", "Segurança Pública"))
# calcular STATUS geral
status_geral <- att_nova %>%
  group_by(status) %>%
  summarise(qt = n()) %>%
  mutate(perc = round(qt / 1157, 3) * 100)

# calcular STATUS por TEMA
status_cat <- att_nova %>%
  mutate(tema = str_replace_all(tema, "Meio ambiente$", "Meio ambiente e agronegócio")) %>%
  group_by(status, tema) %>%
  summarise(qt = n()) %>%
  pivot_wider(names_from = status, values_from = qt) %>%
  replace(is.na(.), 0) %>%
  janitor::clean_names() %>%
  mutate(total = cumpriu + em_parte + nao_avaliada + nao_cumpriu_ainda,
         cumpriu_perc = round((cumpriu / total) * 100),
         em_parte_perc = round((em_parte / total) * 100),
         nao_avaliada_perc = round((nao_avaliada / total) * 100),
         nao_cumpriu_ainda_perc = round((nao_cumpriu_ainda / total) * 100),
         total_perc = cumpriu_perc + em_parte_perc + nao_avaliada_perc + nao_cumpriu_ainda_perc) %>%
  select(tema, cumpriu_perc, em_parte_perc, nao_avaliada_perc, nao_cumpriu_ainda_perc, total) %>%
  arrange(desc(nao_cumpriu_ainda_perc))

write.csv(status_cat, "status_cat.csv")
