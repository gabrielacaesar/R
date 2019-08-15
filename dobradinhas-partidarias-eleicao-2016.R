library(tidyverse)
library(rvest)
library(downloader)
library(data.table)

setwd("~/Downloads/consulta_cand_2016_15ago2019")

consulta_cand_BR <- fread("consulta_cand_2016_BRASIL.csv")

consulta_prefeito <- consulta_cand_BR %>%
  filter(DS_CARGO == "PREFEITO") %>%
  select(SG_UF, SG_UE, NM_UE, NM_CANDIDATO,
         NM_URNA_CANDIDATO, SG_PARTIDO, DS_SIT_TOT_TURNO,
         DS_COMPOSICAO_COLIGACAO) %>%
  rename("NM_PREFEITO" =  NM_CANDIDATO,
         "NM_URNA_PREFEITO" = NM_URNA_CANDIDATO,
         "SG_PARTIDO_PREFEITO" = SG_PARTIDO,
         "DS_SIT_TOT_TURNO_PREFEITO" = DS_SIT_TOT_TURNO)

consulta_vice_prefeito <- consulta_cand_BR %>%
  filter(DS_CARGO == "VICE-PREFEITO") %>%
  select(SG_UF, SG_UE, NM_UE, NM_CANDIDATO,
         NM_URNA_CANDIDATO, SG_PARTIDO, DS_SIT_TOT_TURNO,
         DS_COMPOSICAO_COLIGACAO) %>%
  rename("NM_VICE_PREFEITO" =  NM_CANDIDATO,
         "NM_URNA_VICE_PREFEITO" = NM_URNA_CANDIDATO,
         "SG_PARTIDO_VICE_PREFEITO" = SG_PARTIDO,
         "DS_SIT_TOT_TURNO_VICE_PREFEITO" = DS_SIT_TOT_TURNO)


consulta_merged <- consulta_prefeito %>%
  left_join(consulta_vice_prefeito, 
            by = c("SG_UF", "NM_UE", "DS_COMPOSICAO_COLIGACAO"))

consulta_merged_partido <- consulta_merged %>%
  select(SG_PARTIDO_PREFEITO, SG_PARTIDO_VICE_PREFEITO) %>%
  unite(c(SG_PARTIDO_PREFEITO, SG_PARTIDO_VICE_PREFEITO), col = "chapa", sep = " - ") %>%
  group_by(chapa) %>%
  summarise(int = n())

# as chapas 'puro sangue' são as mais frequentes
# PT-PSL 15 vezes e PSL-PT 3 vezes