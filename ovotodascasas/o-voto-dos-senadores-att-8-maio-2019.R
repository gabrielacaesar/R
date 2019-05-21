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
###                           HTML                           ###
################################################################

################################################################
###                      Primeira etapa                      ###
################################################################

#1. instalar as bibliotecas
# install.packages(rvest)
# install.packages(xlsx)
# install.packages(dplyr)
# install.packages(tidyr)
# install.packages(purrr)
# install.packages(stringr)

#2. ler as bibliotecas
library(rvest)
library(xlsx)
library(dplyr)
library(tidyr)
library(purrr)
library(stringr)

#3. importamos a tabela de votação

url <- "https://www25.senado.leg.br/web/atividade/materias/-/materia/votacao/2478375"

senadores <- read_html(url) %>%
  html_nodes("li") %>%
  html_text() %>%
  keep(~ stringr::str_detect(.x, "^[0-9]{1,3}\\."))

senadores <- tibble(senadores = senadores)


#4. separamos nome e votos em duas colunas
senadores_split <- separate(senadores, senadores, c("senador", "voto"), sep = " - ")

senadores_split_2 <- senadores_split %>%
  mutate(senador = str_replace(senador, "^[0-9]{1,3}\\. ", "")) %>%
  rename(nome_politico = senador)

votacao_nova <- senadores_split_2


#5. criar uma coluna com os nomes em caixa alta e sem acento
votacao_nova_final <- votacao_nova %>%
  mutate(nome_upper = iconv(
    str_to_upper(nome_politico),
    from = "UTF-8",
    to = "ascii//translit")
  )


#6. padronizar os votos

votacao_nova_final$voto <- as.character(votacao_nova_final$voto)

votacao_nova_final$voto[votacao_nova_final$voto == "Sim"] <- "sim"
votacao_nova_final$voto[votacao_nova_final$voto == "Não"] <- "nao"
votacao_nova_final$voto[votacao_nova_final$voto == "Obstrução"] <- "obstrucao"
votacao_nova_final$voto[votacao_nova_final$voto == "Abstenção"] <- "abstencao"
votacao_nova_final$voto[votacao_nova_final$voto == "Presidente (art. 51 RISF)"] <- "naovotou"
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
setwd("~/Downloads/")
id_politicos <- read.csv("plenario2019_SF_politicos.csv", encoding = "UTF-8", stringsAsFactors = FALSE)

#8. dar um join para pegar os IDs, a UF e o partido

# OBS: este é o momento mais importante do script de atualização. 
# não adotamos a mesma nomenclatura dO Senado em todos os casos, 
# e há alguns acentos etc que dão problema.

joined_data <- left_join(votacao_nova_final, id_politicos, by = "nome_upper")

#9. verificar quais linhas não tiveram correspondência
# OBS: Ao abrir o 'joined_data', nós ordenamos e vemos quais são os casos.
# Abaixo, fazemos a correção no arquivo original das correções.

View(joined_data)

#10. fazer novamente o left_join (CASO NECESSÁRIO)

# ** APENAS SE NECESSÁRIO


#11. checar nomes

A <- joined_data$nome_politico
B <- joined_data$nome

setdiff(A, B)

# 12. checar se precisamos fazer alguma mudança em 'em exercício'
# OBS: APENAS O VOTO DO PRESIDENTE DA SESSÃO
# DEVE SAIR DIFERENTE: voto (naovotou) X exercicio (sim)

C <- joined_data$voto
D <- joined_data$exercicio

setdiff(C, D)

#13. selecionar as colunas que queremos no nosso arquivo

votacao_final <- joined_data %>%
  select(partido, id, nome_upper, nome_politico, uf, voto)

colnames(votacao_final) <- c("partido", "id_politico", "nome_upper", "nome_politico", "uf", "voto")


#14. inserir coluna com o ID da proposição

votacao_final$id_proposicao <- "1"

#15. inserir coluna com o nome da proposição

votacao_final$proposicao <- "PLP54-2019"

#16. inserir coluna com o permalink da proposição

votacao_final$permalink <- "cadastro-positivo"

#17. definir a ordem das colunas

votacao_final <- votacao_final %>%
  select(id_proposicao, proposicao, partido, id_politico, 
         nome_upper, nome_politico, uf, voto, permalink)

#18. fazer o download

write.csv(votacao_final, "votacao_final_plp55_2019.csv")
