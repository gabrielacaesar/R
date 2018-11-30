---
title: "Limpeza e normalização de dados"
author: "Gabriela Caesar"
date: 29/11/2018
output: html_document
---
  
# Nomalizando e limpando os dados de votações da Câmara dos Deputados

install.packages("rmarkdown")
install.packages("rvest")
library(rmarkdown)
library(rvest)
library(data.table)
library(xlsx)


##### Script para normalizar nomes que vêm do site da Câmara


#### Direto do HTML
### 1)
## pegar lista do html da página
## expandir partido para seção de deputados

url <- "http://www.camara.leg.br/internet/votacao/mostraVotacao.asp?ideVotacao=8559&numLegislatura=55&codCasa=1&numSessaoLegislativa=4&indTipoSessaoLegislativa=O&numSessao=225&indTipoSessao=E&tipo=partido"

file <- read_html(url)
tables <- html_nodes(file, "table")
table1 <- html_table(tables[3], fill = TRUE, header = T)

head(table1)

table1_df <- as.data.frame(table1)

colnames(table1_df) <- c("deputado", "uf", "voto")

table1_df$new_column <- NA

idx <- grep("Total.*: \\d+", table1_df$deputado)

for (i in seq_along(idx)){
  n <- as.numeric(sub("^.*: ", "", table1_df$deputado[idx[i]]))
  partido <- sub("Total ", "", table1_df$deputado[idx[i]])
  partido <- sub(": .*", "", partido)
  table1_df$new_column[(idx[i] - n):(idx[i] - 1)] <- partido
}

table1_df <- table1_df[-grep("Total .*:.*", table1_df$deputado), ]
table1_df <- table1_df[-which(table1_df$deputado == table1_df$uf), ]

### 2-A)
## trocar "Sim" por "sim"
## trocar "Não" por "nao"
## trocar "Abstenção" por "abstencao"
## trocar "Obstrução" por "obstrucao"
## trocar "Art 17" por "naovotou"
# obs: ausentes entram depois

table1_df$voto <- as.character(table1_df$voto)
table1_df$voto[table1_df$voto == "Sim"] <- "sim"
table1_df$voto[table1_df$voto == "Não"] <- "nao"
table1_df$voto[table1_df$voto == "Abstenção"] <- "abstencao"
table1_df$voto[table1_df$voto == "Obstrução"] <- "obstrucao"
table1_df$voto[table1_df$voto == "Art. 17"] <- "naovotou"

### 2-B)
## trocar "Podemos" por "PODE"
## trocar "REDE" por "Rede"
## trocar "Solidaried" por "SD"
colnames(table1_df)[4] <- "partido"

table1_df$partido <- as.character(table1_df$partido)
table1_df$partido[table1_df$partido == "Podemos"] <- "PODE"
table1_df$partido[table1_df$partido == "REDE"] <- "Rede"
table1_df$partido[table1_df$partido == "Solidaried"] <- "SD"


### 3)
## cruzar dataframe com outro dataframe, considerando o nome para pegar o ID
## outro daframe é a página única com cada deputado e o respectivo ID

df_base <- fread("~/Downloads/plenarioCamarasDosDeputados-politicos.csv", encoding = "UTF-8")

colnames(df_base)[2] <- "deputado"

df_new <- merge(x=table1_df, y=df_base, by="deputado")

df_final <- data.table(df_new$partido.x, df_new$id, df_new$deputado, df_new$uf.x, df_new$voto)


### 4)
## descobrir quais deputados não tiveram correspondência no merge
## com os nomes, devemos checar caso a caso no planilha principal
## para checar se foi erro de acentuação ou outro motivo
## ou se, de fato, precisamos criar um ID para esse novo deputado

## no caso do "Zeca do Pt" foi a caixa baixa em "t" do "Pt"
## em "Jozi Araújo" possivelmente foi o duplo espaçamento
## em "Chico D´Angelo" foi o "´"

A <- table1_df$deputado
B <- df_base$deputado

setdiff(A, B)

### 5)
## criar coluna para o ID da proposição ("id_proposicao")
## criar coluna para o nome vulgar da proposição ("proposicao")
## criar coluna para o URL ("permalink")
## colocar ordenação alfabética pelo nome do deputado
## fazer o download do dataframe na pasta "Documentos"

df_final$id_proposicao <- NA
df_final$proposicao <- NA
df_final$permalink <- NA


colnames(df_final) <- c("partido", "id_politico", "nome_politico","uf", "voto")

arquivo <- cbind(id_proposicao = "0", df_final)
arquivo <- cbind(proposicao = "PEC000-2018-1t", arquivo)
arquivo <- cbind(permalink = "pec-da-limpeza-e-padronizacao-1-turno", arquivo)

arquivo_final <- data.table(arquivo$id_proposicao, arquivo$proposicao, arquivo$partido,
                            arquivo$id_politico, arquivo$nome_politico, arquivo$uf,
                            arquivo$voto, arquivo$permalink)

colnames(arquivo_final) <- c("id_proposicao", "proposicao", "partido", "id_politico", 
                        "nome_politico","uf", "voto", "permalink")


arquivo_final <- arquivo_final[order(arquivo_final$nome_politico),]


write.csv(arquivo_final, "0arquivo_final_votacao_camara_dos_deputados_29_nov_2018.csv", row.names = T, quote = F)

write.xlsx(as.data.frame(arquivo_final), 
           file="arquivo_final_votacao_camara_dos_deputados_29_nov_2018.xlsx", 
           row.names = TRUE, col.names = TRUE)