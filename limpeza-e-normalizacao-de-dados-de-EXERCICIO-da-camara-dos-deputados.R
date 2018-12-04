# Deputados em exercício ou fora de exercício na Câmara dos Deputados
## Gabriela Caesar
## 3 de dezembro de 2018

## Este script serve para identificar quais deputados estão em exercício ou fora de exercício 
## do mandato na Câmara dos Deputados. Inicialmente, importamos o CSV que apresenta todos os deputados 
## cadastrados no projeto. Depois, importamos um XLSX originário da Câmara dos Deputados que tem a 
## versão mais atualizada dos nomes que estão no exercício do mandato.

## Nós normalizamos os nomes de ambos os arquivos para, depois, cruzar os dados. Enfim, podemos criar
## uma coluna para informar se o deputado está em exercício ("sim") ou não está em exercício ("nao").
## Enfim, o script faz o download do CSV final, que deve ser inserido no projeto.


library(rvest)
library(dplyr)
library(data.table)
library(xlsx)
library(readr)

getwd()
setwd("D:/Pessoal/Downloads/")


# ETAPA 1
## Importamos o arquivo atualizado da Câmara
## Eliminamos as colunas desnecessárias

em_exercicio <- fread("deputado.csv")

em_exercicio$Endereço <- NULL
em_exercicio$Anexo <- NULL
em_exercicio$`Endereço (continuação)` <- NULL
em_exercicio$Gabinete <- NULL
em_exercicio$`Endereço (complemento)` <- NULL
em_exercicio$Telefone <- NULL
em_exercicio$Fax <- NULL
em_exercicio$`Mês Aniversário` <- NULL
em_exercicio$`Dia Aniversário` <- NULL
em_exercicio$`Correio Eletrônico` <- NULL
em_exercicio$Tratamento <- NULL

colnames(em_exercicio) <- c("nome_parlamentar", "partido", "uf", "titular_suplente", 
                           "deputado_caps", "nome_civil")

em_exercicio$partido <- as.character(em_exercicio$partido)
em_exercicio$partido[em_exercicio$partido == "Podemos"] <- "PODE"
em_exercicio$partido[em_exercicio$partido == "REDE"] <- "Rede"
em_exercicio$partido[em_exercicio$partido == "Solidaried"] <- "SD"
em_exercicio$partido[em_exercicio$partido == "AVANTE"] <- "Avante"

glimpse(em_exercicio)

# ETAPA 2
## Importamos o nosso arquivo base
## Que tem todos os deputados cadastrados
## E os respectivos IDs
## Criar coluna com nomes sem acentos e em caps

df_base <- fread("plenarioCamarasDosDeputados-politicos-3dez2018.csv", encoding = "UTF-8")

df_base_sem_acentuacao <- as.data.frame(iconv(df_base$nome, from = "UTF-8", to = "ASCII//TRANSLIT"))

colnames(df_base_sem_acentuacao) <- "nome_deputado"

df_base_caps <- as.data.frame(toupper(df_base_sem_acentuacao$nome_deputado))

df_base_new <- cbind(df_base, df_base_caps)

colnames(df_base_new) <- c("V1", "deputado", "id", "foto", "temos a foto?", "partido",
                           "uf", "exercicio", "permalink", "deputado_caps")

glimpse(df_base_new)

# ETAPA 3
## Dar um merge e checar os partidos
## Mostrar qual caso houve mudança de sigla

merge_exercicio <- merge(x=em_exercicio, y=df_base_new, by="deputado_caps")

checagem_partido <- as.data.frame(cbind(merge_exercicio, 
                                        ifelse(merge_exercicio$partido.x == merge_exercicio$partido.y, 
                                               "verdadeiro", 
                                        ifelse(merge_exercicio$partido.x != merge_exercicio$partido.y,
                                               "falso",NA))))

checagem_partido_falso <- checagem_partido %>% 
  filter(V2 == "falso")

count(checagem_partido_falso)

View(checagem_partido_falso)


# ETAPA 4
## Mostrar quais deputados passam a constar "sim"
## Mas antes estavam como "nao"

## Criar coluna para "Em exercício?"
## Incluir "sim" quando for positivo
## Incluir "nao" quando for negativo

# Ajustar colunas para empilhar DFs
# Ordenar de forma alfabética

# FALTA::: AJUSTAR O ENCODING DO NOME PARLAMENTAR


merge_exercicio_sim <- cbind(`Em exercício?` = "sim", merge_exercicio)

A <- em_exercicio$deputado_caps
B <- df_base_new$deputado_caps

setdiff(A, B)

new_merge <- merge(x = df_base_new, y = merge_exercicio_sim, by ="deputado_caps", all = TRUE)

merge_exercicio_nao <- new_merge %>%
  filter(is.na(`Em exercício?`)) %>%
  select(deputado_caps, deputado.x, id.x, foto.x, `temos a foto?.x`,
       partido, uf, exercicio.x, permalink.x)

merge_exercicio_nao <- data.frame(merge_exercicio_nao, `Em exercício?` = "nao")

colnames(merge_exercicio_nao) <- c("deputado_caps", "nome_parlamentar", "id", "foto",
                                   "temos_a_foto", "partido", "uf", "exercicio", "permalink",
                                   "em_exercicio_new")


merge_exercicio_sim <- merge_exercicio_sim %>%
  select(deputado_caps, nome_parlamentar, id, foto, 
         `temos a foto?`, partido.y, uf.y, exercicio, permalink, 
         `Em exercício?`)

colnames(merge_exercicio_sim) <- c("deputado_caps", "nome_parlamentar", "id", "foto",
                                  "temos_a_foto", "partido", "uf", "exercicio", "permalink",
                                  "em_exercicio_new")

final_merge <- bind_rows(merge_exercicio_sim, merge_exercicio_nao)

final_merge_cresc <- final_merge[order(final_merge$deputado_caps),]

# ETAPA 5
## Fazer o download do CSV
## e do XLSX

write.csv(final_merge_cresc, "final_merge_cresc_3_dez_2018.csv", row.names = T, quote = F)

write.xlsx(as.data.frame(final_merge_cresc), 
           file="final_merge_cresc_3_dez_2018.xlsx", 
           row.names = TRUE, col.names = TRUE)


# EXTRA - ETAPA 6
## Mostrar apenas as linhas 
## Que devem sofrer mudanças


alteracoes_deputados <- as.data.frame(cbind(final_merge_cresc, 
                                        ifelse(final_merge_cresc$em_exercicio_new == final_merge_cresc$exercicio, 
                                               "verdadeiro", 
                                               ifelse(final_merge_cresc$em_exercicio_new != final_merge_cresc$exercicio,
                                                      "falso",NA))))

alteracoes_deputados_falso <- alteracoes_deputados %>%
  filter(V2 == "falso")

count(alteracoes_deputados_falso)

View(alteracoes_deputados_falso)
