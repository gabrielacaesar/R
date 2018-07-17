install.packages("dplyr")
install.packages("data.table")
install.packages("xlsx")
install.packages("tidyr")
install.packages("plyr")
library(dplyr)
library(data.table)
library(xlsx)
library(tidyr)
library(plyr)

getwd()

setwd("D:/Pessoal/VOTACAO_CANDIDATO_UF_1990")

# primeiro eu vou fazer um teste
# com o AC e, se der certo,
# eu aplico para os demais estados

eleicoes1990_AC <- fread("VOTACAO_CANDIDATO_UF_1990_AC.txt")
glimpse(eleicoes1990_AC)
View(eleicoes1990_AC)

eleicoes1990_AC_eleitos <- eleicoes1990_AC %>%
  filter(V19 == "ELEITO")


eleicoes1990_AC_eleitos$V1 <- NULL
eleicoes1990_AC_eleitos$V2 <- NULL
eleicoes1990_AC_eleitos$V4 <- NULL
eleicoes1990_AC_eleitos$V6 <- NULL
eleicoes1990_AC_eleitos$V8 <- NULL
eleicoes1990_AC_eleitos$V9 <- NULL
eleicoes1990_AC_eleitos$V10 <- NULL
eleicoes1990_AC_eleitos$V12 <- NULL
eleicoes1990_AC_eleitos$V14 <- NULL
eleicoes1990_AC_eleitos$V15 <- NULL
eleicoes1990_AC_eleitos$V16 <- NULL
eleicoes1990_AC_eleitos$V18 <- NULL
eleicoes1990_AC_eleitos$V23 <- NULL
eleicoes1990_AC_eleitos$V26 <- NULL


View(eleicoes1990_AC_eleitos)

# deu certo com o AC e agora
# vou aplicar para os outros estados
# e vou juntar os arquivos antes de
# fazer a limpeza de dados

eleicoes1990_AL <- fread("VOTACAO_CANDIDATO_UF_1990_AL.txt")
eleicoes1990_AM <- fread("VOTACAO_CANDIDATO_UF_1990_AM.txt")
eleicoes1990_AP <- fread("VOTACAO_CANDIDATO_UF_1990_AP.txt")
eleicoes1990_BA <- fread("VOTACAO_CANDIDATO_UF_1990_BA.txt")
eleicoes1990_CE <- fread("VOTACAO_CANDIDATO_UF_1990_CE.txt")
eleicoes1990_DF <- fread("VOTACAO_CANDIDATO_UF_1990_DF.txt")
eleicoes1990_ES <- fread("VOTACAO_CANDIDATO_UF_1990_ES.txt")
eleicoes1990_GO <- fread("VOTACAO_CANDIDATO_UF_1990_GO.txt")
eleicoes1990_MA <- fread("VOTACAO_CANDIDATO_UF_1990_MA.txt")
eleicoes1990_MG <- fread("VOTACAO_CANDIDATO_UF_1990_MG.txt")
eleicoes1990_MS <- fread("VOTACAO_CANDIDATO_UF_1990_MS.txt")
eleicoes1990_MT <- fread("VOTACAO_CANDIDATO_UF_1990_MT.txt")
eleicoes1990_PA <- fread("VOTACAO_CANDIDATO_UF_1990_PA.txt")
eleicoes1990_PB <- fread("VOTACAO_CANDIDATO_UF_1990_PB.txt")
eleicoes1990_PE <- fread("VOTACAO_CANDIDATO_UF_1990_PE.txt")
eleicoes1990_PI <- fread("VOTACAO_CANDIDATO_UF_1990_PI.txt")
eleicoes1990_PR <- fread("VOTACAO_CANDIDATO_UF_1990_PR.txt")
eleicoes1990_RJ <- fread("VOTACAO_CANDIDATO_UF_1990_RJ.txt")
eleicoes1990_RN <- fread("VOTACAO_CANDIDATO_UF_1990_RN.txt")
eleicoes1990_RO <- fread("VOTACAO_CANDIDATO_UF_1990_RO.txt")
eleicoes1990_RR <- fread("VOTACAO_CANDIDATO_UF_1990_RR.txt")
eleicoes1990_RS <- fread("VOTACAO_CANDIDATO_UF_1990_RS.txt")
eleicoes1990_SC <- fread("VOTACAO_CANDIDATO_UF_1990_SC.txt")
eleicoes1990_SE <- fread("VOTACAO_CANDIDATO_UF_1990_SE.txt")
eleicoes1990_SP <- fread("VOTACAO_CANDIDATO_UF_1990_SP.txt")
eleicoes1990_TO <- fread("VOTACAO_CANDIDATO_UF_1990_TO.txt")

eleicoes1990 <- bind_rows(eleicoes1990_AL, eleicoes1990_AM, eleicoes1990_AP, eleicoes1990_BA,
                                eleicoes1990_CE, eleicoes1990_DF, eleicoes1990_ES, eleicoes1990_GO,
                                eleicoes1990_MA, eleicoes1990_MG, eleicoes1990_MS, eleicoes1990_MT,
                                eleicoes1990_PA, eleicoes1990_PB, eleicoes1990_PE, eleicoes1990_PI,
                                eleicoes1990_PR, eleicoes1990_RJ, eleicoes1990_RN, eleicoes1990_RO,
                                eleicoes1990_RR, eleicoes1990_RS, eleicoes1990_SC, eleicoes1990_SE,
                                eleicoes1990_SP, eleicoes1990_TO)


eleicoes1990 %>%
  count(V6) %>%
  View

#o código acima era apenas
#para confirmar que eu tinha
#todos os estados, exceto AC

eleicoes1990$V1 <- NULL
eleicoes1990$V2 <- NULL
eleicoes1990$V4 <- NULL
eleicoes1990$V6 <- NULL
eleicoes1990$V8 <- NULL
eleicoes1990$V9 <- NULL
eleicoes1990$V10 <- NULL
eleicoes1990$V12 <- NULL
eleicoes1990$V14 <- NULL
eleicoes1990$V15 <- NULL
eleicoes1990$V16 <- NULL
eleicoes1990$V18 <- NULL
eleicoes1990$V23 <- NULL
eleicoes1990$V26 <- NULL

eleicoes1990_eleitos <- eleicoes1990 %>%
  filter(V19 == "ELEITO")

View(eleicoes1990_eleitos)

# agora que deu certo com os demais estados
# eu vou juntar também o df com AC

eleicoes1990_final <- bind_rows(eleicoes1990_eleitos, eleicoes1990_AC_eleitos)
View(eleicoes1990_final)

eleicoes1990_final %>%
  count(V7) %>%
  View

#o código acima foi apenas
#para confirmar que o AC
#foi incluído e que tudo 
#está funcionando


names(eleicoes1990_final) <- c("ano_eleicao", "eleicao", "uf", "candidato",
                             "cargo", "situacao", "status", "num_partido",
                             "partido", "nome_partido", "nome_coligacao", 
                             "partidos_coligacao")

View(eleicoes1990_final)

library(xlsx)
write.xlsx(as.data.frame(eleicoes1990_final), 
           file="eleicoes1990_final.xlsx", 
           row.names = FALSE)
