
################################################################
###                                                          ###
###                   O voto dos senadores                   ###
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


#2. ler as bibliotecas
library(rvest)
library(data.table)
library(xlsx)
library(dplyr)
library(tidyr)

#3. importamos a tabela de votação

url <- "https://www25.senado.leg.br/web/atividade/materias/-/materia/votacao/2478375"

file <- read_html(url) %>%
  html_nodes("li") %>%
  html_text()

senadores <- as.data.frame(file[35:115])
colnames(senadores) <- "votos"

#4. separamos nome e votos em duas colunas
senadores_split <- separate(senadores, votos, c("votos1", "votos2"), sep = " - ")

senadores_split_2 <- as.data.frame(sub(".*\\.", "", senadores_split$votos1))
colnames(senadores_split_2) <- "nome_politico"

votacao_nova <- cbind(senadores_split_2, senadores_split$votos2)
colnames(votacao_nova) <- c("nome_politico", "voto")

#5. criar uma coluna com os nomes em caixa alta e sem acento

nome_upper <- as.data.frame(iconv(votacao_nova$nome_politico, from = "UTF-8", to = "ASCII//TRANSLIT"))

colnames(nome_upper) <- "nome_upper"

nome_upper <- as.data.frame(toupper(nome_upper$nome_upper))

votacao_nova_final <- cbind(votacao_nova, nome_upper)
colnames(votacao_nova_final) <- c("nome_politico", "voto", "nome_upper")

#6. padronizar os votos

votacao_nova_final$voto <- as.character(votacao_nova_final$voto)

votacao_nova_final$voto[votacao_nova_final$voto == "Sim"] <- "sim"
votacao_nova_final$voto[votacao_nova_final$voto == "Não"] <- "nao"
votacao_nova_final$voto[votacao_nova_final$voto == "Obstrução"] <- "obstrucao"
votacao_nova_final$voto[votacao_nova_final$voto == "Abstenção"] <- "abstencao"
votacao_nova_final$voto[votacao_nova_final$voto == "Presidente (art. 51 RISF)"] <- "art17"
votacao_nova_final$voto[votacao_nova_final$voto == "NCom"] <- "ausente"
votacao_nova_final$voto[votacao_nova_final$voto == "AP"] <- "ausente"
votacao_nova_final$voto[votacao_nova_final$voto == "AP "] <- "ausente"
votacao_nova_final$voto[votacao_nova_final$voto == "MIS"] <- "ausente"
votacao_nova_final$voto[votacao_nova_final$voto == "P-NRV"] <- "ausente"
votacao_nova_final$voto[votacao_nova_final$voto == "LS"] <- "ausente"
votacao_nova_final$voto[votacao_nova_final$voto == "LP"] <- "ausente"

unique(votacao_nova_final$voto)

################################################################
###                       Segunda etapa                      ###
################################################################

#7. importar o arquivo com os IDs (aba 'politicos')

id_politicos <- read.csv("plenario2019_SF_politicos.csv", encoding = "UTF-8")

#8. dar um join para pegar os IDs, a UF e o partido

# OBS: este é o momento mais importante do script de atualização. 
# não adotamos a mesma nomenclatura dO Senado em todos os casos, 
# e há alguns acentos etc que dão problema.


## the code below doesn't work for now; ll fix it on thursday
id_politicos$nome_upper <- as.character(id_politicos$nome_upper)
votacao_nova_final$nome_upper <- as.character(votacao_nova_final$nome_upper)

votacao_nova_final <- votacao_nova_final %>% 
  select("nome_upper", "nome_politico", "voto")

lvls <- sort(unique(c(levels(votacao_nova_final$nome_upper),
                      levels(id_politicos$nome_upper))))

id_politicos$nome_upper <- factor(id_politicos$nome_upper, levels = lvls)
votacao_nova_final$nome_upper <- factor(votacao_nova_final$nome_upper, levels = lvls)

joined_data <- left_join(votacao_nova_final, id_politicos, by = "nome_upper")


#9. verificar quais linhas não tiveram correspondência
# OBS: Ao abrir o 'joined_data', nós ordenamos e vemos quais são os casos.
# Abaixo, fazemos a correção no arquivo original das correções.



#10. fazer novamente o left_join (CASO NECESSÁRIO)

#11. selecionar as colunas que queremos no nosso arquivo

#12. inserir coluna com o ID da proposição

#13. inserir coluna com o nome da proposição

#14. inserir coluna com o permalink da proposição

#15. renomear as colunas

#16. definir a ordem das colunas

#17. fazer o download




