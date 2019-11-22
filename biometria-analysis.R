
library(data.table)
library(tidyverse)
library(abjutils)

# lista de municípios que já completaram a biometria e onde houve títulos cancelados e regularizados
consolidado_LAI <- fread("C:/Users/acaesar/Downloads/biometria-tse-21nov2019-consolidado-LAI.csv", encoding = "UTF-8")

# lista município e os respectivos dados de eleitorado e eleitorado com biometria
site_TSE <- read.csv("C:/Users/acaesar/Downloads/site-tse-2.csv", sep = ";", encoding = "Latin-1", dec = ".", colClasses=c('character'))

# lista de municípios em que a biometria será obrigatória
bio_list <- fread("C:/Users/acaesar/Downloads/bio-lista-lista-municipios-4.csv", encoding="UTF-8")


bio_list <- bio_list %>%
  mutate(MUNICIPIO_UPPER = toupper(rm_accent(Municipio))) %>%
  mutate(obrigatoria = "sim")

consolidado_LAI <- consolidado_LAI %>%
  mutate(MUNICIPIO_UPPER = toupper(rm_accent(MUNICIPIO)))  

site_TSE <- site_TSE %>%
  mutate(MUNICIPIO_UPPER = toupper(rm_accent(Município))) %>%
  filter(UF != "ZZ" & UF != "Total")

# cruzamento de lista de cidades com biometria obrigatória e dados do site do TSE
merged_UF_faltante <- site_TSE %>%
  left_join(bio_list, by = c("MUNICIPIO_UPPER", "UF")) %>%
  arrange(MUNICIPIO_UPPER, UF) %>%
  filter(obrigatoria == "sim") %>%
  select("UF", "MUNICIPIO_UPPER", "Situação.do.município", "Eleitorado", "Eleitorado.com.biometria", "X.", "obrigatoria")
  
# UFs que terão a biometria obrigatória em todas as UFs
uf_completo <- c("TO",
                 "PI",
                 "SE",
                 "RR",
                 "GO",
                 "PB",
                 "AC",
                 "AP",
                 "DF",
                 "AL",
                 "RN",
                 "PR",
                 "RO",
                 "PA",
                 "AM",
                 "MA",
                 "CE",
                 "BA")

uf_completo <- uf_completo %>%
  as.data.frame() %>%
  `colnames<-`("UF") %>%
  mutate(obrigatoria = "sim")

merged_UF_completo <- site_TSE %>%
  left_join(uf_completo, by = ("UF")) %>%
  filter(obrigatoria == "sim") %>%
  select("UF", "MUNICIPIO_UPPER", "Situação.do.município", "Eleitorado", "Eleitorado.com.biometria", "X.", "obrigatoria")


# arquivo com todos os municípios em que a biometria será obrigatória
# e o estado da biometria em cada lugar
merged_uf <- rbind(merged_UF_completo, merged_UF_faltante)


write.csv(merged_uf, "merged_uf.csv")
