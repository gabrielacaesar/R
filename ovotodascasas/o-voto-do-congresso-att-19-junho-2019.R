
################################################################
###                                                          ###
###                    O voto do Congresso                   ###
###                                                          ###
###                      gabriela caesar                     ###
###                                                          ###
################################################################

################################################################
###                 Inclusão de votação nova                 ###
################################################################

################################################################
###                 Download de arquivo DBF                  ###
################################################################

################################################################
###                      Primeira etapa                      ###
################################################################


#1. instalar as bibliotecas
install.packages("tidyverse")
install.packages("foreign")

#2. ler as bibliotecas
library(tidyverse)
library(foreign)

#3. importar o arquivo novo de votação
# ATENÇÃO: repare que o nome do arquivo começa com "CN", e não "CD"
setwd("~/Downloads/")
votacao_nova_dbf <- read.dbf("CN190006.dbf")


#4. mudar os nomes de colunas
colnames(votacao_nova_dbf) <- c("n_votacao", "nome_upper", "voto", "partido", "uf")

#5. padronizar os votos
votacao_nova_dbf$voto <- as.character(votacao_nova_dbf$voto)

votacao_nova_dbf$voto[votacao_nova_dbf$voto == "SIM"] <- "sim"
votacao_nova_dbf$voto[votacao_nova_dbf$voto == "NAO"] <- "nao"
votacao_nova_dbf$voto[votacao_nova_dbf$voto == "OBSTRUCAO"] <- "obstrucao"
votacao_nova_dbf$voto[votacao_nova_dbf$voto == "ABSTENCAO"] <- "abstencao"
votacao_nova_dbf$voto[votacao_nova_dbf$voto == "ART. 17"] <- "naovotou"
votacao_nova_dbf$voto[votacao_nova_dbf$voto == "ART.51"] <- "naovotou"
votacao_nova_dbf$voto[votacao_nova_dbf$voto == "<------->"] <- "ausente"

unique(votacao_nova_dbf$voto)

#6. padronizar os nomes de UFs

votacao_nova_dbf$uf <- as.character(votacao_nova_dbf$uf)

votacao_nova_dbf$uf[votacao_nova_dbf$uf == "RORAIMA"] <- "RR"
votacao_nova_dbf$uf[votacao_nova_dbf$uf == "AMAPA"] <- "AP"
votacao_nova_dbf$uf[votacao_nova_dbf$uf == "PARA"] <- "PA"
votacao_nova_dbf$uf[votacao_nova_dbf$uf == "AMAZONAS"] <- "AM"
votacao_nova_dbf$uf[votacao_nova_dbf$uf == "RONDONIA"] <- "RO"
votacao_nova_dbf$uf[votacao_nova_dbf$uf == "ACRE"] <- "AC"
votacao_nova_dbf$uf[votacao_nova_dbf$uf == "TOCANTINS"] <- "TO"
votacao_nova_dbf$uf[votacao_nova_dbf$uf == "MARANHAO"] <- "MA"
votacao_nova_dbf$uf[votacao_nova_dbf$uf == "CEARA"] <- "CE"
votacao_nova_dbf$uf[votacao_nova_dbf$uf == "PIAUI"] <- "PI"
votacao_nova_dbf$uf[votacao_nova_dbf$uf == "RIO GRANDE DO NORTE"] <- "RN"
votacao_nova_dbf$uf[votacao_nova_dbf$uf == "PARAIBA"] <- "PB"
votacao_nova_dbf$uf[votacao_nova_dbf$uf == "PERNAMBUCO"] <- "PE"
votacao_nova_dbf$uf[votacao_nova_dbf$uf == "ALAGOAS"] <- "AL"
votacao_nova_dbf$uf[votacao_nova_dbf$uf == "SERGIPE"] <- "SE"
votacao_nova_dbf$uf[votacao_nova_dbf$uf == "BAHIA"] <- "BA"
votacao_nova_dbf$uf[votacao_nova_dbf$uf == "MINAS GERAIS"] <- "MG"
votacao_nova_dbf$uf[votacao_nova_dbf$uf == "ESPIRITO SANTO"] <- "ES"
votacao_nova_dbf$uf[votacao_nova_dbf$uf == "RIO DE JANEIRO"] <- "RJ"
votacao_nova_dbf$uf[votacao_nova_dbf$uf == "SAO PAULO"] <- "SP"
votacao_nova_dbf$uf[votacao_nova_dbf$uf == "MATO GROSSO"] <- "MT"
votacao_nova_dbf$uf[votacao_nova_dbf$uf == "DISTRITO FEDERAL"] <- "DF"
votacao_nova_dbf$uf[votacao_nova_dbf$uf == "GOIAS"] <- "GO"
votacao_nova_dbf$uf[votacao_nova_dbf$uf == "MATO GROSSO DO SUL"] <- "MS"
votacao_nova_dbf$uf[votacao_nova_dbf$uf == "PARANA"] <- "PR"
votacao_nova_dbf$uf[votacao_nova_dbf$uf == "SANTA CATARINA"] <- "SC"
votacao_nova_dbf$uf[votacao_nova_dbf$uf == "RIO GRANDE DO SUL"] <- "RS"

