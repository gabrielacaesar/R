library(tidyverse)
library(data.table)

convencional <- fread("~/inmet/TMAX, TMED, TMIN, MENSAL, 1989 -2019 CONVENCIONAL.CSV")

# http://www.inmet.gov.br/portal/index.php?r=estacoes/estacoesConvencionais

convencional_tidy <- convencional %>%
  separate(ANO, c("ano", "mes"), sep = "/") %>%
  filter(ano != "2019") %>%
  mutate(TMAX = str_replace_all(TMAX, "\\,", "\\.")) %>%
  mutate(TMIN = str_replace_all(TMIN, "\\,", "\\.")) %>%
  mutate(TMED = str_replace_all(TMED, "\\,", "\\.")) 


########################################################
##### por UF
########################################################

# TMAX - uf
convencional_tidy_tmax <- convencional_tidy %>%
  group_by(NOME, UF, ano) %>%
  summarise(soma = sum(as.integer(TMAX)),
            contagem = n()) %>%
  filter(contagem > 10 & contagem < 13) %>%
  mutate(media = soma / contagem) %>%
  select(UF, ano, media) %>%
  group_by(UF, ano) %>%
  summarise(soma = sum(media),
            contagem = n()) %>%
  mutate(media = soma / contagem) %>%
  mutate(media = str_replace_all(media, "\\.", "\\,")) %>%
  select(UF, ano, media) %>%
  spread(ano, media)

# TMIN - uf
convencional_tidy_tmin <- convencional_tidy %>%
  group_by(NOME, UF, ano) %>%
  summarise(soma = sum(as.integer(TMIN)),
            contagem = n()) %>%
  filter(contagem > 10 & contagem < 13) %>%
  mutate(media = soma / contagem) %>%
  select(UF, ano, media) %>%
  group_by(UF, ano) %>%
  summarise(soma = sum(media),
            contagem = n()) %>%
  mutate(media = soma / contagem) %>%
  mutate(media = str_replace_all(media, "\\.", "\\,")) %>%
  select(UF, ano, media) %>%
  spread(ano, media)


# TMED - uf
convencional_tidy_tmed <- convencional_tidy %>%
  group_by(NOME, UF, ano) %>%
  summarise(soma = sum(as.integer(TMED)),
            contagem = n()) %>%
  filter(contagem > 10 & contagem < 13) %>%
  mutate(media = soma / contagem) %>%
  select(UF, ano, media) %>%
  group_by(UF, ano) %>%
  summarise(soma = sum(media),
            contagem = n()) %>%
  mutate(media = soma / contagem) %>%
  mutate(media = str_replace_all(media, "\\.", "\\,")) %>%
  select(UF, ano, media) %>%
  spread(ano, media)


########################################################
##### por região
########################################################

# criar coluna com regiao
# sudeste
convencional_tidy$regiao[convencional_tidy$UF == "SP"] <- "Sudeste"
convencional_tidy$regiao[convencional_tidy$UF == "RJ"] <- "Sudeste"
convencional_tidy$regiao[convencional_tidy$UF == "ES"] <- "Sudeste"
convencional_tidy$regiao[convencional_tidy$UF == "MG"] <- "Sudeste"
# sul
convencional_tidy$regiao[convencional_tidy$UF == "RS"] <- "Sul"
convencional_tidy$regiao[convencional_tidy$UF == "SC"] <- "Sul"
convencional_tidy$regiao[convencional_tidy$UF == "PR"] <- "Sul"
# centro-oeste
convencional_tidy$regiao[convencional_tidy$UF == "MT"] <- "Centro-Oeste"  
convencional_tidy$regiao[convencional_tidy$UF == "MS"] <- "Centro-Oeste" 
convencional_tidy$regiao[convencional_tidy$UF == "GO"] <- "Centro-Oeste" 
convencional_tidy$regiao[convencional_tidy$UF == "DF"] <- "Centro-Oeste" 
# norte
convencional_tidy$regiao[convencional_tidy$UF == "AM"] <- "Norte" 
convencional_tidy$regiao[convencional_tidy$UF == "AC"] <- "Norte" 
convencional_tidy$regiao[convencional_tidy$UF == "RO"] <- "Norte" 
convencional_tidy$regiao[convencional_tidy$UF == "RR"] <- "Norte" 
convencional_tidy$regiao[convencional_tidy$UF == "AP"] <- "Norte" 
convencional_tidy$regiao[convencional_tidy$UF == "TO"] <- "Norte"
convencional_tidy$regiao[convencional_tidy$UF == "PA"] <- "Norte" 
# nordeste
convencional_tidy$regiao[convencional_tidy$UF == "MA"] <- "Nordeste" 
convencional_tidy$regiao[convencional_tidy$UF == "PI"] <- "Nordeste" 
convencional_tidy$regiao[convencional_tidy$UF == "CE"] <- "Nordeste" 
convencional_tidy$regiao[convencional_tidy$UF == "RN"] <- "Nordeste" 
convencional_tidy$regiao[convencional_tidy$UF == "PB"] <- "Nordeste" 
convencional_tidy$regiao[convencional_tidy$UF == "PE"] <- "Nordeste" 
convencional_tidy$regiao[convencional_tidy$UF == "AL"] <- "Nordeste" 
convencional_tidy$regiao[convencional_tidy$UF == "SE"] <- "Nordeste" 
convencional_tidy$regiao[convencional_tidy$UF == "BA"] <- "Nordeste" 


