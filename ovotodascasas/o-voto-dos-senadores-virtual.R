################################################################
###                                                          ###
###                   O voto dos senadores                   ###
###                                                          ###
###                      gabriela caesar                     ###
###                                                          ###
################################################################

################################################################
###                 Inclusão de votação nova                 ###
################################################################

################################################################
###                     Votação virtual                      ###
################################################################

#1. instalar as bibliotecas
# install.packages("tidyverse")
# install.packages("rvest")
# install.packages("data.table")

#2. ler as bibliotecas
library(tidyverse)
library(rvest)
library(data.table)
library(googledrive)
library(readxl)

#3. importar o nosso arquivo com o registro de todos os senadores
# fazer o download da aba 'politicos' da planilha
dir.create(paste0("dados_votacao_", Sys.Date()))
setwd(paste0("dados_votacao_", Sys.Date()))

drive_auth(email = "gabriela.caesar.g1@gmail.com")
drive_download(file = as_id("1D57BJfGXxwizxK1yD1qbzx8CH6v7q8jSltK9puaw2_Q"), type = "xlsx")
arquivo <- list.files()
senadores_id <- read_xlsx(arquivo, sheet = 'politicos')

senadores_id <- senadores_id %>%
                select(!c("foto", "permalink"))

#4. pegar o resultado direto via HTML
## ALTERAR URL
url <- "https://www25.senado.leg.br/web/atividade/materias/-/materia/146095/votacoes#votacao_6372"

get_resultado_url <- function(i){
  url %>%
    read_html() %>%
    html_table() %>%
    .[i] %>%
    as.data.frame() %>%
    janitor::clean_names() %>%
    mutate(voto = ifelse(str_detect(voto, "-"), obs, voto),
           nome_upper = toupper(abjutils::rm_accent(parlamentar))) %>%
    rename(n_order = x, nome = parlamentar) %>%
    select(n_order, nome, nome_upper, voto) %>%
    mutate(voto = case_when(voto == "Sim" ~ "sim",
                            voto == "Presente (art. 40 - em Missão)" ~ "ausente",
                            voto == "Não Compareceu" ~ "ausente",
                            voto == "Não registrou voto" ~ "ausente",
                            voto == "art. 43, II - Licença particular" ~ "ausente",
                            voto == "art. 13, caput - Atividade parlamentar" ~ "ausente",
                            voto == "art. 43, I - Licença saúde" ~ "ausente",
                            voto == "Presidente (art. 51 RISF)" ~ "naovotou",
                            voto == "Não" ~ "nao",
                            voto == "Abstenção" ~ "abstencao"))
}

resultado_votacao <- map_df(2:4, get_resultado_url)

#5. cruzar planilhas
joined_data <- resultado_votacao %>%
  left_join(senadores_id, by = "nome_upper") %>%
  arrange(desc(id))

is.na(joined_data$id)

# checar placar
joined_data %>%
  group_by(voto) %>%
  summarise(n())

#6. informar infos da proposicao
## ALTERAR INFORMACOES ABAIXO
id_proposicao <- "105"
proposicao <- "PL5613-2020"
permalink <- "combate-a-violencia-politica-contra-mulheres"

#7. selecionar as colunas que queremos no nosso arquivo
votacao_final <- joined_data %>%
  rename("nome_politico" = `nome.y`,
         "id_politico" = id) %>%
  mutate(id_proposicao = id_proposicao,
         proposicao = proposicao,
         permalink = permalink) %>%
  select("id_proposicao", "proposicao", "partido", "id_politico", 
         "nome_upper", "nome_politico", "uf", "voto", "permalink") %>% 
  arrange(nome_upper)

#8. fazer o download
dir.create(paste0("~/Downloads/votacao_final_", proposicao, Sys.Date()))
setwd(paste0("~/Downloads/votacao_final_", proposicao, Sys.Date()))
write.csv(votacao_final, paste0("votacao_final_", proposicao, Sys.Date(), ".csv"))
