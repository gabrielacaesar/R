################################################################
###                                                          ###
###                   O voto dos deputados                   ###
###                                                          ###
###                      gabriela caesar                     ###
###                                                          ###
################################################################

################################################################
###                 Inclusão de votação nova                 ###
################################################################

################################################################
###                      Primeira etapa                      ###
################################################################

#1. instalar as bibliotecas
install.packages("rvest")
install.packages("data.table")
install.packages("xlsx")
install.packages("dplyr")
install.packages("tidyverse")

#2. ler as bibliotecas
library(rvest)
library(data.table)
library(xlsx)
library(dplyr)
library(tidyverse)

#3. importar os dados via URL
url <- "https://www.camara.gov.br/internet/votacao/mostraVotacao.asp?ideVotacao=8846&tipo=partido"

#4. extrair a tabela do HTML
file <- read_html(url)
tables <- html_nodes(file, "table")
table1 <- html_table(tables[3], fill = TRUE, header = T)

head(table1)

#5. transformar em df
table1_df <- data.frame(table1) %>%
  `colnames<-`(c("nome", "uf", "voto")) %>%
  mutate(new_column = NA)

#6. apagar linhas que não se referem a deputados
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

#7. padronizar votos

table1_df$voto <- as.character(table1_df$voto)
table1_df$voto[table1_df$voto == "Sim"] <- "sim"
table1_df$voto[table1_df$voto == "Não"] <- "nao"
table1_df$voto[table1_df$voto == "Abstenção"] <- "abstencao"
table1_df$voto[table1_df$voto == "Obstrução"] <- "obstrucao"
table1_df$voto[table1_df$voto == "Art. 17"] <- "naovotou"

#8. padronizar partidos

table1_df$partido <- as.character(table1_df$partido)
table1_df$partido[table1_df$partido == "Podemos"] <- "PODE"
table1_df$partido[table1_df$partido == "REDE"] <- "Rede"
table1_df$partido[table1_df$partido == "Solidaried"] <- "SD"

#9. criar coluna 'nome_upper', com nomes em caixa alta e sem acento

table1_df <- table1_df %>%
  mutate(nome_upper = iconv(
    str_to_upper(nome),
    from = "UTF-8",
    to = "ascii//translit")
  )


################################################################
###                       Segunda etapa                      ###
################################################################

#10. importar o arquivo com os IDs (aba 'politicos')
setwd("~/Downloads/")
id_politicos <- read.csv("~/Downloads/plenario2019_CD_politicos.csv", encoding = "UTF-8")

#11. importar o arquivo com os deputados em exercício
dep_exercicio <- read.csv("~/Downloads/deputados_17jun2019.csv", encoding = "UTF-8")


###
# ATUALIZAR
# CHECAR SE HOUVE ALGUMA MOVIMENTAÇÃO PARLAMENTAR
# https://github.com/gabrielacaesar/studyingR/blob/master/limpeza-e-normalizacao-de-dados-de-EXERCICIO-da-camara-dos-deputados.R
###


################################################################
###                       Terceira etapa                     ###
################################################################

# 11. dar um join para pegar os IDs, a UF e o partido
# OBS: este é o momento mais importante do script de atualização. 
# não adotamos a mesma nomenclatura dO Senado em todos os casos, 
# e há alguns acentos etc que dão problema.

joined_data <- id_politicos %>%
  left_join(table1_df, by = "nome_upper")

# 11. verificar no arquivo quais linhas não tiveram correspondência
# OBS: Ao abrir o 'joined_data', nós ordenamos e vemos quais são os casos.
# Abaixo, fazemos a correção no arquivo original das correções.

View(joined_data)

#12. checar nomes

A <- joined_data$nome_politico
B <- joined_data$nome

setdiff(A, B)

#13. checar partidos

C <- joined_data$partido.x
D <- joined_data$partido.y

setdiff(C, D)

#14. checar UF

G <- joined_data$uf.x
H <- joined_data$uf.y

setdiff(G, H)

#15. selecionar as colunas que queremos no nosso arquivo
votacao_final <-df_new %>%
  select(partido.x, df_new$id, df_new$deputado, xxx, df_new$uf.x, df_new$voto) %>%
  `colnames<-`(c("partido", "id_politico", "nome_upper", "nome_politico", "uf", "voto"))

#16. inserir coluna com o ID da proposição

votacao_final$id_proposicao <- "6"

#17. inserir coluna com o nome da proposição

votacao_final$proposicao <- "PEC57-2019"

#18. inserir coluna com o permalink da proposição

votacao_final$permalink <- "projeto-tutorial-para-a-inclusao"

#19. definir a ordem das colunas

votacao_final <- votacao_final %>%
  select(id_proposicao, proposicao, partido, id_politico, 
         nome_upper, nome_politico, uf, voto, permalink)

#20. fazer o download

write.csv(votacao_final, "votacao_final_pec_57_2019.csv")