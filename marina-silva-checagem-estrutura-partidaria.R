install.packages("dplyr")
library(dplyr)
library(data.table)
library(xlsx)
library(tidyr)
library(plyr)

install.packages("data.table")
library(data.table)

getwd()

setwd("D:/Pessoal/Downloads/")

com <- fread(file = "orgaos_partidarios_19jul2018.csv")
View(com)

com_rede <- com %>%
  filter(sigla_partido == "REDE")%>%
  filter(situacao_vigencia == "Vigente")

View(com_rede)

# acima temos um arquivo apenas da Rede
# e com status de vigente

com_rede %>%
  group_by(tipo_orgao) %>%
  summarise(count = n())

View(com_rede)

# acima mostramos quantos são definitivos
# e quantos são provisórios

com_rede_def <- com_rede %>%
  filter(tipo_orgao == "Órgão definitivo")

View(com_rede_def)

# acima nós mostramos quais são definitos

com_rede_prov <- com_rede %>%
  filter(tipo_orgao == "Órgão provisório")

View(com_rede_prov)


# acima nós mostramos quais são provisórios



