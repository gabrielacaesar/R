library(data.table)
library(tidyverse)
library(abjutils)
library(janitor)

#### DEVEDORES DA UNIAO
#online: https://www.pgfn.gov.br/acesso-a-informacao/dados-abertos
path <- setwd("~/Downloads/Dados_abertos_Nao_Previdenciario")

devedores_sida <-  path %>%
  list.files(pattern="*.csv") %>%
  map_df(~fread(.))


devedores_sida_pf <- devedores_sida %>%
  filter(TIPO_PESSOA == "Pessoa f\xedsica") %>%
  mutate(CPF_DEVEDOR = str_replace_all(CPF_CNPJ, "XXX", "***.")) %>%
  mutate(CPF_DEVEDOR = str_replace_all(CPF_CNPJ, "XX", "-**")) %>%
  select("CPF_DEVEDOR", "NOME_DEVEDOR", "UF_UNIDADE_RESPONSAVEL", "VALOR_CONSOLIDADO")



#### AUXILIO EMERGENCIAL 
#online: http://www.portaldatransparencia.gov.br/download-de-dados/auxilio-emergencial
#online: https://twitter.com/WRosarioCGU/status/1269647480003727363
auxilio_abril_2020 <- "~/Downloads/202004_AuxilioEmergencial.csv" %>%
  fread(
    encoding = "Latin-1",
    select = c("UF",
               "CPF BENEFICIÁRIO",
               "NOME BENEFICIÁRIO",
               "VALOR BENEFÍCIO"))

auxilio_maio_2020 <- "~/Downloads/202005_AuxilioEmergencial.csv" %>%
  fread( 
    encoding = "Latin-1",
    select = c("UF",
               "CPF BENEFICIÁRIO",
               "NOME BENEFICIÁRIO",
               "VALOR BENEFÍCIO"))


##### JOINING DATAFRAMES
# joining dataframes
devedores_auxilio <- auxilio_maio_2020 %>%
  #rbind(auxilio_abril_2020) %>%
  clean_names() %>%
  mutate(valor_beneficio = 
           as.numeric(gsub(",00", "", valor_beneficio))) %>%
  left_join(devedores_sida_pf, by = c("cpf_beneficiario" = "CPF_DEVEDOR",
                                      "nome_beneficiario" = "NOME_DEVEDOR"))





