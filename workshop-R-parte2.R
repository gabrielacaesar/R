library(dplyr)
library(data.table)

setwd("Z:/alunos")
getwd()

# importando dados de municípios com biometria
biometria_dados <- fread("biometria_2.csv")
glimpse(biometria_dados)

# importando dados de comparecimento para SP, MG e PE
dados_comparecimento <- fread("comparecimento_2.csv")
glimpse(dados_comparecimento)


######
unique(dados_comparecimento$NOME_MUNICIPIO)
unique(biometria_dados$municipio)

#acima percebemos que ha dados em caixa alta
# e outros em caixa baixa, com espaço
# ou com underline; precisamos padronizar
##########

#nativo:tolower
#nativo:iconv
#dplyr:filter
#dplyr:mutate
#dplyr:left_join

elec_biometria <- dados_comparecimento %>%
  filter(DESCRICAO_CARGO == "VEREADOR") %>%
  mutate(NOME_MUNICIPIO = tolower(NOME_MUNICIPIO),
         NOME_MUNICIPIO = iconv(NOME_MUNICIPIO, to="ASCII//TRANSLIT"),
         NOME_MUNICIPIO = gsub(" ", "_", NOME_MUNICIPIO)) %>%
  left_join(biometria_dados, by=c("SIGLA_UF" = "uf" , "NOME_MUNICIPIO" = "municipio"))

## esse ASCII//TRANSLIT eh para tirar o acento
## no left join, tb colocamos a uf porque ha municipios com o mesmo nome
# em ufs diferentes, entao temos de considerar as duas colunas

glimpse(elec_biometria)
View(elec_biometria)
##############

#dplyr:if_else

elec_biometria <- elec_biometria %>%
  mutate(situacao_recadastramento = if_else(!is.na(data), 
                                            "recadastro", 
                                            "sem recadastro"))
glimpse(elec_biometria)
View(elec_biometria)

##############

elec_biometria %>%
  group_by(SIGLA_UF, situacao_recadastramento) %>%
  summarise(media_abstencoes = mean(QTD_ABSTENCOES),
            media_perc = round(sum(QTD_ABSTENCOES)/sum(QTD_APTOS), 2))

getwd()
setwd("C:/Users/lab735/Desktop")
fwrite(elec_biometria, file="elec_biometria_gabriela_caesar.csv")

#salvando em xlsx
library(xlsx)
write.xlsx(as.data.frame(elec_biometria), 
           file="teste.xlsx", 
           row.names = FALSE)

#importando o arquivo que salvamos de novo para o R Studio

library(readxl)
teste <- read_excel("teste.xlsx", col_types = c("text", 
                                                "text", "numeric", "numeric", "text", 
                                                "text", "numeric", "numeric", "text", 
                                                "numeric", "numeric", "text", "numeric", 
                                                "numeric", "numeric", "numeric", "numeric", 
                                                "numeric", "numeric", "numeric", "numeric", 
                                                "numeric", "numeric", "numeric", "text", 
                                                "text", "text", "numeric", "text", "numeric", 
                                                "text"))


###############
# agora vamos mexer com TIDYR

install.packages("tidyr")
library(tidyr)

abstencao_por_cadastro <- elec_biometria %>%
  group_by(SIGLA_UF, situacao_recadastramento) %>%
  summarise(media_abstencoes = mean(QTD_ABSTENCOES),
            media_perc = round(sum(QTD_ABSTENCOES)/sum(QTD_APTOS), 2))


abstencao_por_cadastro %>%
  select(-media_abstencoes) %>%
  spread(situacao_recadastramento, media_perc) %>%
  rename(sem_recadastro = "sem recadastro") %>%
  mutate(dif = sem_recadastro - recadastro) %>%
  ungroup() %>%
  summarise(media_dif = mean(dif))