# TMAX - região
convencional_tidy_tmax_REGIAO <- convencional_tidy %>%
  group_by(NOME, UF, regiao, ano) %>%
  summarise(soma = sum(as.integer(TMAX)),
            contagem = n()) %>%
  filter(contagem > 10 & contagem < 13) %>%
  mutate(media = soma / contagem) %>%
  select(regiao, ano, media) %>%
  group_by(regiao, ano) %>%
  summarise(soma = sum(media),
            contagem = n()) %>%
  mutate(media = soma / contagem) %>%
  select(regiao, ano, media) %>%
  spread(ano, media)


# TMIN - região
convencional_tidy_tmin_REGIAO <- convencional_tidy %>%
  group_by(NOME, UF, regiao, ano) %>%
  summarise(soma = sum(as.integer(TMIN)),
            contagem = n()) %>%
  filter(contagem > 10 & contagem < 13) %>%
  mutate(media = soma / contagem) %>%
  select(regiao, ano, media) %>%
  group_by(regiao, ano) %>%
  summarise(soma = sum(media),
            contagem = n()) %>%
  mutate(media = soma / contagem) %>%
  select(regiao, ano, media) %>%
  spread(ano, media)


# TMED - região
convencional_tidy_tmed_REGIAO <- convencional_tidy %>%
  group_by(NOME, UF, regiao, ano) %>%
  summarise(soma = sum(as.integer(TMED)),
            contagem = n()) %>%
  filter(contagem > 10 & contagem < 13) %>%
  mutate(media = soma / contagem) %>%
  select(regiao, ano, media) %>%
  group_by(regiao, ano) %>%
  summarise(soma = sum(media),
            contagem = n()) %>%
  mutate(media = soma / contagem) %>%
  select(regiao, ano, media) %>%
  spread(ano, media)

########################################################
##### Estação: CANARANA-MT
########################################################

convencional_CANARANA_tmax <- convencional_tidy %>%
  filter(NOME == "CANARANA") %>%
  group_by(NOME, UF, ano) %>%
  summarise(soma = sum(as.integer(TMAX)),
            contagem = n()) %>%
  filter(contagem > 10 & contagem < 13) %>%
  mutate(media = soma / contagem) %>%
  select(NOME, UF, ano, media)

write.csv(convencional_CANARANA_tmax, "convencional_CANARANA_tmax.csv")

convencional_CANARANA_tmin <- convencional_tidy %>%
  filter(NOME == "CANARANA") %>%
  group_by(NOME, UF, ano) %>%
  summarise(soma = sum(as.integer(TMIN)),
            contagem = n()) %>%
  filter(contagem > 10 & contagem < 13) %>%
  mutate(media = soma / contagem) %>%
  select(NOME, UF, ano, media)

write.csv(convencional_CANARANA_tmin, "convencional_CANARANA_tmin.csv")

convencional_CANARANA_tmed <- convencional_tidy %>%
  filter(NOME == "CANARANA") %>%
  group_by(NOME, UF, ano) %>%
  summarise(soma = sum(as.integer(TMED)),
            contagem = n()) %>%
  filter(contagem > 10 & contagem < 13) %>%
  mutate(media = soma / contagem) %>%
  select(NOME, UF, ano, media)

write.csv(convencional_CANARANA_tmed, "convencional_CANARANA_tmed.csv")
