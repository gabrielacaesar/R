library(dplyr)
library(data.table)
library(xlsx)
library(tidyr)
library(plyr)

getwd()

setwd("D:/Pessoal/VOTACAO_CANDIDATO_UF_1982")

eleicoes1982_AC <- fread("VOTACAO_CANDIDATO_UF_1982_AC.txt")
eleicoes1982_AL <- fread("VOTACAO_CANDIDATO_UF_1982_AL.txt")
eleicoes1982_AM <- fread("VOTACAO_CANDIDATO_UF_1982_AM.txt")
eleicoes1982_AP <- fread("VOTACAO_CANDIDATO_UF_1982_AP.txt")
eleicoes1982_BA <- fread("VOTACAO_CANDIDATO_UF_1982_BA.txt")
eleicoes1982_CE <- fread("VOTACAO_CANDIDATO_UF_1982_CE.txt")
eleicoes1982_ES <- fread("VOTACAO_CANDIDATO_UF_1982_ES.txt")
eleicoes1982_GO <- fread("VOTACAO_CANDIDATO_UF_1982_GO.txt")
eleicoes1982_MA <- fread("VOTACAO_CANDIDATO_UF_1982_MA.txt")
eleicoes1982_MG <- fread("VOTACAO_CANDIDATO_UF_1982_MG.txt")
eleicoes1982_MS <- fread("VOTACAO_CANDIDATO_UF_1982_MS.txt")
eleicoes1982_MT <- fread("VOTACAO_CANDIDATO_UF_1982_MT.txt")
eleicoes1982_PA <- fread("VOTACAO_CANDIDATO_UF_1982_PA.txt")
eleicoes1982_PB <- fread("VOTACAO_CANDIDATO_UF_1982_PB.txt")
eleicoes1982_PE <- fread("VOTACAO_CANDIDATO_UF_1982_PE.txt")
eleicoes1982_PI <- fread("VOTACAO_CANDIDATO_UF_1982_PI.txt")
eleicoes1982_PR <- fread("VOTACAO_CANDIDATO_UF_1982_PR.txt")
eleicoes1982_RJ <- fread("VOTACAO_CANDIDATO_UF_1982_RJ.txt")
eleicoes1982_RN <- fread("VOTACAO_CANDIDATO_UF_1982_RN.txt")
eleicoes1982_RO <- fread("VOTACAO_CANDIDATO_UF_1982_RO.txt")
eleicoes1982_RR <- fread("VOTACAO_CANDIDATO_UF_1982_RR.txt")
eleicoes1982_RS <- fread("VOTACAO_CANDIDATO_UF_1982_RS.txt")
eleicoes1982_SC <- fread("VOTACAO_CANDIDATO_UF_1982_SC.txt")
eleicoes1982_SE <- fread("VOTACAO_CANDIDATO_UF_1982_SE.txt")
eleicoes1982_SP <- fread("VOTACAO_CANDIDATO_UF_1982_SP.txt")

# nao ha arquivo referente a DF e TO
# nao houve eleicao para governador em AP, RO e RR

eleicoes1982 <- bind_rows(eleicoes1982_AC, eleicoes1982_AL, eleicoes1982_AM, eleicoes1982_AP, 
                          eleicoes1982_BA, eleicoes1982_CE, eleicoes1982_ES, eleicoes1982_GO,
                          eleicoes1982_MT, eleicoes1982_MA, eleicoes1982_MS, eleicoes1982_MG,
                          eleicoes1982_PA, eleicoes1982_PB, eleicoes1982_PE, eleicoes1982_PI, 
                          eleicoes1982_PR, eleicoes1982_RJ, eleicoes1982_RN, eleicoes1982_RO, 
                          eleicoes1982_RR, eleicoes1982_RS, eleicoes1982_SC, eleicoes1982_SE, 
                          eleicoes1982_SP)


eleicoes1982$V1 <- NULL
eleicoes1982$V2 <- NULL
eleicoes1982$V4 <- NULL
eleicoes1982$V6 <- NULL
eleicoes1982$V8 <- NULL
eleicoes1982$V9 <- NULL
eleicoes1982$V10 <- NULL
eleicoes1982$V12 <- NULL
eleicoes1982$V14 <- NULL
eleicoes1982$V15 <- NULL
eleicoes1982$V16 <- NULL
eleicoes1982$V18 <- NULL
eleicoes1982$V23 <- NULL
eleicoes1982$V26 <- NULL

eleicoes1982_eleitos_governador <- eleicoes1982 %>%
  filter(V19 == "ELEITO") %>%
  filter(V13 == "GOVERNADOR")
