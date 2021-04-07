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
library(readxl)

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
url <- "https://www.camara.leg.br/internet/votacao/mostraVotacao.asp?ideVotacao=9442&numLegislatura=56&codCasa=1&numSessaoLegislativa=3&indTipoSessaoLegislativa=O&numSessao=32&indTipoSessao=E&tipo=partido"

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
         voto = tolower(abjutils::rm_accent(voto))) %>%
  mutate(nome_upper = str_replace_all(nome_upper, "BOZZELLA", "JUNIOR BOZZELLA"),
         nome_upper = str_replace_all(nome_upper, "GLAUSTIN DA FOKUS", "GLAUSTIN FOKUS"),
         nome_upper = str_replace_all(nome_upper, "JOSE AIRTON FELIX CIRILO", "JOSE AIRTON CIRILO"),
         nome_upper = str_replace_all(nome_upper, "JUNIO AMARAL", "CABO JUNIO AMARAL"),
         nome_upper = str_replace_all(nome_upper, "OTTACI NASCIMENTO", "OTACI NASCIMENTO"),
         nome_upper = str_replace_all(nome_upper, "PASTOR GIL", "PASTOR GILDENEMYR"),
         nome_upper = str_replace_all(nome_upper, "ROMAN", "EVANDRO ROMAN"),
         nome_upper = str_replace_all(nome_upper, "VITOR HUGO", "MAJOR VITOR HUGO"))

# url doesn't contain absents deputies
# link - exercico https://www.camara.leg.br/internet/deputado/deputado.xls
dep_exercicio <- read_xls("~/Downloads/deputado.xls")

merged <- dep_exercicio %>%
  janitor::clean_names() %>%
  mutate(nome_upper = abjutils::rm_accent(toupper(nome_parlamentar))) %>%
  mutate(nome_upper = str_replace_all(nome_upper, "BOZZELLA", "JUNIOR BOZZELLA"),
         nome_upper = str_replace_all(nome_upper, "GLAUSTIN DA FOKUS", "GLAUSTIN FOKUS"),
         nome_upper = str_replace_all(nome_upper, "JOSE AIRTON FELIX CIRILO", "JOSE AIRTON CIRILO"),
         nome_upper = str_replace_all(nome_upper, "JUNIO AMARAL", "CABO JUNIO AMARAL"),
         nome_upper = str_replace_all(nome_upper, "OTTACI NASCIMENTO", "OTACI NASCIMENTO"),
         nome_upper = str_replace_all(nome_upper, "PASTOR GIL", "PASTOR GILDENEMYR"),
         nome_upper = str_replace_all(nome_upper, "ROMAN", "EVANDRO ROMAN"),
         nome_upper = str_replace_all(nome_upper, "VITOR HUGO", "MAJOR VITOR HUGO")) %>%
  select(nome_upper, partido, uf) %>%
  left_join(resultado_url, by = "nome_upper") %>%  
  left_join(deputados_id, by = "nome_upper") %>%
  rename(id_politico = id,
         nome_politico = `nome.y`) %>%
  mutate(voto = str_replace_na(voto, "ausente"),
         voto = str_replace_all(voto, "art. 17", "naovotou"),
         id_proposicao = "71",
         proposicao = "PL948-2021",
         permalink = "compra-de-vacinas-da-covid-19-por-empresas") %>%
  select(id_proposicao, proposicao, partido, id_politico, 
         nome_upper, nome_politico, uf, voto, permalink)

write.csv(merged, "merged_2.csv")
