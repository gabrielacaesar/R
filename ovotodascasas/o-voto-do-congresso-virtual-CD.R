################################################################
###                                                          ###
###              O voto do Congresso - deputados             ###
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
#install.packages("tidyverse")
#install.packages("foreign")
#install.packages("rvest")
#install.packages("data.table")
#install.packages("abjutils")

#2. ler as bibliotecas
library(tidyverse)
library(foreign)
library(rvest)
library(data.table)
library(abjutils)

#3. importar o nosso arquivo com o registro de todos os deputados
# fazer o download da aba 'politicos' da planilha
deputados_id <- fread("~/Downloads/plenario2019_CD - politicos.csv")

#4-A. importar o arquivo com o resultado da votação 
# usar IMPORTHTML() no Spreadsheet, selecionar a lista 13 e separar em colunas
# opcional
# resultado_votacao <- fread("~/Downloads/votacao-nova-7abr2020.csv")

#4-B. ****ou pegar o resultado direto via HTML****
# ATENÇÃO: APENAS caso não importe o resultado via arquivo (etapa 4-A)
# caminho para achar a URL: Atividade legislativa > Agenda > (selecionar o dia) > (selecionar a sessão) > Votação > (selecionar a votação)
# indicar NOVA URL abaixo
url <- "https://www.camara.leg.br/internet/votacao/mostraVotacao.asp?ideVotacao=9408&numLegislatura=56&codCasa=4&numSessaoLegislativa=3&indTipoSessaoLegislativa=O&numSessao=6&indTipoSessao=E&tipo=partido"

resultado_url <- url %>%
  read_html() %>%
  html_table() %>%
  .[[3]] %>%
  filter(!str_detect(Parlamentar, "Total")) %>%
  mutate(partido = case_when(Parlamentar == UF ~ UF)) %>%
  fill(partido, .direction = "down") %>%
  mutate(partido = str_replace_all(partido, "Republican", "Republicanos"),
         partido = str_replace_all(partido, "Solidaried", "Solidariedade"),
         partido = str_replace_all(partido, "Podemos", "PODE")) %>%
  filter(Parlamentar != UF) %>%
  rename(nome = Parlamentar,
         uf = UF,
         voto = Voto) %>%
  mutate(nome_upper = toupper(abjutils::rm_accent(nome)),
         voto = tolower(abjutils::rm_accent(voto)))

# url doesn't contain absents deputies



