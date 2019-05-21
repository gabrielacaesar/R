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
###                            PDF                           ###
################################################################

################################################################
###                      Primeira etapa                      ###
################################################################

# objetivo: pegar os dados de votações no PDF
# ter os dados em CSV para incluir no Spreadsheet


# 1. instalar bibliotecas
install.packages("tabulizer")
install.packages("dplyr")
install.packages("stringr")

# 2. ler bibliotecas
library(tabulizer)
library(dplyr)
library(stringr)

# 3. ler o arquivo
setwd("~/Downloads/")

votacao_pdf <- extract_tables("documento-votacoes-senado-pdf-gabrielacaesar-21maio2019.pdf", encoding = "UTF-8")

# 4. PROCESSO PARA CADA PÁGINA DO PDF: 
# pegar tabela, renomear header, deletar primeira linha e segunda coluna

nome_colunas <- c("nome_politico", "blank", "uf", "partido", "voto")

table_1 <- votacao_pdf[[1]]
colnames(table_1) <- nome_colunas
table_1 = table_1[-1,]
table_1 <- table_1[,-2]

table_2 <- votacao_pdf[[2]]
colnames(table_2) <- nome_colunas
table_2 = table_2[-1,]
table_2 <- table_2[,-2]

table_3 <- votacao_pdf[[3]]
colnames(table_3) <- nome_colunas
table_3 = table_3[-1,]
table_3 <- table_3[,-2]

table_4 <- votacao_pdf[[4]]
colnames(table_4) <- nome_colunas
table_4 = table_4[-1,]
table_4 <- table_4[,-2]

# 5. transformar em data frame

table_1 <- as.data.frame(table_1)
table_2 <- as.data.frame(table_2)
table_3 <- as.data.frame(table_3)
table_4 <- as.data.frame(table_4)

# 5. empilhar todos os arquivos

votacao_pdf_final <- bind_rows(table_1, table_2, table_3, table_4)

length(votacao_pdf_final$nome_politico)

# 6. criar coluna 'nome_upper', com nomes em caixa alta e sem acento

votacao_pdf_final <- votacao_pdf_final %>%
  mutate(nome_upper = iconv(
    str_to_upper(nome_politico),
    from = "UTF-8",
    to = "ascii//translit")
  )

# 7. padronizar os partidos
votacao_pdf_final$partido[votacao_pdf_final$partido == "CIDADANIA"] <- "Cidadania"
votacao_pdf_final$partido[votacao_pdf_final$partido == "REDE"] <- "Rede"

unique(votacao_pdf_final$partido)

# 8. padronizar os votos

votacao_pdf_final$voto <- as.character(votacao_pdf_final$voto)

votacao_pdf_final$voto[votacao_pdf_final$voto == "Sim"] <- "sim"
votacao_pdf_final$voto[votacao_pdf_final$voto == "Não"] <- "nao"
votacao_pdf_final$voto[votacao_pdf_final$voto == "Obstrução"] <- "obstrucao"
votacao_pdf_final$voto[votacao_pdf_final$voto == "Abstenção"] <- "abstencao"
votacao_pdf_final$voto[votacao_pdf_final$voto == "Presidente (art. 51 RISF)"] <- "naovotou"
votacao_pdf_final$voto[votacao_pdf_final$voto == "NCom"] <- "ausente"
votacao_pdf_final$voto[votacao_pdf_final$voto == "AP"] <- "ausente"
votacao_pdf_final$voto[votacao_pdf_final$voto == "AP "] <- "ausente"
votacao_pdf_final$voto[votacao_pdf_final$voto == "MIS"] <- "ausente"
votacao_pdf_final$voto[votacao_pdf_final$voto == "P-NRV"] <- "ausente"
votacao_pdf_final$voto[votacao_pdf_final$voto == "LS"] <- "ausente"
votacao_pdf_final$voto[votacao_pdf_final$voto == "LP"] <- "ausente"
votacao_pdf_final$voto[votacao_pdf_final$voto == "LAP"] <- "ausente"
votacao_pdf_final$voto[votacao_pdf_final$voto == "LG"] <- "ausente"
votacao_pdf_final$voto[votacao_pdf_final$voto == "MERC"] <- "ausente"

unique(votacao_pdf_final$voto)


################################################################
###                       Segunda etapa                      ###
################################################################

# 9. importar o arquivo com os IDs (aba 'politicos')
setwd("~/Downloads/")
id_politicos <- read.csv("plenario2019_SF_politicos.csv", encoding = "UTF-8", stringsAsFactors = FALSE)

# 10. dar um join para pegar os IDs, a UF e o partido

# OBS: este é o momento mais importante do script de atualização. 
# não adotamos a mesma nomenclatura dO Senado em todos os casos, 
# e há alguns acentos etc que dão problema.

joined_data <- left_join(votacao_pdf_final, id_politicos, by = "nome_upper")

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

votacao_final <- joined_data %>%
  select(partido.x, id, nome_upper, nome_politico, uf.x, voto)

colnames(votacao_final) <- c("partido", "id_politico", "nome_upper", "nome_politico", "uf", "voto")


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
