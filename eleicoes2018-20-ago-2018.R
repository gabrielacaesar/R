install.packages("rpivotTable")
library(rpivotTable)
library(dplyr)
library(readr)
library(readxl)
library(data.table)
library(xlsx)

getwd()

setwd("~/Downloads/eleicoes2018")

cand_BR <- fread(file = "consulta_cand_2018_BR.csv")
View(cand_BR)

#Estamos criando os arquivos
cand_AC <- fread(file = "consulta_cand_2018_AC.csv")
cand_AL <- fread(file = "consulta_cand_2018_AL.csv")
cand_AM <- fread(file = "consulta_cand_2018_AM.csv")
cand_AP <- fread(file = "consulta_cand_2018_AP.csv")
cand_BA <- fread(file = "consulta_cand_2018_BA.csv")
cand_BR <- fread(file = "consulta_cand_2018_BR.csv")
cand_CE <- fread(file = "consulta_cand_2018_CE.csv")
cand_DF <- fread(file = "consulta_cand_2018_DF.csv")
cand_ES <- fread(file = "consulta_cand_2018_ES.csv")
cand_GO <- fread(file = "consulta_cand_2018_GO.csv")
cand_MA <- fread(file = "consulta_cand_2018_MA.csv")
cand_MG <- fread(file = "consulta_cand_2018_MG.csv")
cand_MS <- fread(file = "consulta_cand_2018_MS.csv")
cand_MT <- fread(file = "consulta_cand_2018_MT.csv")
cand_PA <- fread(file = "consulta_cand_2018_PA.csv")
cand_PB <- fread(file = "consulta_cand_2018_PB.csv")
cand_PE <- fread(file = "consulta_cand_2018_PE.csv")
cand_PI <- fread(file = "consulta_cand_2018_PI.csv")
cand_PR <- fread(file = "consulta_cand_2018_PR.csv")
cand_RJ <- fread(file = "consulta_cand_2018_RJ.csv")
cand_RN <- fread(file = "consulta_cand_2018_RN.csv")
cand_RO <- fread(file = "consulta_cand_2018_RO.csv")
cand_RR <- fread(file = "consulta_cand_2018_RR.csv")
cand_RS <- fread(file = "consulta_cand_2018_RS.csv")
cand_SC <- fread(file = "consulta_cand_2018_SC.csv")
cand_SE <- fread(file = "consulta_cand_2018_SE.csv")
cand_SP <- fread(file = "consulta_cand_2018_SP.csv")
cand_TO <- fread(file = "consulta_cand_2018_TO.csv")
cand_ZZ <- fread(file = "consulta_cand_2018_ZZ.csv")

#Estamos agrupando todos os arquivos em um só
cand_2018 <- bind_rows(cand_AC, cand_AL, cand_AM, cand_AP, 
                       cand_BA, cand_BR, cand_CE, cand_DF, 
                       cand_ES, cand_GO, cand_MA, cand_MG, 
                       cand_MS, cand_MT, cand_PA, cand_PB, 
                       cand_PE, cand_PI, cand_PR, cand_RJ, 
                       cand_RN, cand_RO, cand_RR, cand_RS, 
                       cand_SC, cand_SE, cand_SP, cand_TO, 
                       cand_ZZ)


View(cand_2018)

#Estamos tirando colunas excedentes
cand_2018$DT_GERACAO <- NULL
cand_2018$HH_GERACAO <- NULL
cand_2018$CD_TIPO_ELEICAO <- NULL
cand_2018$NM_TIPO_ELEICAO <- NULL
cand_2018$CD_ELEICAO <- NULL
cand_2018$DT_ELEICAO <- NULL
cand_2018$NM_UE <- NULL
cand_2018$NM_PARTIDO <- NULL
cand_2018$CD_NACIONALIDADE <- NULL
cand_2018$CD_MUNICIPIO_NASCIMENTO <- NULL


#cand_2018_trans <- cand_2018 %>%
#  filter(NM_SOCIAL_CANDIDATO != "#NULO#")

#View(cand_2018_trans)
cand_2018_dep_distrital <- cand_2018 %>%
  filter(CD_CARGO == "8")

View(cand_2018_dep_distrital)

cand_2018_dep_estadual <- cand_2018 %>%
  filter(CD_CARGO == "7")

View(cand_2018_dep_estadual)

cand_2018_dep_federal <- cand_2018 %>%
  filter(CD_CARGO == "6")
  group_by(cand_2018_dep_federal, SG_UE, NR_TURNO)
    
View(cand_2018_dep_federal)

unique(cand_2018_dep_federal$NR_PROCESSO)
unique(cand_2018_dep_estadual$NR_PROCESSO)
unique(cand_2018_dep_distrital$NR_PROCESSO)

# Tabela dinâmica dos deputados federais
data(cand_2018_dep_federal)
rpivotTable(data = cand_2018_dep_federal, rows = "SG_UF", 
                    cols="SG_PARTIDO", vals="Freq", aggregatorName = "Count", 
                    rendererName = "Table")

