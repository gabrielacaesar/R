# carregar as bibliotecas

library(tidyverse)
library(foreign)
library(data.table)
library(DescTools)


# inserir link de votação

url <- "https://www.camara.leg.br/internet/votacao/mostraVotacao.asp?ideVotacao=8974&numLegislatura=56&codCasa=1&numSessaoLegislativa=1&indTipoSessaoLegislativa=O&numSessao=191&indTipoSessao=E&tipo=partido"


################################################################
###                  voto de cada deputado                   ###
################################################################

# pegar tabela de voto

table_voto <- read_html(url) %>%
  html_nodes("table") %>%
  html_table(fill = TRUE, header = T) %>%
  .[[3]]

table1_df <- data.frame(table_voto) %>%
  `colnames<-`(c("nome", "uf", "voto")) %>%
  mutate(new_column = NA)

# corrigir falha da formatação da tabela

idx <- grep("Total.*: \\d+", table1_df$nome)

for (i in seq_along(idx)){
  n <- as.numeric(sub("^.*: ", "", table1_df$nome[idx[i]]))
  partido <- sub("Total ", "", table1_df$nome[idx[i]])
  partido <- sub(": .*", "", partido)
  table1_df$new_column[(idx[i] - n):(idx[i] - 1)] <- partido
}

table1_df <- table1_df[-grep("Total .*:.*", table1_df$nome), ]
table1_df <- table1_df[-which(table1_df$nome == table1_df$uf), ]
colnames(table1_df)[4] <- "partido"

# padronizar votos

table1_df$voto[table1_df$voto == "Sim"] <- "sim"
table1_df$voto[table1_df$voto == "Não"] <- "nao"
table1_df$voto[table1_df$voto == "Abstenção"] <- "abstencao"
table1_df$voto[table1_df$voto == "Obstrução"] <- "obstrucao"
table1_df$voto[table1_df$voto == "Art. 17"] <- "naovotou"

# padronizar partidos

table1_df$partido <- as.character(table1_df$partido)
table1_df$partido[table1_df$partido == "Podemos"] <- "PODE"
table1_df$partido[table1_df$partido == "REDE"] <- "Rede"
table1_df$partido[table1_df$partido == "Solidaried"] <- "SD"
table1_df$partido[table1_df$partido == "NOVO"] <- "Novo"
table1_df$partido[table1_df$partido == "S.Part."] <- "S/Partido"
table1_df$partido[table1_df$partido == "PPS"] <- "Cidadania"
table1_df$partido[table1_df$partido == "CIDADANIA"] <- "Cidadania"
table1_df$partido[table1_df$partido == "PR"] <- "PL"

# padronizar nome que vem com erros

table1_df$nome[table1_df$nome == "Chico D`Angelo"] <- "Chico D'Angelo"
table1_df$nome[table1_df$nome == "Flávio Nogueira"] <- "Flavio Nogueira"
table1_df$nome[table1_df$nome == "Jhc"] <- "JHC"



################################################################
###               orientação de partidos e blocos            ###
################################################################

table_orientacao <- read_html(url) %>%
  html_nodes("table") %>%
  html_table(fill = TRUE, header = F) %>%
  .[[2]] %>%
  `colnames<-`(c("partido", "orientacao"))

orientacao_partidos_n <- table_orientacao %>%
  distinct() %>%
  mutate(partido = str_replace_all(partido, ":", ""),
        partido = str_replace_all(partido, "Repr.", ""),
        partido = str_replace_all(partido, "PpMdbPtb", "PP - MDB - PTB"),
        partido = str_replace_all(partido, "PslPpPsd...", "PSL - PP - PSD"),
        partido = str_replace_all(partido, "PdtSdPode...", "PDT - SD - PODE"),
        partido = str_replace_all(partido, "PdtPodePros...", "PDT - PODE - PROS"),
        partido = str_replace_all(partido, "PdtPros...", "PDT - PROS"),
        partido = str_replace_all(partido, "PpPrPsd", "PP - PL - PSD"),
        partido = str_replace_all(partido, "PpMdbPtb", "PP - MDB - PTB"),
        partido = str_replace_all(partido, "PdtAvante", "PDT - Avante"),
        partido = str_replace_all(partido, "GOV.", "Governo"),
        partido = str_replace_all(partido, "CIDADANIA", "Cidadania"),
        partido = str_replace_all(partido, "NOVO", "Novo"),
        partido = str_replace_all(partido, "Solidaried", "SD"),
        partido = str_replace_all(partido, "Podemos", "PODE"),
        partido = str_replace_all(partido, "REDE", "Rede")) %>%
  mutate(orientacao = str_replace_all(orientacao, "Sim", "sim"),
        orientacao = str_replace_all(orientacao, "Não", "nao"),
        orientacao = str_replace_all(orientacao, "Liberado", "liberado")) %>%
  arrange(partido)

orientacao_partidos_tidy <- orientacao_partidos_n  %>%
  filter(str_detect(partido, " - ")) %>%
  separate(partido, c("partido1", "partido2", "partido3"), " - ")

partido1 <- orientacao_partidos_tidy %>%
  select(partido1, orientacao) %>%
  `colnames<-`(c("partido", "orientacao"))

partido2 <- orientacao_partidos_tidy %>%
  select(partido2, orientacao) %>%
  `colnames<-`(c("partido", "orientacao"))

partido3 <- orientacao_partidos_tidy %>%
  select(partido3, orientacao) %>%
  `colnames<-`(c("partido", "orientacao"))

partido_new <- rbind(partido1, partido2, partido3)

df_final <- orientacao_partidos_n %>%
  filter(!str_detect(partido, " - ")) %>%
  rbind(partido_new) %>%
  arrange(partido)

################################################################
###               joining and comparing columns             ###
################################################################

joined_data <- table1_df %>%
  left_join(df_final, by = "partido") %>%
  mutate(orientacao = replace_na(orientacao, "nao-orientou")) 

# por partido

joined_data_2 <- joined_data %>%
  filter(orientacao != "liberado" & orientacao != "nao-orientou") %>%
  mutate(check = ifelse(voto == orientacao, "match", "not_match")) %>%
  group_by(partido, check) %>%
  summarise(int = n()) %>%
  spread(check, int) %>%
  mutate(match = as.numeric(replace_na(match, "0"))) %>%
  mutate(not_match = as.numeric(replace_na(not_match, "0"))) %>%
  mutate(total = (match + not_match)) %>%
  mutate(match_perc = (match / total) * 100) %>%
  mutate(not_match_perc = (not_match / total) * 100) %>%
  arrange(desc(not_match_perc))

View(joined_data_2)

write.csv(joined_data_2, "joined_data_2.csv")

# por nome

joined_data_3 <- joined_data %>%
  mutate(check = ifelse(voto == orientacao, "match", "not_match")) %>%
  arrange(desc(check))

View(joined_data_3)

write.csv(joined_data_3, "joined_data_3.csv")

