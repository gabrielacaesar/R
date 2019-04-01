





## Importamos as bibliotecas
library(rvest)
library(data.table)
library(xlsx)
library(dplyr)
install.packages("dplyr")
install.packages("tidyr")
library(tidyr)

# ETAPA 1
## Capturamos a tabela do HTML
## Eliminamos as colunas desnecessárias

url <- "https://www25.senado.leg.br/web/atividade/materias/-/materia/votacao/2478375"

file <- read_html(url) %>%
  html_nodes("li") %>%
  html_text()

senadores <- as.data.frame(file[35:115])

colnames(senadores) <- "votos"

senadores_split <- separate(senadores, c("votos1", "votos2"))

###

votos_senado <- fread("senadores_1_abril_2019_new.csv")

votos_senado$voto[votos_senado$voto == "Sim"] <- "sim"
votos_senado$voto[votos_senado$voto == "NCom"] <- "ausente"
votos_senado$voto[votos_senado$voto == "MIS"] <- "ausente"
votos_senado$voto[votos_senado$voto == "AP"] <- "ausente"
votos_senado$voto[votos_senado$voto == "Não"] <- "nao"
votos_senado$voto[votos_senado$voto == "Presidente (art. 51 RISF)"] <- "art17"

votos_sem_acentuacao <- as.data.frame(iconv(votos_senado$nome, to = "ASCII//TRANSLIT"))

colnames(votos_sem_acentuacao) <- "nome"

votos_caps <- as.data.frame(toupper(votos_sem_acentuacao$nome))

df_senado <- cbind(votos_senado, votos_caps)
colnames(df_senado) <- c("nome", "voto", "senador_caps")


merge_sf <- merge(x = arquivo_senado, y = df_senado, by = "senador_caps")


write.xlsx(as.data.frame(merge_sf), 
           file="merge_sf_1_abril_2019.xlsx", 
           row.names = TRUE, col.names = TRUE)
