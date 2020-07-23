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
install.packages("tidyverse")
install.packages("foreign")
install.packages("rvest")
install.packages("data.table")
install.packages("abjutils")

#2. ler as bibliotecas
library(tidyverse)
library(foreign)
library(rvest)
library(data.table)
library(abjutils)

#3. importar o nosso arquivo com o registro de todos os senadores
# fazer o download da aba 'politicos' da planilha
senadores_id <- fread("~/Downloads/plenario2019_SF-politicos-22jul2020.csv")

#4. pegar o resultado direto via HTML
url <- "https://www.congressonacional.leg.br/materias/medidas-provisorias/-/mpv/143101/votacoes#votacao_6152"

# variações de voto
votos <- c("Sim", "Não", "-")

# número maáximo de votantes
number <- c(1:100)

get_resultado_url <- function(x){
  url %>%
  read_html() %>%
  html_nodes("table") %>%
  .[x] %>%
  html_nodes("td") %>%
  html_text() %>%
  as.data.frame() %>%
  rename("content" = ".") %>%
  mutate(content = as.character(content)) %>%
  mutate(voto = case_when(content == "Simone Tebet" ~ NA_character_,
                          content == "Sim" ~ "Sim",
                          content == "-" ~ "-",
                          content == "Não" ~ "Não")) %>%
  fill(voto, .direction = "up") %>%
  mutate(n_order = ifelse(str_detect(str_trim(content), 
                                  paste(number, collapse = "|")), content, NA)) %>%
  fill(n_order, .direction = "down") %>%
  filter(content != voto & 
         content != n_order &
         content != "" &
         content != "Não Compareceu")
}

resultado_votacao <- map_df(2:4, get_resultado_url)

resultado_votacao <- resultado_votacao %>%
  mutate(voto = str_replace_all(voto, "Sim", "sim"),
         voto = str_replace_all(voto, "Não", "nao"),
         voto = str_replace_all(voto, "-", "ausente")) %>%
  mutate(nome_upper = toupper(rm_accent(content))) 
  
