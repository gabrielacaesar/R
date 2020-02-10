library(tidyverse)
library(data.table)

setwd("~/Downloads/microdados_educaá∆o_b†sica_2019/DADOS")

DOCENTES_SUL <- fread("DOCENTES_SUL.csv")
DOCENTES_SUDESTE <- fread("DOCENTES_SUDESTE.csv")
DOCENTES_NORTE <- fread("DOCENTES_NORTE.csv")
DOCENTES_NORDESTE <- fread("DOCENTES_NORDESTE.csv")
DOCENTES_CO <- fread("DOCENTES_CO.csv")

norte <- DOCENTES_NORTE %>%
  filter(IN_NECESSIDADE_ESPECIAL == "1" |
           IN_BAIXA_VISAO == "1" |
           IN_CEGUEIRA == "1" |
           IN_DEF_AUDITIVA == "1" |
           IN_DEF_FISICA == "1" |
           IN_DEF_INTELECTUAL == "1" |
           IN_SURDEZ == "1" |
           IN_SURDOCEGUEIRA == "1" |
           IN_DEF_MULTIPLA == "1" |
           IN_AUTISMO == "1" |
           IN_SUPERDOTACAO == "1") %>%
  select(NU_ANO_CENSO, ID_DOCENTE, NU_IDADE, TP_SEXO, 
         IN_NECESSIDADE_ESPECIAL,
           IN_BAIXA_VISAO,
           IN_CEGUEIRA,
           IN_DEF_AUDITIVA,
           IN_DEF_FISICA,
           IN_DEF_INTELECTUAL,
           IN_SURDEZ,
           IN_SURDOCEGUEIRA,
           IN_DEF_MULTIPLA,
           IN_AUTISMO,
           IN_SUPERDOTACAO) %>%
  mutate(regiao = "NORTE")


sul <- DOCENTES_SUL %>%
  filter(IN_NECESSIDADE_ESPECIAL == "1" |
           IN_BAIXA_VISAO == "1" |
           IN_CEGUEIRA == "1" |
           IN_DEF_AUDITIVA == "1" |
           IN_DEF_FISICA == "1" |
           IN_DEF_INTELECTUAL == "1" |
           IN_SURDEZ == "1" |
           IN_SURDOCEGUEIRA == "1" |
           IN_DEF_MULTIPLA == "1" |
           IN_AUTISMO == "1" |
           IN_SUPERDOTACAO == "1") %>%
  select(NU_ANO_CENSO, ID_DOCENTE, NU_IDADE, TP_SEXO, 
         IN_NECESSIDADE_ESPECIAL,
         IN_BAIXA_VISAO,
         IN_CEGUEIRA,
         IN_DEF_AUDITIVA,
         IN_DEF_FISICA,
         IN_DEF_INTELECTUAL,
         IN_SURDEZ,
         IN_SURDOCEGUEIRA,
         IN_DEF_MULTIPLA,
         IN_AUTISMO,
         IN_SUPERDOTACAO) %>%
  mutate(regiao = "SUL")


sudeste <- DOCENTES_SUDESTE %>%
  filter(IN_NECESSIDADE_ESPECIAL == "1" |
           IN_BAIXA_VISAO == "1" |
           IN_CEGUEIRA == "1" |
           IN_DEF_AUDITIVA == "1" |
           IN_DEF_FISICA == "1" |
           IN_DEF_INTELECTUAL == "1" |
           IN_SURDEZ == "1" |
           IN_SURDOCEGUEIRA == "1" |
           IN_DEF_MULTIPLA == "1" |
           IN_AUTISMO == "1" |
           IN_SUPERDOTACAO == "1") %>%
  select(NU_ANO_CENSO, ID_DOCENTE, NU_IDADE, TP_SEXO, 
         IN_NECESSIDADE_ESPECIAL,
         IN_BAIXA_VISAO,
         IN_CEGUEIRA,
         IN_DEF_AUDITIVA,
         IN_DEF_FISICA,
         IN_DEF_INTELECTUAL,
         IN_SURDEZ,
         IN_SURDOCEGUEIRA,
         IN_DEF_MULTIPLA,
         IN_AUTISMO,
         IN_SUPERDOTACAO) %>%
  mutate(regiao = "SUDESTE")


nordeste <- DOCENTES_NORDESTE %>%
  filter(IN_NECESSIDADE_ESPECIAL == "1" |
           IN_BAIXA_VISAO == "1" |
           IN_CEGUEIRA == "1" |
           IN_DEF_AUDITIVA == "1" |
           IN_DEF_FISICA == "1" |
           IN_DEF_INTELECTUAL == "1" |
           IN_SURDEZ == "1" |
           IN_SURDOCEGUEIRA == "1" |
           IN_DEF_MULTIPLA == "1" |
           IN_AUTISMO == "1" |
           IN_SUPERDOTACAO == "1") %>%
  select(NU_ANO_CENSO, ID_DOCENTE, NU_IDADE, TP_SEXO, 
         IN_NECESSIDADE_ESPECIAL,
         IN_BAIXA_VISAO,
         IN_CEGUEIRA,
         IN_DEF_AUDITIVA,
         IN_DEF_FISICA,
         IN_DEF_INTELECTUAL,
         IN_SURDEZ,
         IN_SURDOCEGUEIRA,
         IN_DEF_MULTIPLA,
         IN_AUTISMO,
         IN_SUPERDOTACAO) %>%
  mutate(regiao = "NORDESTE")


centrooeste <- DOCENTES_CO %>%
  filter(IN_NECESSIDADE_ESPECIAL == "1" |
           IN_BAIXA_VISAO == "1" |
           IN_CEGUEIRA == "1" |
           IN_DEF_AUDITIVA == "1" |
           IN_DEF_FISICA == "1" |
           IN_DEF_INTELECTUAL == "1" |
           IN_SURDEZ == "1" |
           IN_SURDOCEGUEIRA == "1" |
           IN_DEF_MULTIPLA == "1" |
           IN_AUTISMO == "1" |
           IN_SUPERDOTACAO == "1") %>%
  select(NU_ANO_CENSO, ID_DOCENTE, NU_IDADE, TP_SEXO, 
         IN_NECESSIDADE_ESPECIAL,
         IN_BAIXA_VISAO,
         IN_CEGUEIRA,
         IN_DEF_AUDITIVA,
         IN_DEF_FISICA,
         IN_DEF_INTELECTUAL,
         IN_SURDEZ,
         IN_SURDOCEGUEIRA,
         IN_DEF_MULTIPLA,
         IN_AUTISMO,
         IN_SUPERDOTACAO) %>%
  mutate(regiao = "CENTRO-OESTE")

BR <- rbind(sul, norte, nordeste, sudeste, centrooeste)




