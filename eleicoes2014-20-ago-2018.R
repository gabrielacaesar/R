library(rpivotTable)
library(dplyr)
library(readr)
library(readxl)
library(data.table)
library(xlsx)

getwd()
setwd("~/Downloads/eleicoes2018/eleicoes2014")

cand_BR <- fread(file = "consulta_cand_2014_BR.txt")
View(cand_BR)


#Estamos criando os arquivos
cand_AC <- fread(file = "consulta_cand_2014_AC.txt")
cand_AL <- fread(file = "consulta_cand_2014_AL.txt")
cand_AM <- fread(file = "consulta_cand_2014_AM.txt")
cand_AP <- fread(file = "consulta_cand_2014_AP.txt")
cand_BA <- fread(file = "consulta_cand_2014_BA.txt")
cand_BR <- fread(file = "consulta_cand_2014_BR.txt")
cand_CE <- fread(file = "consulta_cand_2014_CE.txt")
cand_DF <- fread(file = "consulta_cand_2014_DF.txt")
cand_ES <- fread(file = "consulta_cand_2014_ES.txt")
cand_GO <- fread(file = "consulta_cand_2014_GO.txt")
cand_MA <- fread(file = "consulta_cand_2014_MA.txt")
cand_MG <- fread(file = "consulta_cand_2014_MG.txt")
cand_MS <- fread(file = "consulta_cand_2014_MS.txt")
cand_MT <- fread(file = "consulta_cand_2014_MT.txt")
cand_PA <- fread(file = "consulta_cand_2014_PA.txt")
cand_PB <- fread(file = "consulta_cand_2014_PB.txt")
cand_PE <- fread(file = "consulta_cand_2014_PE.txt")
cand_PI <- fread(file = "consulta_cand_2014_PI.txt")
cand_PR <- fread(file = "consulta_cand_2014_PR.txt")
cand_RJ <- fread(file = "consulta_cand_2014_RJ.txt")
cand_RN <- fread(file = "consulta_cand_2014_RN.txt")
cand_RO <- fread(file = "consulta_cand_2014_RO.txt")
cand_RR <- fread(file = "consulta_cand_2014_RR.txt")
cand_RS <- fread(file = "consulta_cand_2014_RS.txt")
cand_SC <- fread(file = "consulta_cand_2014_SC.txt")
cand_SE <- fread(file = "consulta_cand_2014_SE.txt")
cand_SP <- fread(file = "consulta_cand_2014_SP.txt")
cand_TO <- fread(file = "consulta_cand_2014_TO.txt")
cand_ZZ <- fread(file = "consulta_cand_2014_ZZ.txt")

#Estamos agrupando todos os arquivos em um só
cand_2014 <- bind_rows(cand_AC, cand_AL, cand_AM, cand_AP, 
                       cand_BA, cand_BR, cand_CE, cand_DF, 
                       cand_ES, cand_GO, cand_MA, cand_MG, 
                       cand_MS, cand_MT, cand_PA, cand_PB, 
                       cand_PE, cand_PI, cand_PR, cand_RJ, 
                       cand_RN, cand_RO, cand_RR, cand_RS, 
                       cand_SC, cand_SE, cand_SP, cand_TO, 
                       cand_ZZ)

View(cand_2014)

# Agora fazemos de dep distrital
cand_2014_dep_distrital <- cand_2014 %>%
  filter(V9 == "8")
View(cand_2014_dep_distrital)
fwrite(cand_2014_dep_distrital, file="cand_2014_dep_distrital.csv")

# Agora fazemos de dep estadual
cand_2014_dep_estadual <- cand_2014 %>%
  filter(V9 == "7")
View(cand_2014_dep_estadual)
fwrite(cand_2014_dep_estadual, file="cand_2014_dep_estadual.csv")

# Agora fazemos de dep federal
cand_2014_dep_federal <- cand_2014 %>%
  filter(V9 == "6")
View(cand_2014_dep_federal)
fwrite(cand_2014_dep_federal, file="cand_2014_dep_federal.csv")

# Agora fazemos de senador
cand_2014_senador <- cand_2014 %>%
  filter(V9 == "5")
View(cand_2014_senador)
fwrite(cand_2014_senador, file="cand_2014_senador.csv")

# Agora fazemos de governador
cand_2014_governador <- cand_2014 %>%
  filter(V9 == "3")
View(cand_2014_governador)
fwrite(cand_2014_governador, file="cand_2014_governador.csv")

# Criando os arquivos de vagas
vagas_AC <- fread(file = "consulta_vagas_2014_AC.txt")
vagas_AL <- fread(file = "consulta_vagas_2014_AL.txt")
vagas_AM <- fread(file = "consulta_vagas_2014_AM.txt")
vagas_AP <- fread(file = "consulta_vagas_2014_AP.txt")
vagas_BA <- fread(file = "consulta_vagas_2014_BA.txt")
vagas_BR <- fread(file = "consulta_vagas_2014_BR.txt")
vagas_CE <- fread(file = "consulta_vagas_2014_CE.txt")
vagas_DF <- fread(file = "consulta_vagas_2014_DF.txt")
vagas_ES <- fread(file = "consulta_vagas_2014_ES.txt")
vagas_GO <- fread(file = "consulta_vagas_2014_GO.txt")
vagas_MA <- fread(file = "consulta_vagas_2014_MA.txt")
vagas_MG <- fread(file = "consulta_vagas_2014_MG.txt")
vagas_MS <- fread(file = "consulta_vagas_2014_MS.txt")
vagas_MT <- fread(file = "consulta_vagas_2014_MT.txt")
vagas_PA <- fread(file = "consulta_vagas_2014_PA.txt")
vagas_PB <- fread(file = "consulta_vagas_2014_PB.txt")
vagas_PE <- fread(file = "consulta_vagas_2014_PE.txt")
vagas_PI <- fread(file = "consulta_vagas_2014_PI.txt")
vagas_PR <- fread(file = "consulta_vagas_2014_PR.txt")
vagas_RJ <- fread(file = "consulta_vagas_2014_RJ.txt")
vagas_RN <- fread(file = "consulta_vagas_2014_RN.txt")
vagas_RO <- fread(file = "consulta_vagas_2014_RO.txt")
vagas_RR <- fread(file = "consulta_vagas_2014_RR.txt")
vagas_RS <- fread(file = "consulta_vagas_2014_RS.txt")
vagas_SC <- fread(file = "consulta_vagas_2014_SC.txt")
vagas_SE <- fread(file = "consulta_vagas_2014_SE.txt")
vagas_SP <- fread(file = "consulta_vagas_2014_SP.txt")
vagas_TO <- fread(file = "consulta_vagas_2014_TO.txt")
vagas_ZZ <- fread(file = "consulta_vagas_2014_ZZ.txt")


#Estamos agrupando todos os arquivos em um só
vagas_2014 <- bind_rows(vagas_AC, vagas_AL, vagas_AM, vagas_AP, 
                        vagas_BA, vagas_BR, vagas_CE, vagas_DF, 
                        vagas_ES, vagas_GO, vagas_MA, vagas_MG, 
                        vagas_MS, vagas_MT, vagas_PA, vagas_PB, 
                        vagas_PE, vagas_PI, vagas_PR, vagas_RJ, 
                        vagas_RN, vagas_RO, vagas_RR, vagas_RS, 
                        vagas_SC, vagas_SE, vagas_SP, vagas_TO, 
                        vagas_ZZ)

View(vagas_2014)

fwrite(vagas_2014, file="vagas_2014.csv")
