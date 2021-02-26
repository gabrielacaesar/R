library(tidyverse)
library(readxl)
library(data.table)

agenda <- readr::read_csv("Downloads/turma_ibpad_ciencia_de_dados_2021-main/dados/agendas_ministerio_comunicacoes/Agenda Ministro - 16-06-2020 a 18-02-2021.csv")

glimpse(agenda)

unique(agenda$`Local do Compromisso`)

nrow(agenda)
colnames(agenda)

populacao <- readxl::read_excel("Downloads/turma_ibpad_ciencia_de_dados_2021-main/dados/ibge/estimativa_dou_2020.xls",
                                skip = 1,
                                sheet = "Municípios")

head(populacao)
head(populacao, 12)

tail(populacao)
tail(populacao, 12)

deputado <- readxl::read_xls("Downloads/turma_ibpad_ciencia_de_dados_2021-main/dados/camara_dos_deputados/deputado.xls")

glimpse(deputado)

summary(deputado)

read_csv("dados/")

class(deputado$`Mês Aniversário`)

municipios <- data.table::fread("https://raw.githubusercontent.com/betafcc/Municipios-Brasileiros-TSE/master/municipios_brasileiros_tse.csv",
                                nrows = 10,
                                select = c("codigo_tse", "codigo_ibge"))

agenda <- readr::read_csv("Downloads/turma_ibpad_ciencia_de_dados_2021-main/dados/agendas_ministerio_comunicacoes/Agenda Ministro - 16-06-2020 a 18-02-2021.csv")


candidatos_2012 <- fread("Downloads/turma_ibpad_ciencia_de_dados_2021-main/dados/tse/consulta_cand_2012/consulta_cand_2012_AC.txt",
                         encoding = "Latin-1")

glimpse(candidatos_2012)

?read_excel()
?read_csv()


