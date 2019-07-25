# carregar as bibliotecas
library(tidyverse)
library(foreign)
library(data.table)

# definir diretório
setwd("~/Downloads/votacoes-nominais")

orientacao_partidos <- fread("orientacao_partidos.csv", encoding = "UTF-8", header = T)
votos_deputados <- fread("votos_deputados.csv", encoding = "UTF-8", header = T)

# delete index column
orientacao_partidos$V1 <- NULL
votos_deputados$V1 <- NULL

# padronizar partidos
votos_deputados$partido[votos_deputados$partido == "Podemos"] <- "PODE"
votos_deputados$partido[votos_deputados$partido == "REDE"] <- "Rede"
votos_deputados$partido[votos_deputados$partido == "Solidaried"] <- "SD"
votos_deputados$partido[votos_deputados$partido == "NOVO"] <- "Novo"
votos_deputados$partido[votos_deputados$partido == "S.Part."] <- "S/Partido"

# padronizar nome que vem com erros
votos_deputados$nome[votos_deputados$nome == "Chico D`Angelo"] <- "Chico D'Angelo"
votos_deputados$nome[votos_deputados$nome == "Flávio Nogueira"] <- "Flavio Nogueira"
votos_deputados$nome[votos_deputados$nome == "Jhc"] <- "JHC"

# agrupar 
votos_deputados_n <- votos_deputados %>%
  group_by(nome, partido, voto, id) %>%
  summarise() 

# corrigindo os dados de orientação por partido
orientacao_partidos_n <- orientacao_partidos %>%
  distinct() %>%
  mutate(partido = str_replace_all(partido, ":", "")) %>%
  mutate(partido = str_replace_all(partido, "Repr.", "")) %>%
  mutate(partido = str_replace_all(partido, "PslPpPsd...", "PSL - PP - PSD")) %>%
  mutate(partido = str_replace_all(partido, "PdtSdPode...", "PDT - SD - PODE")) %>%
  mutate(partido = str_replace_all(partido, "PdtPodePros...", "PDT - PODE - PROS")) %>%
  mutate(partido = str_replace_all(partido, "PdtPros...", "PDT - PROS")) %>%
  mutate(partido = str_replace_all(partido, "PpPrPsd", "PP - PR - PSD")) %>%
  mutate(partido = str_replace_all(partido, "PpMdbPtb", "PP - MDB - PTB")) %>%
  mutate(partido = str_replace_all(partido, "PdtAvante", "PDT - Avante")) %>%
  mutate(partido = str_replace_all(partido, "GOV.", "Governo")) %>%
  mutate(partido = str_replace_all(partido, "CIDADANIA", "Cidadania")) %>%
  mutate(partido = str_replace_all(partido, "NOVO", "Novo")) %>%
  mutate(partido = str_replace_all(partido, "Solidaried", "SD")) %>%
  mutate(partido = str_replace_all(partido, "Podemos", "PODE")) %>%
  arrange(id)

# selecionando apenas linhas que precisam de alteração
orientacao_partidos_tidy <- orientacao_partidos_n  %>%
  filter(partido %like% " - ") %>%
  separate(partido, c("partido1", "partido2", "partido3"), " - ")

# separando por colunas e considerando partido1
partido1 <- orientacao_partidos_tidy %>%
  select(partido1, orientacao, id) %>%
  `colnames<-`(c("partido", "orientacao", "id"))

# separando por colunas e considerando partido2
partido2 <- orientacao_partidos_tidy %>%
  select(partido2, orientacao, id) %>%
  `colnames<-`(c("partido", "orientacao", "id"))

# separando por colunas e considerando partido3
partido3 <- orientacao_partidos_tidy %>%
  select(partido3, orientacao, id) %>%
  `colnames<-`(c("partido", "orientacao", "id"))

# criando df com partidos corrigidos
partido_new <- rbind(partido1, partido2, partido3) %>%
  arrange(id)

# unindo do df original com os novos partidos
df_final <- orientacao_partidos_n %>%
  filter(!partido %like% " - ") %>%
  rbind(partido_new) %>%
  arrange(id)

###### 
# dar merge considerando partido e id
# df com voto e df com orientação
######

joined_data <- votos_deputados_n %>%
  left_join(df_final, by.x = c("partido", "id"),
            by.y = c("partido", "id")) %>%
  mutate(orientacao = replace_na(orientacao, "nao-orientou"))

# comparar colunas voto e orientacao

joined_data_2 <- joined_data %>%
  filter(!orientacao == "nao-orientou" & !orientacao == "Liberado") %>%
  mutate(check = ifelse(voto == orientacao, "match", "not_match"))

# agrupar por deputado e contabilizar match e not-match

joined_data_3 <- joined_data_2 %>%
  group_by(nome, check) %>%
  summarise(int = n()) %>%
  spread(check, int) %>%
  mutate(total = match + not_match) %>%
  mutate(not_match = replace_na(not_match, 0)) %>%
  mutate(total = replace_na(total, 0)) %>%
  mutate(match_perc = (match / total) * 100) %>%
  mutate(not_match_perc = (not_match / total) * 100) %>%
  arrange(desc(not_match_perc))

# agrupar por partido e contabilizar match e not_match

joined_data_4 <- joined_data_2 %>%
  group_by(partido, check) %>%
  summarise(int = n()) %>%
  spread(check, int) %>%
  mutate(not_match = replace_na(not_match, 0)) %>%
  mutate(total = match + not_match) %>%
  mutate(total = replace_na(total, 0)) %>%
  mutate(match_perc = (match / total) * 100) %>%
  mutate(not_match_perc = (not_match / total) * 100) %>%
  arrange(desc(not_match_perc))
