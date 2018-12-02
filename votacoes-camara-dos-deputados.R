---
title: "Limpeza e normalização de dados"
author: "Gabriela Caesar"
date: 29/11/2018
output: html_document
---
  
# Nomalizando e limpando os dados de votações da Câmara dos Deputados
# Instalando e chamando as bibliotecas

install.packages("rmarkdown")
install.packages("rvest")
library(rmarkdown)
library(rvest)
library(data.table)
library(xlsx)
library(dplyr)


##### Script para baixar, limpar e normalizar dados de votação do site da Câmara


#### Direto do HTML
### 1)
## pegar tabela do html da página
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

######################################################
######################################################
### 6)
## pegar o arquivo que apresenta o ID de cada deputado
## tirar a acentuação de cada nome de deputado
## criar uma coluna com os nomes de caixa alta
## normalizar nomes de partido, uf e posicionamento
## tarefa a ser cumprida por causa principalmente 
## dos ausentes, identificados como "<------->"

# A)
# arquivo do ID foi importado antes como "df_base"
# alterar acentuação e caps

df_base_sem_acentuacao <- as.data.frame(iconv(df_base$deputado, from = "UTF-8", to = "ASCII//TRANSLIT"))

colnames(df_base_sem_acentuacao) <- "deputado"

df_base_caps <- as.data.frame(toupper(df_base_sem_acentuacao$deputado))

# B)
# novo arquivo com o DF "df_base" junto a "df_base_caps"

df_base_new <- cbind(df_base, df_base_caps)
colnames(df_base_new) <- c("V1", "deputado", "id", "foto", "temos a foto?", "partido",
                           "uf", "exercicio", "permalink", "deputado_caps")

# C)
# este é o arquivo do DBF da Câmara
# vamos normatizá-lo
votacao_dbf <- fread(file = "~/Downloads/votacao_camara_dos_deputados_original_dbf.csv")

colnames(votacao_dbf) <- c("cod_votacao", "deputado_caps", "voto","partido", "uf")

votacao_dbf$partido <- as.character(votacao_dbf$partido)
votacao_dbf$partido[votacao_dbf$partido == "Podemos"] <- "PODE"
votacao_dbf$partido[votacao_dbf$partido == "REDE"] <- "Rede"
votacao_dbf$partido[votacao_dbf$partido == "Solidaried"] <- "SD"

votacao_dbf$voto <- as.character(votacao_dbf$voto)
votacao_dbf$voto[votacao_dbf$voto == "SIM"] <- "sim"
votacao_dbf$voto[votacao_dbf$voto == "NAO"] <- "nao"
votacao_dbf$voto[votacao_dbf$voto == "ABSTENCAO"] <- "abstencao"
votacao_dbf$voto[votacao_dbf$voto == "OBSTRUCAO"] <- "obstrucao"
votacao_dbf$voto[votacao_dbf$voto == "ART. 17"] <- "naovotou"
votacao_dbf$voto[votacao_dbf$voto == "<------->"] <- "ausente"

