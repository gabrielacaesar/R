# Senadores em exercício ou fora de exercício
## Gabriela Caesar
## 4 de dezembro de 2018

## Este script serve para identificar quais senadores estão em exercício 
## ou fora de exercício do mandato. Inicialmente, pegamos uma tabela do HTML
## da página oficial do Senado Federal que apresenta todos os senadores em exercício.

## Depois, importamos o CSV que apresenta todos os senadores cadastrados no projeto. 

## Nós normalizamos os nomes de ambos os arquivos para, depois, cruzar os dados. Enfim, podemos criar
## uma coluna para informar se o senador está em exercício ("sim") ou não está em exercício ("nao").
## Enfim, o script faz o download do CSV final, que deve ser inserido no projeto.

## Importamos as bibliotecas
library(rvest)
library(data.table)
library(xlsx)
library(dplyr)

# ETAPA 1
## Capturamos a tabela do HTML
## Eliminamos as colunas desnecessárias

url <- "https://www25.senado.leg.br/web/senadores/em-exercicio/-/e/por-nome"

file <- read_html(url)
tables <- html_nodes(file, "table")
table1 <- html_table(tables[1], fill = TRUE, header = T)

head(table1)

table1_df <- as.data.frame(table1)

table1_df$Período <- NULL
table1_df$Telefones <- NULL
table1_df$Correio.Eletrônico <- NULL

# ETAPA 2
## trocar "REDE" por "Rede"
## Avante e SD, por exemplo, não têm representação na Câmara

colnames(table1_df)<- c("nome_parlamentar", "partido", "uf")

table1_df$partido <- as.character(table1_df$partido)
table1_df$partido[table1_df$partido == "REDE"] <- "Rede"

table1_df_sem_acentuacao <- as.data.frame(iconv(table1_df$nome_parlamentar, from = "UTF-8", to = "ASCII//TRANSLIT"))

colnames(table1_df_sem_acentuacao) <- "senador_caps"

table1_df_caps <- as.data.frame(toupper(table1_df_sem_acentuacao$senador_caps))

colnames(table1_df_caps) <- "senador_caps"

# ETAPA 3
## incluir coluna de caps ao DF da tabela importada via HTML

arquivo_senado <- cbind(table1_df, table1_df_caps)

# ETAPA 4
## importamos o nosso arquivo base para comparar
## ambos os DFs e ver as diferenças

setwd("D:/Pessoal/Downloads/")
df_base <- fread("plenarioSenadoFederal-politicos.csv", encoding = "UTF-8")

df_base_sem_acentuacao <- as.data.frame(iconv(df_base$nome, from = "UTF-8", to = "ASCII//TRANSLIT"))

colnames(df_base_sem_acentuacao) <- "senador_caps"

df_base_caps <- as.data.frame(toupper(df_base_sem_acentuacao$senador_caps))

colnames(df_base_caps) <- "senador_caps"

# ETAPA 5
## incluir coluna de caps ao DF base

arquivo_senado_base <- cbind(df_base_caps, df_base)

# ETAPA 6
## Dar um merge e checar os partidos
## Mostrar qual caso houve mudança de sigla

merge_senado <- merge(x = arquivo_senado, y = arquivo_senado_base, by = "senador_caps")

checagem_partido <- as.data.frame(cbind(merge_senado, 
                                        ifelse(merge_senado$partido.x == merge_senado$partido.y, 
                                               "verdadeiro", 
                                               ifelse(merge_senado$partido.x != merge_senado$partido.y,
                                                      "falso",NA))))

colnames(checagem_partido)[14] <- "checagem_partido"

checagem_partido_falso <- checagem_partido %>% 
  filter(checagem_partido == "falso")

count(checagem_partido_falso)

View(checagem_partido_falso)


# ETAPA 7

## ainda criar coluna para o exercício
## que deve ser preenchida com "sim" ou "nao"