# Criando os arquivos de vagas
vagas_AC <- fread(file = "consulta_vagas_2018_AC.csv")
vagas_AL <- fread(file = "consulta_vagas_2018_AL.csv")
vagas_AM <- fread(file = "consulta_vagas_2018_AM.csv")
vagas_AP <- fread(file = "consulta_vagas_2018_AP.csv")
vagas_BA <- fread(file = "consulta_vagas_2018_BA.csv")
vagas_BR <- fread(file = "consulta_vagas_2018_BR.csv")
vagas_CE <- fread(file = "consulta_vagas_2018_CE.csv")
vagas_DF <- fread(file = "consulta_vagas_2018_DF.csv")
vagas_ES <- fread(file = "consulta_vagas_2018_ES.csv")
vagas_GO <- fread(file = "consulta_vagas_2018_GO.csv")
vagas_MA <- fread(file = "consulta_vagas_2018_MA.csv")
vagas_MG <- fread(file = "consulta_vagas_2018_MG.csv")
vagas_MS <- fread(file = "consulta_vagas_2018_MS.csv")
vagas_MT <- fread(file = "consulta_vagas_2018_MT.csv")
vagas_PA <- fread(file = "consulta_vagas_2018_PA.csv")
vagas_PB <- fread(file = "consulta_vagas_2018_PB.csv")
vagas_PE <- fread(file = "consulta_vagas_2018_PE.csv")
vagas_PI <- fread(file = "consulta_vagas_2018_PI.csv")
vagas_PR <- fread(file = "consulta_vagas_2018_PR.csv")
vagas_RJ <- fread(file = "consulta_vagas_2018_RJ.csv")
vagas_RN <- fread(file = "consulta_vagas_2018_RN.csv")
vagas_RO <- fread(file = "consulta_vagas_2018_RO.csv")
vagas_RR <- fread(file = "consulta_vagas_2018_RR.csv")
vagas_RS <- fread(file = "consulta_vagas_2018_RS.csv")
vagas_SC <- fread(file = "consulta_vagas_2018_SC.csv")
vagas_SE <- fread(file = "consulta_vagas_2018_SE.csv")
vagas_SP <- fread(file = "consulta_vagas_2018_SP.csv")
vagas_TO <- fread(file = "consulta_vagas_2018_TO.csv")
vagas_ZZ <- fread(file = "consulta_vagas_2018_ZZ.csv")

#Estamos agrupando todos os arquivos em um só
vagas_2018 <- bind_rows(vagas_AC, vagas_AL, vagas_AM, vagas_AP, 
                        vagas_BA, vagas_BR, vagas_CE, vagas_DF, 
                        vagas_ES, vagas_GO, vagas_MA, vagas_MG, 
                        vagas_MS, vagas_MT, vagas_PA, vagas_PB, 
                        vagas_PE, vagas_PI, vagas_PR, vagas_RJ, 
                        vagas_RN, vagas_RO, vagas_RR, vagas_RS, 
                        vagas_SC, vagas_SE, vagas_SP, vagas_TO, 
                        vagas_ZZ)

View(vagas_2018)

# Agora fazemos de senador
cand_2018_senador <- cand_2018 %>%
  filter(CD_CARGO == "5")
View(cand_2018_senador)

# Agora fazemos de governador
cand_2018_governador <- cand_2018 %>%
  filter(CD_CARGO == "3")
View(cand_2018_governador)


write.xlsx(as.data.frame(cand_2018_governador), 
           file="cand_2018_governador.xlsx", 
           row.names = TRUE)

write.xlsx(as.data.frame(cand_2018_senador), 
           file="cand_2018_senador.xlsx", 
           row.names = TRUE)

write.xlsx(as.data.frame(cand_2018_dep_federal), 
           file="cand_2018_dep_federal.xlsx", 
           row.names = TRUE)

# Diminuindo o dataset de dep estadual
cand_2018_dep_estadual$NM_SOCIAL_CANDIDATO <- NULL
cand_2018_dep_estadual$CD_SITUACAO_CANDIDATURA <- NULL
cand_2018_dep_estadual$DS_SITUACAO_CANDIDATURA <- NULL
cand_2018_dep_estadual$CD_DETALHE_SITUACAO_CAND <- NULL
cand_2018_dep_estadual$TP_AGREMIACAO <- NULL
cand_2018_dep_estadual$SQ_COLIGACAO <- NULL
cand_2018_dep_estadual$NM_COLIGACAO <- NULL
cand_2018_dep_estadual$NM_COMPOSICAO_COLIGACAO <- NULL
cand_2018_dep_estadual$DS_COMPOSICAO_COLIGACAO <- NULL
cand_2018_dep_estadual$DS_NACIONALIDADE <- NULL
cand_2018_dep_estadual$NR_IDADE_DATA_POSSE <- NULL
cand_2018_dep_estadual$CD_GRAU_INSTRUCAO <- NULL
cand_2018_dep_estadual$DS_GRAU_INSTRUCAO <- NULL
cand_2018_dep_estadual$CD_ESTADO_CIVIL <- NULL
cand_2018_dep_estadual$DS_ESTADO_CIVIL <- NULL
cand_2018_dep_estadual$CD_COR_RACA <- NULL
cand_2018_dep_estadual$DS_COR_RACA <- NULL
cand_2018_dep_estadual$CD_OCUPACAO <- NULL
cand_2018_dep_estadual$DS_OCUPACAO <- NULL
cand_2018_dep_estadual$NR_DESPESA_MAX_CAMPANHA <- NULL
cand_2018_dep_estadual$CD_SIT_TOT_TURNO <- NULL
cand_2018_dep_estadual$DS_SIT_TOT_TURNO <- NULL
cand_2018_dep_estadual$ST_DECLARAR_BENS <- NULL
cand_2018_dep_estadual$NR_PROTOCOLO_CANDIDATURA <- NULL


fwrite(cand_2018_dep_estadual, file="cand_2018_dep_estadual.csv")

data(cand_2018_dep_estadual)
rpivotTable(data = cand_2018_dep_estadual, rows = "SG_UF", 
            cols="SG_PARTIDO", vals="Freq", aggregatorName = "Count", 
            rendererName = "Table")


fwrite(cand_2018_dep_distrital, file="cand_2018_dep_distrital.csv")
fwrite(vagas_2018, file="vagas_2018.csv")

