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

#3. importar o nosso arquivo com o registro de todos os senadores
# fazer o download da aba 'politicos' da planilha
senadores_id <- fread("~/Downloads/plenario2019_SF - politicos.csv", 
                      drop = c("foto", "permalink"))

#4. pegar o resultado direto via HTML
## ALTERAR URL
url <- "https://www25.senado.leg.br/web/atividade/materias/-/materia/146091/votacoes#votacao_6291"

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
                            voto == "Não Compareceu" ~ "ausente",
                            voto == "Não registrou voto" ~ "ausente",
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

count(is.na(joined_data$id))

#6. informar infos da proposicao
## ALTERAR INFORMACOES ABAIXO
id_proposicao <- "98"
proposicao <- "PL1369-2019"
permalink <- "tipificacao-e-punicao-para-stalking"

#7. selecionar as colunas que queremos no nosso arquivo
votacao_final <- joined_data %>%
  rename("nome_politico" = nome,
         "partido" = partido,
         "uf" = uf,
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
