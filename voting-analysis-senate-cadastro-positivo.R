

# Etapa 1: carregar as bibliotecas

#install.packages("data.table")
#install.packages("dplyr")
#install.packages("tidyr")
#install.packages("ggplot2")

library(data.table)
library(dplyr)
library(tidyr)
library(ggplot2)

# Etapa 2: importar o arquivo
voting <- fread("https://gist.githubusercontent.com/gabrielacaesar/021ac23cb7027cf2f80e9e2634ebadf9/raw/c24bb21e0e868ceea617e300b3385ae995846367/cadastro-positivo-votacao-senado")

# Etapa 3: conhecer o arquivo importado
summary(voting)

# Etapa 4: eliminar colunas excessivas
voting$permalink <- NULL
voting$nome_politico <- NULL
voting$id_proposicao <- NULL
voting$id_politico <- NULL

head(voting)

# Etapa 5: conhecer melhor o arquivo
unique(voting$voto)

# Etapa 6: analisar melhor a coluna
length(which(voting$voto == "sim"))

# Etapa 7: descobrir o resultado final
voting$integer <- 1

df <- voting %>%
  dplyr::group_by(voto) %>%
  summarise(nvoto = sum(integer))

df

# Etapa 8: verificar quais são os ausentes
ausentes <- voting %>%
  filter(voto == "ausente")

ausentes

# Etapa 9: agrupar os votos por UF
voting_uf <- voting %>%
  dplyr::group_by(uf, voto) %>%
  summarise(nvoto = sum(integer)) %>%
  arrange(desc(nvoto))

voting_uf

# Etapa 10: fazer um gráfico com os votos por UF
chart_uf <- ggplot(data=voting_uf, aes(x=uf,y=nvoto,fill=voto)) +
  geom_bar(stat="identity") + 
  coord_flip() +
  scale_fill_manual("voto", values = c("art17" = "#FE9A2E", "ausente" = "#F7FE2E", "nao" = "#FA5858", "sim" = "#31B404")) +
  ggtitle("Votação do cadastro positivo no Senado por UF")

chart_uf

# Etapa 11: agrupar os votos por partido
voting_party <- voting %>%
  dplyr::group_by(partido, voto) %>%
  summarise(nvoto = sum(integer)) %>%
  arrange(desc(nvoto))

voting_party

# Etapa 12: fazer dois gráficos com os votos por partido
chart_party <- ggplot(data=voting_party, aes(x=reorder(partido, nvoto), y=nvoto,fill=voto)) +
  geom_bar(stat="identity") + 
  theme(legend.position="bottom") +
  coord_flip() +
  scale_fill_manual("voto", values = c("art17" = "#FE9A2E", "ausente" = "#F7FE2E", "nao" = "#FA5858", "sim" = "#31B404")) +
  ggtitle("Votação do cadastro positivo no Senado por partido")

chart_party

chart_party_2 <- ggplot(data=voting_party, aes(x=voto,y=nvoto)) +
  geom_col(aes(fill = voto)) +
  theme(axis.text.x = element_blank()) +
  theme(axis.title.x = element_blank()) +
  theme(axis.text.y = element_blank()) +
  theme(axis.title.y = element_blank()) +
  facet_wrap(~ partido, ncol = 4) +
  scale_fill_manual("voto", values = c("art17" = "#FE9A2E", "ausente" = "#F7FE2E", "nao" = "#FA5858", "sim" = "#31B404")) +
  ggtitle("Votação do cadastro positivo no Senado por partido")

chart_party_2

# Etapa 13: calcular o número de senadores que votaram "sim"
voting_yes <- voting %>%
  filter(voto == "sim") %>%
  dplyr::group_by(partido, voto) %>%
  summarise(nvoto = sum(integer))

sum(voting_yes$nvoto)
voting_yes

# Etapa 14: calcular o número de senadores por partido
voting_perc <- voting %>%
  dplyr::group_by(partido) %>%
  summarise(nvoto = sum(integer))

sum(voting_perc$nvoto)

voting_perc

# Etapa 15: unir dois dataframes
voting_yes_party <- merge(voting_yes, voting_perc, by = "partido")

colnames(voting_yes_party) <- c("partido", "voto", "nvoto", "bancada")

voting_yes_party$perc_sim <- (voting_yes_party$nvoto/voting_yes_party$bancada) * 100

# Etapa 16: ordenar do maior para o menor
voting_yes_party <- voting_yes_party[order(-voting_yes_party$perc_sim),]

voting_yes_party

# Etapa 17: fazer um gráfico com a adesão de partidos
chart_yes_party <- ggplot(voting_yes_party, aes(x = reorder(partido, perc_sim), y = perc_sim)) +
  geom_bar(stat = "identity") +
  coord_flip() +
  ggtitle("Adesão por partido ao 'sim' no cadastro positivo no Senado")

chart_yes_party

chart_yes_party_2 <- ggplot(voting_yes_party, aes(nvoto, perc_sim, 
                                                  size = bancada)) +
  xlab("Número de votos ao 'sim'") +
  ylab("Percentual de adesão ao 'sim'") +
  geom_point() +
  geom_text(aes(label = partido)) +
  coord_flip() +
  ggtitle("Adesão por partido ao 'sim' no cadastro positivo no Senado")

chart_yes_party_2

chart_yes_party_3 <- ggplot(voting_yes_party, aes(nvoto, perc_sim, 
                                                  size = bancada)) +
  xlab("Número de votos ao 'sim'") +
  ylab("Percentual de adesão ao 'sim'") +
  geom_point() +
  geom_label(aes(label = partido)) +
  coord_flip() +
  ggtitle("Adesão por partido ao 'sim' no cadastro positivo no Senado")

chart_yes_party_3



