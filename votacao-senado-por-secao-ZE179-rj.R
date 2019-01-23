library(data.table)
library(dplyr)

setwd("~/Downloads")

votacaoRJ  <- fread("votacao_secao_2018_RJ_23jan2019.csv")

head(votacaoRJ)

votacaoRJ_milicia <- votacaoRJ %>%
  filter(NR_ZONA == "179") %>%
  filter(DS_CARGO == "SENADOR") %>%
  group_by(NR_SECAO) %>%
  summarise(total_votos = sum(QT_VOTOS))


filtered_df <- votacaoRJ %>%
  filter(NR_ZONA == "179") %>%
  filter(DS_CARGO == "SENADOR")


df_new <- merge(x=filtered_df, y=votacaoRJ_milicia)

df_new$perc <- (df_new$QT_VOTOS / df_new$total_votos) * 100

write.csv(df_new, "df_new.csv", row.names = T, quote = F)
