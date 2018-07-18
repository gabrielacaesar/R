library(dplyr)
library(data.table)
library(xlsx)
library(tidyr)
library(plyr)

getwd()

setwd("D:/Pessoal/VOTACAO_CANDIDATO_UF_1978")

# nao ha arquivo DF e TO

eleicoes1978_AC <- fread("VOTACAO_CANDIDATO_UF_1978_AC.txt")
eleicoes1978_AL <- fread("VOTACAO_CANDIDATO_UF_1978_AL.txt")
eleicoes1978_AM <- fread("VOTACAO_CANDIDATO_UF_1978_AM.txt")
eleicoes1978_AP <- fread("VOTACAO_CANDIDATO_UF_1978_AP.txt")
eleicoes1978_BA <- fread("VOTACAO_CANDIDATO_UF_1978_BA.txt")
eleicoes1978_CE <- fread("VOTACAO_CANDIDATO_UF_1978_CE.txt")
eleicoes1978_ES <- fread("VOTACAO_CANDIDATO_UF_1978_ES.txt")
eleicoes1978_GO <- fread("VOTACAO_CANDIDATO_UF_1978_GO.txt")
eleicoes1978_MA <- fread("VOTACAO_CANDIDATO_UF_1978_MA.txt")
eleicoes1978_MG <- fread("VOTACAO_CANDIDATO_UF_1978_MG.txt")
eleicoes1978_MS <- fread("VOTACAO_CANDIDATO_UF_1978_MS.txt")
eleicoes1978_MT <- fread("VOTACAO_CANDIDATO_UF_1978_MT.txt")
eleicoes1978_PA <- fread("VOTACAO_CANDIDATO_UF_1978_PA.txt")
eleicoes1978_PB <- fread("VOTACAO_CANDIDATO_UF_1978_PB.txt")
eleicoes1978_PE <- fread("VOTACAO_CANDIDATO_UF_1978_PE.txt")
eleicoes1978_PI <- fread("VOTACAO_CANDIDATO_UF_1978_PI.txt")
eleicoes1978_PR <- fread("VOTACAO_CANDIDATO_UF_1978_PR.txt")
eleicoes1978_RJ <- fread("VOTACAO_CANDIDATO_UF_1978_RJ.txt")
eleicoes1978_RN <- fread("VOTACAO_CANDIDATO_UF_1978_RN.txt")
eleicoes1978_RO <- fread("VOTACAO_CANDIDATO_UF_1978_RO.txt")
eleicoes1978_RR <- fread("VOTACAO_CANDIDATO_UF_1978_RR.txt")
eleicoes1978_RS <- fread("VOTACAO_CANDIDATO_UF_1978_RS.txt")
eleicoes1978_SC <- fread("VOTACAO_CANDIDATO_UF_1978_SC.txt")
eleicoes1978_SE <- fread("VOTACAO_CANDIDATO_UF_1978_SE.txt")
eleicoes1978_SP <- fread("VOTACAO_CANDIDATO_UF_1978_SP.txt")

eleicoes1978 <- bind_rows(eleicoes1978_AC, eleicoes1978_AL, eleicoes1978_AM, eleicoes1978_AP, 
                          eleicoes1978_BA, eleicoes1978_CE, eleicoes1978_ES, eleicoes1978_GO,
                          eleicoes1978_MT, eleicoes1978_MA, eleicoes1978_MS, eleicoes1978_MG,
                          eleicoes1978_PA, eleicoes1978_PB, eleicoes1978_PE, eleicoes1978_PI, 
                          eleicoes1978_PR, eleicoes1978_RJ, eleicoes1978_RN, eleicoes1978_RO, 
                          eleicoes1978_RR, eleicoes1978_RS, eleicoes1978_SC, eleicoes1978_SE, 
                          eleicoes1978_SP)

eleicoes1978$V1 <- NULL
eleicoes1978$V2 <- NULL
eleicoes1978$V4 <- NULL
eleicoes1978$V6 <- NULL
eleicoes1978$V8 <- NULL
eleicoes1978$V9 <- NULL
eleicoes1978$V10 <- NULL
eleicoes1978$V12 <- NULL
eleicoes1978$V14 <- NULL
eleicoes1978$V15 <- NULL
eleicoes1978$V16 <- NULL
eleicoes1978$V18 <- NULL
eleicoes1978$V23 <- NULL
eleicoes1978$V26 <- NULL


eleicoes1978_eleitos <- eleicoes1978 %>%
  filter(V19 == "ELEITO")