votacao_dbf$uf <- as.character(votacao_dbf$uf)
votacao_dbf$uf[votacao_dbf$uf == "ACRE"] <- "AC"
votacao_dbf$uf[votacao_dbf$uf == "ALAGOAS"] <- "AL"
votacao_dbf$uf[votacao_dbf$uf == "AMAPA"] <- "AP"
votacao_dbf$uf[votacao_dbf$uf == "AMAZONAS"] <- "AM"
votacao_dbf$uf[votacao_dbf$uf == "BAHIA"] <- "BA"
votacao_dbf$uf[votacao_dbf$uf == "CEARA"] <- "CE"
votacao_dbf$uf[votacao_dbf$uf == "DISTRITO FEDERAL"] <- "DF"
votacao_dbf$uf[votacao_dbf$uf == "ESPIRITO SANTO"] <- "ES"
votacao_dbf$uf[votacao_dbf$uf == "GOIAS"] <- "GO"
votacao_dbf$uf[votacao_dbf$uf == "MARANHAO"] <- "MA"
votacao_dbf$uf[votacao_dbf$uf == "MATO GROSSO"] <- "MT"
votacao_dbf$uf[votacao_dbf$uf == "MATO GROSSO DO SUL"] <- "MS"
votacao_dbf$uf[votacao_dbf$uf == "MINAS GERAIS"] <- "MG"
votacao_dbf$uf[votacao_dbf$uf == "PARA"] <- "PA"
votacao_dbf$uf[votacao_dbf$uf == "PARAIBA"] <- "PB"
votacao_dbf$uf[votacao_dbf$uf == "PARANA"] <- "PR"
votacao_dbf$uf[votacao_dbf$uf == "PERNAMBUCO"] <- "PE"
votacao_dbf$uf[votacao_dbf$uf == "PIAUI"] <- "PI"
votacao_dbf$uf[votacao_dbf$uf == "RIO DE JANEIRO"] <- "RJ"
votacao_dbf$uf[votacao_dbf$uf == "RIO GRANDE DO NORTE"] <- "RN"
votacao_dbf$uf[votacao_dbf$uf == "RIO GRANDE DO SUL"] <- "RS"
votacao_dbf$uf[votacao_dbf$uf == "RONDONIA"] <- "RO"
votacao_dbf$uf[votacao_dbf$uf == "RORAIMA"] <- "RR"
votacao_dbf$uf[votacao_dbf$uf == "SANTA CATARINA"] <- "SC"
votacao_dbf$uf[votacao_dbf$uf == "SAO PAULO"] <- "SP"
votacao_dbf$uf[votacao_dbf$uf == "SERGIPE"] <- "SE"
votacao_dbf$uf[votacao_dbf$uf == "TOCANTINS"] <- "TO"

# D)
# ordenação e merge

votacao_dbf <- votacao_dbf[order(votacao_dbf$deputado_caps),]

votacao_dbf_merge <- merge(x=votacao_dbf, y=df_base_new, by="deputado_caps")

votacao_dbf_final <- data.table(votacao_dbf_merge$partido.x, votacao_dbf_merge$id, 
                                votacao_dbf_merge$deputado_caps, votacao_dbf_merge$deputado, 
                                votacao_dbf_merge$uf.x, votacao_dbf_merge$voto)

# E)
# ver quais deputados não tiveram correspondência
# Analisar se houve um erro (de acentuação, possivelmente)
# Ou se é necessário cadastrar o deputado

A <- votacao_dbf$deputado_caps
B <- df_base_new$deputado_caps

setdiff(A, B)

# F)
# inserir colunas sobre a tal proposição
# e definir quais colunas queremos no DF

votacao_dbf_final <- cbind(id_proposicao = "0", votacao_dbf_final)
votacao_dbf_final <- cbind(proposicao = "PEC000-2018-1t", votacao_dbf_final)
votacao_dbf_final <- cbind(permalink = "pec-da-limpeza-e-padronizacao-1-turno", votacao_dbf_final)

colnames(votacao_dbf_final) <- c("permalink", "proposicao", "id_proposicao", "partido", 
                                 "id_politico", "politico_upper", "nome_politico",
                                 "uf", "voto")

votacao_dbf_final <- data.table(votacao_dbf_final$id_proposicao, votacao_dbf_final$proposicao, 
                            votacao_dbf_final$partido, votacao_dbf_final$id_politico, 
                            votacao_dbf_final$politico_upper, votacao_dbf_final$nome_politico,
                            votacao_dbf_final$uf, votacao_dbf_final$voto, votacao_dbf_final$permalink)

colnames(votacao_dbf_final) <- c("id_proposicao", "proposicao", "partido", "id_politico",
                                 "politico_upper", "nome_politico", "uf", "voto", "permalink")

# G)
# fazer o download dos dados


write.csv(votacao_dbf_final, "votacao_dbf_final_votacao_camara_dos_deputados_30_nov_2018.csv", row.names = T, quote = F)

write.xlsx(as.data.frame(votacao_dbf_final), 
           file="votacao_dbf_final_votacao_camara_dos_deputados_30_nov_2018.xlsx", 
           row.names = TRUE, col.names = TRUE)
