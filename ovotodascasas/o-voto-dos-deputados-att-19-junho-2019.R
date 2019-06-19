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
###                 Coleta do HTML da Câmara                 ###
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
# ATENÇÃO: confira abaixo a URL a ser inserida
# ATENÇÃO: o final da URL deve ser 'tipo=partido'

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
table1_df$partido[table1_df$partido == "NOVO"] <- "Novo"
table1_df$partido[table1_df$partido == "S.Part."] <- "S/Partido"

#9. padronizar nome que vem com erros

table1_df$nome[table1_df$nome == "Chico D`Angelo"] <- "Chico D'Angelo"
table1_df$nome[table1_df$nome == "Flávio Nogueira"] <- "Flavio Nogueira"
table1_df$nome[table1_df$nome == "Jhc"] <- "JHC"

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
# ATENÇÃO: confirmar antes que a coluna 'exercicio' está atualizada
# conforme consulta em https://www.camara.leg.br/internet/deputado/pesquisaHistorico.asp
# ATENÇÃO: confira abaixo nome do arquivo e altere se necessário

setwd("~/Downloads/")
id_politicos <- read.csv("~/Downloads/plenario2019_CD-politicos-19jun2019.csv", encoding = "UTF-8", stringsAsFactors = F)

#11. dar um join entre os dois arquivos

joined_data <- id_politicos %>%
  filter(exercicio != "nao") %>%
  left_join(table1_df, by = "nome_upper")

#12. contar o número de ocorrências de NA
# ATENÇÃO: esse número precisa 'bater' com o número de ausentes

sum(is.na(joined_data$voto))

#13. substituir NA por nome, UF, partido e o valor "ausente" no voto

joined_data_2 <- joined_data %>%
  mutate(voto = ifelse(is.na(voto), "ausente", voto)) %>%
  mutate(nome.y = ifelse(is.na(nome.y), nome.x, nome.y)) %>% 
  mutate(uf.y = ifelse(is.na(uf.y), uf.x, uf.y)) %>% 
  mutate(partido.y = ifelse(is.na(partido.y), partido.x, partido.y))


#14. checar nomes (e corrigir se necessário)

A <- joined_data_2$nome.x
B <- joined_data_2$nome.y

setdiff(A, B)

#15. checar partidos (e corrigir se necessário)

C <- joined_data_2$partido.x
D <- joined_data_2$partido.y
setdiff(C, D)

#16. checar UF

G <- joined_data_2$uf.x
H <- joined_data_2$uf.y

setdiff(G, H)

#17. selecionar as colunas que queremos no nosso arquivo

votacao_final <- joined_data_2 %>%
  select(partido.x, id, nome_upper, nome.x, uf.x, voto) %>%
  `colnames<-`(c("partido", "id_politico", "nome_upper", "nome_politico", "uf", "voto"))

#18. inserir coluna com o ID da proposição
# ATENÇÃO: o campo abaixo precisa ser alterado para o ID da nova proposição

votacao_final$id_proposicao <- "6"

#19. inserir coluna com o nome da proposição
# ATENÇÃO: o campo abaixo precisa ser alterado para o código da nova proposição

votacao_final$proposicao <- "PEC57-2019"

#20. inserir coluna com o permalink da proposição
# ATENÇÃO: o campo abaixo precisa ser alterado para o permalink da nova proposição

votacao_final$permalink <- "projeto-tutorial-para-a-inclusao"

#21. definir a ordem das colunas

votacao_final <- votacao_final %>%
  select(id_proposicao, proposicao, partido, id_politico, 
         nome_upper, nome_politico, uf, voto, permalink)

#22. fazer o download
# ATENÇÃO: escolha o nome do arquivo; recomendado: "votacao_NOME_DO_PROJETO_DATA.csv"
write.csv(votacao_final, "votacao_final_projeto_tutorial_para_a_inclusao_19jun2019.csv")