unique(votacao_nova_dbf$uf)
plyr::count(unique(votacao_nova_dbf$uf))

#7. padronizar os nomes de partidos

votacao_nova_dbf$partido <- as.character(votacao_nova_dbf$partido)

votacao_nova_dbf$partido[votacao_nova_dbf$partido == "NOVO"] <- "Novo"
votacao_nova_dbf$partido[votacao_nova_dbf$partido == "CIDADANIA"] <- "Cidadania"
votacao_nova_dbf$partido[votacao_nova_dbf$partido == "REDE"] <- "Rede"
votacao_nova_dbf$partido[votacao_nova_dbf$partido == "Solidaried"] <- "SD"
votacao_nova_dbf$partido[votacao_nova_dbf$partido == "Podemos"] <- "PODE"
votacao_nova_dbf$partido[votacao_nova_dbf$partido == "S.Part."] <- "S/Partido"

unique(votacao_nova_dbf$partido)

################################################################
###                       Segunda etapa                      ###
################################################################

#8. importar o arquivo com os IDs (aba 'politicos')

id_politicos <- read.csv("plenario2019_SF-politicos-19jun2019.csv", encoding = "UTF-8", stringsAsFactors = F)

#9. dar um join para pegar os IDs e os nomes em caixa alta e baixa

# OBS: este é o momento mais importante do script de atualização. 
# não adotamos a mesma nomenclatura da Câmara em todos os casos, 
# e há alguns acentos, como no caso do Chico D'Angelo, que dão problema.

joined_data <- left_join(votacao_nova_dbf, id_politicos, by = "nome_upper")

View(joined_data)

#10. verificar quais linhas não tiveram correspondência
# OBS: Ao abrir o 'joined_data', nós ordenamos e vemos quais são os casos.
# Abaixo, fazemos a correção no arquivo original das correções.

votacao_nova_dbf$nome_upper <- as.character(votacao_nova_dbf$nome_upper)

# senado
votacao_nova_dbf$nome_upper[votacao_nova_dbf$nome_upper == "LUCAS BARRETOÿ"] <- "LUCAS BARRETO"
votacao_nova_dbf$nome_upper[votacao_nova_dbf$nome_upper == "MARCIO BITAR"] <- "MARCIO BITTAR"

# câmara
votacao_nova_dbf$nome_upper[votacao_nova_dbf$nome_upper == "PROFESSORA DORINHA SEABRA REZEN"] <- "PROFESSORA DORINHA SEABRA REZENDE"
votacao_nova_dbf$nome_upper[votacao_nova_dbf$nome_upper == "CHICO D`ANGELO"] <- "CHICO D'ANGELO"
votacao_nova_dbf$nome_upper[votacao_nova_dbf$nome_upper == "LUIZ PHILIPPE DE ORLEANS E BRAG"] <- "LUIZ PHILIPPE DE ORLEANS E BRAGANCA"

#11. fazer novamente o left_join

joined_data_2 <- left_join(votacao_nova_dbf, id_politicos, by = "nome_upper")

#12. verificar se houve mudança de partido
A <- joined_data_2$partido.x
B <- joined_data_2$partido.y

setdiff(A, B)

#13. selecionar as colunas que queremos no nosso arquivo

votacao_final <- joined_data_2 %>% 
  select("nome_upper", "voto", "partido.x", "uf.x", "nome", "id")

#14. renomear as colunas

colnames(votacao_final) <- c("nome_upper", "voto", "partido", "uf", "nome_politico", "id_politico")

#15. inserir coluna com o ID da proposição

votacao_final$id_proposicao <- "4"

#16. inserir coluna com o nome da proposição

votacao_final$proposicao <- "PLP55-2019"

#17. inserir coluna com o permalink da proposição

votacao_final$permalink <- "prorrogacao-de-beneficios-fiscais-a-igrejas-e-instituicoes-beneficentes"


#18. definir a ordem das colunas

votacao_final <- votacao_final %>% 
  select("id_proposicao", "proposicao", "partido", "id_politico", 
         "nome_upper", "nome_politico", "uf", "voto", "permalink") %>% 
  arrange(nome_upper)

#19. fazer o download

write.csv(votacao_final, "votacao_final_PLP55_2019_19jun2019.csv")
