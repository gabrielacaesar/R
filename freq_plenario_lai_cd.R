
# carregar as bibliotecas
library(tidyverse)
library(foreign)
library(data.table)

# definir diretório
setwd("~/Downloads/votacoes-nominais/")

# ler arquivo
freq_cd_lai <- fread("Presenca_Plenario_CD_Fev2019aJul2019-26jul2019.csv")

freq_cd_lai_n <- freq_cd_lai %>%
  `colnames<-`(c("data_inicio", "hora_inicio", "data_fim", "hora_fim", "n_sessao", "tipo_sessao", 
                 "num_Leg", "nome", "partido", "uf", "frequencia", "justificativa")) %>%
  separate(data_inicio, c("dia", "mes", "ano"), sep = "/", remove = F) %>%
  unite(data_inicio_new, c("ano", "mes", "dia"), sep = "-")

freq_cd_lai_n$dia_semana <- weekdays(as.Date(freq_cd_lai_n$data_inicio_new))
  


freq_sessoes <- freq_cd_lai_n %>%
  group_by(nome, partido, tipo_sessao, frequencia) %>%
  summarise(int = n()) %>%
  spread(frequencia, int) %>%
  `colnames<-`(c("nome", "partido", "ausencia", "presenca")) %>%
  mutate(ausencia = replace_na(ausencia, 0)) %>%
  mutate(presenca = replace_na(presenca, 0)) %>%
  mutate(total = ausencia + presenca) %>%
  mutate(ausencia_perc = (ausencia / total) * 100) %>%
  mutate(presenca_perc = (presenca / total) * 100)

# check EXT e ORD
# calendário de sessões nominais (?)
# check DELIB e NAO DELIB
# comparar com dados SCRAPER

