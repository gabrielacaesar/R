library(tidyverse)
library(data.table)
library(abjutils)

setwd("~/Downloads/")

biometria <- fread("biometria_atual_do_dia.csv", encoding = "Latin-1", 
                   select = c("UF", "Município", "Eleitorado", "Eleitorado com biometria"))

biometria <- biometria %>%
  mutate(municipio_upper = rm_accent(toupper(`Município`))) %>%
  filter(UF != "ZZ" & UF != "Total") %>%
  mutate(municipio_upper = str_replace_all(municipio_upper, "-", " "))

cod_ibge_mun <- fread("https://raw.githubusercontent.com/kelvins/Municipios-Brasileiros/master/csv/municipios.csv")

cod_ibge_mun <- cod_ibge_mun %>%
  mutate(nome_upper = rm_accent(toupper(`nome`))) %>%
  mutate(nome_upper = str_replace_all(nome_upper, "-", " "))

cod_ibge_est <- fread("https://raw.githubusercontent.com/kelvins/Municipios-Brasileiros/master/csv/estados.csv")

cod_ibge_cruzamento <- cod_ibge_mun %>%
  left_join(cod_ibge_est, by = "codigo_uf")

bio_cruzamento <- biometria %>%
  left_join(cod_ibge_cruzamento, by = c("municipio_upper" = "nome_upper", "UF" = "uf"))

bio_cruzamento_perc <- bio_cruzamento %>%
  mutate(perc_biometria = (`Eleitorado com biometria` / `Eleitorado`) * 100)
  

write.csv(bio_cruzamento_perc, "bio_cruzamento_perc_27set2019.csv")
