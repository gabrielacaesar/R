
################################################################
###                                                          ###
###                   O voto dos deputados                   ###
###                                                          ###
###                      gabriela caesar                     ###
###                                                          ###
################################################################

################################################################
###                  Análise de nova votação                 ###
################################################################

################################################################
###                      Primeira etapa                      ###
################################################################


#1. instalar as bibliotecas
install.packages("tidyverse")
install.packages("foreign")
install.packages("ggplot2")
install.packages("data.table")
install.packages("abjutils")
install.packages("DescTools")
install.packages("eeptools")

#2. ler as bibliotecas
library(tidyverse)
library(foreign)
library(ggplot2)
library(data.table)
library(abjutils)
library(DescTools)
library(eeptools)

#3. definir o diretório
setwd("~/Downloads/")

#4. ler os arquivos
deputados <- fread("plenario2019_CD_16jul2019.csv")
dep_tse <- fread("consulta_cand_2018_BRASIL.csv")

#5. criar coluna com nome sem acento
deputados <- deputados %>%
  mutate(nome_civil_tse_upper = rm_accent(nome_civil_tse))

#6. selecionar colunas e criar coluna sem acento
dep_tse <- dep_tse %>%
  filter(DS_CARGO == "DEPUTADO FEDERAL",
         DS_SIT_TOT_TURNO != "NÃO ELEITO", 
         DS_SIT_TOT_TURNO != "#NULO#") %>%
  select("SQ_CANDIDATO",
         "NM_CANDIDATO",
         "NM_URNA_CANDIDATO",
         "NR_CPF_CANDIDATO",
         "SG_PARTIDO",
         "DT_NASCIMENTO",
         "NR_TITULO_ELEITORAL_CANDIDATO",
         "DS_GENERO",
         "DS_GRAU_INSTRUCAO",
         "DS_ESTADO_CIVIL",
         "DS_COR_RACA",
         "DS_OCUPACAO",
         "DS_SIT_TOT_TURNO",
         "ST_REELEICAO",
         "ST_DECLARAR_BENS") %>%
  mutate(nome_civil_tse_upper = rm_accent(NM_CANDIDATO))

#7. cruzar arquivos considerando coluna 'nome_civil_tse_upper'
deputados_completo <- deputados %>%
  left_join(dep_tse, by = "nome_civil_tse_upper") %>%
  separate(DT_NASCIMENTO, c("dia", "mes", "ano"), sep = "/", remove = FALSE) 



# criar coluna com signos
deputados_completo <- deputados_completo %>%
  unite(nascimento, c("ano", "mes", "dia"), sep = "/", remove = F)

deputados_completo$signo <- Zodiac(deputados_completo$nascimento)
deputados_completo$signo <- as.character(deputados_completo$signo)

deputados_completo$signo[deputados_completo$signo == "Pisces"] <- "Peixes"
deputados_completo$signo[deputados_completo$signo == "Scorpio"] <- "Escorpião"
deputados_completo$signo[deputados_completo$signo == "Virgo"] <- "Virgem"
deputados_completo$signo[deputados_completo$signo == "Aries"] <- "Áries"
deputados_completo$signo[deputados_completo$signo == "Capricorn"] <- "Capricórnio"
deputados_completo$signo[deputados_completo$signo == "Gemini"] <- "Gêmeos"
deputados_completo$signo[deputados_completo$signo == "Cancer"] <- "Câncer"
deputados_completo$signo[deputados_completo$signo == "Leo"] <- "Leão"
deputados_completo$signo[deputados_completo$signo == "Taurus"] <- "Touro"
deputados_completo$signo[deputados_completo$signo == "Sagittarius"] <- "Sagitário"
deputados_completo$signo[deputados_completo$signo == "Aquarius"] <- "Aquário"


# criar coluna com regiao
# sudeste
deputados_completo$regiao[deputados_completo$uf == "SP"] <- "Sudeste"
deputados_completo$regiao[deputados_completo$uf == "RJ"] <- "Sudeste"
deputados_completo$regiao[deputados_completo$uf == "ES"] <- "Sudeste"
deputados_completo$regiao[deputados_completo$uf == "MG"] <- "Sudeste"
# sul
deputados_completo$regiao[deputados_completo$uf == "RS"] <- "Sul"
deputados_completo$regiao[deputados_completo$uf == "SC"] <- "Sul"
deputados_completo$regiao[deputados_completo$uf == "PR"] <- "Sul"
# centro-oeste
deputados_completo$regiao[deputados_completo$uf == "MT"] <- "Centro-Oeste"  
deputados_completo$regiao[deputados_completo$uf == "MS"] <- "Centro-Oeste" 
deputados_completo$regiao[deputados_completo$uf == "GO"] <- "Centro-Oeste" 
deputados_completo$regiao[deputados_completo$uf == "DF"] <- "Centro-Oeste" 
# norte
deputados_completo$regiao[deputados_completo$uf == "AM"] <- "Norte" 
deputados_completo$regiao[deputados_completo$uf == "AC"] <- "Norte" 
deputados_completo$regiao[deputados_completo$uf == "RO"] <- "Norte" 
deputados_completo$regiao[deputados_completo$uf == "RR"] <- "Norte" 
deputados_completo$regiao[deputados_completo$uf == "AP"] <- "Norte" 
deputados_completo$regiao[deputados_completo$uf == "TO"] <- "Norte"
deputados_completo$regiao[deputados_completo$uf == "PA"] <- "Norte" 
# nordeste
deputados_completo$regiao[deputados_completo$uf == "MA"] <- "Nordeste" 
deputados_completo$regiao[deputados_completo$uf == "PI"] <- "Nordeste" 
deputados_completo$regiao[deputados_completo$uf == "CE"] <- "Nordeste" 
deputados_completo$regiao[deputados_completo$uf == "RN"] <- "Nordeste" 
deputados_completo$regiao[deputados_completo$uf == "PB"] <- "Nordeste" 
deputados_completo$regiao[deputados_completo$uf == "PE"] <- "Nordeste" 
deputados_completo$regiao[deputados_completo$uf == "AL"] <- "Nordeste" 
deputados_completo$regiao[deputados_completo$uf == "SE"] <- "Nordeste" 
deputados_completo$regiao[deputados_completo$uf == "BA"] <- "Nordeste" 

# criar coluna com idade
deputados_completo$idade_atual <- eeptools::age_calc(as.Date(deputados_completo$nascimento), enddate = Sys.Date(), units = "years", precise = F)


# criar coluna com número de votos 


# criar coluna com valor do patrimônio


# criar coluna com legislatura


# ajustar o CPF para inserir 0 na frente



  
