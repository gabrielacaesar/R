# leitura de pacotes
library(tidyverse)
library(pdftools)
library(rvest)

# leitura de PDF
pdf_votacao <- pdftools::pdf_text("5ª votação.pdf")

### TABLE ONE

tabela1 <- pdf_votacao[1] %>%
  as.data.frame() 
  
tabela1 <- gsub('(.*)Voto\n','', tabela1)

tabela1_tidy <- tabela1 %>%
  as.data.frame() %>%
  dplyr::rename(dados = ".") %>%
  separate_rows(dados, sep = "\n") %>%
  mutate(voto = str_sub(dados, start = -3, end = -1),
         partido = str_trim(str_sub(dados, start = 1, end = 9)),
         uf = str_sub(dados, start = 27, end = 28),
         nome = str_trim(str_sub(dados, start = 33, end = 50))) %>%
  select(-dados) %>%
  filter(nome != "")

### TABLE TWO
tabela2 <- pdf_votacao[2] %>%
  as.data.frame() 

tabela2 <- gsub('(.*)Data Sessão','', tabela2)

tabela2_tidy <- tabela2 %>%
  as.data.frame() %>%
  dplyr::rename(dados = ".") %>%
  separate_rows(dados, sep = "\n") %>%
  filter(!str_detect(dados, "2021")) %>%
  mutate(voto = str_sub(dados, start = -3, end = -1),
         partido = str_trim(str_sub(dados, start = 1, end = 9)),
         uf = str_sub(dados, start = 27, end = 28),
         nome = str_trim(str_sub(dados, start = 32, end = 50))) %>%
  select(-dados) %>%
  filter(nome != "")

tabela2_tidy

### TABLE THREE
tabela3 <- pdf_votacao[3] %>%
  as.data.frame() 

tabela3 <- gsub('(.*)Data Sessão','', tabela3)

tabela3_tidy <- tabela3 %>%
  as.data.frame() %>%
  dplyr::rename(dados = ".") %>%
  separate_rows(dados, sep = "\n") %>%
  filter(!str_detect(dados, "2021")) %>%
  mutate(presidente = ifelse(str_detect(dados, "Presidente: "), TRUE, FALSE)) %>%
  mutate(voto = str_sub(dados, start = -3, end = -1),
         partido = str_trim(str_sub(dados, start = 1, end = 9)),
         uf = str_sub(dados, start = 29, end = 30),
         nome = str_trim(str_sub(dados, start = 32, end = 60))) %>%
  mutate(dados = str_trim(str_remove_all(dados, "Presidente:")),
         nome = ifelse(presidente == TRUE, dados, nome),
         voto = ifelse(presidente == TRUE, "naovotou", voto),
         partido = ifelse(presidente == TRUE, NA, partido),
         uf = ifelse(presidente == TRUE, NA, uf)) %>%
  select(-dados, -presidente) %>%
  filter(row_number() <= n()-2)

tabela3_tidy

## BIND ROWS

tabela_tidy <- bind_rows(tabela1_tidy, tabela2_tidy, tabela3_tidy)

## correcoes partido, voto e nome
tabela_tidy <- tabela_tidy %>%
  mutate(partido = str_replace_all(partido, "Podemos", "PODE"),
         partido = str_replace_all(partido, "PROGRES", "PP"),
         partido = str_replace_all(partido, "REDE", "Rede"),
         partido = str_replace_all(partido, "Republica", "Republicanos"),
         voto = str_replace_all(voto, "SIM", "sim"),
         voto = str_replace_all(voto, "NÃO", "nao"),
         nome_upper = abjutils::rm_accent(toupper(nome)))

tabela_tidy

## coleta de senadores em exercicio

url <- "https://www25.senado.leg.br/web/senadores/em-exercicio/-/e/por-nome"

senadores_exercicio <- url %>%
  read_html() %>%
  html_table() %>%
  as.data.frame() %>%
  janitor::clean_names() %>%
  select(nome, partido, uf) %>%
  mutate(nome_upper = abjutils::rm_accent(toupper(nome)),
         partido = str_replace_all(partido, "PODEMOS", "PODE"),
         partido = str_replace_all(partido, "CIDADANIA", "Cidadania"),
         partido = str_replace_all(partido, "REDE", "Rede"),
         partido = str_replace_all(partido, "REPUBLICANOS", "Republicanos"))
  
# VERIFICAR AUSENTES NA VOTACAO

total_votacao <- senadores_exercicio %>%
  left_join(tabela_tidy, by = "nome_upper") %>%
  mutate(voto = str_replace_na(voto, "ausente"))

is.na(total_votacao$voto)

# cruzamento com id 
# insercao de infos de proposicao


