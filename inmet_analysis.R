library(tidyverse)
library(data.table)

convencional <- fread("~/inmet/TMAX, TMED, TMIN, MENSAL, 1989 -2019 CONVENCIONAL.CSV")

automaticas <- fread("~/inmet/TMAX, TMED, TMIN, MENSAL, 2000 -2019 AUTOMATICAS.CSV")

########################################################
# convencional
# http://www.inmet.gov.br/portal/index.php?r=estacoes/estacoesConvencionais
########################################################

convencional_tidy <- convencional %>%
  separate(ANO, c("ano", "mes"), sep = "/") %>%
  group_by(NOME, UF, ano) %>%
  summarise(int = n()) %>%
  arrange(desc(int)) %>%
  filter(int > 10 & int < 13)

#######
# TMAX
convencional_tmax <- convencional %>%
  separate(ANO, c("ano", "mes"), sep = "/") %>%
  filter(ano != "2019") %>%
  mutate(TMAX = str_replace_all(TMAX, "\\,", "\\.")) %>%
  group_by(NOME, UF, ano) %>%
  summarise(int = sum(as.integer(TMAX))) %>%
  arrange(desc(int))

# TMAX JOIN
joined_convencional_tmax <- convencional_tmax %>%
  left_join(convencional_tidy, by = c("NOME", "UF", "ano")) %>%
  rename("sum_temp" = `int.x`,
         "count_temp" = `int.y`) %>%
  filter(count_temp != "NA") %>%
  mutate(mean_temp = sum_temp / count_temp) %>%
  select(NOME, UF, ano, mean_temp) %>%
  group_by(UF, ano) %>%
  summarise(sum_temp = sum(mean_temp),
            count_temp = n()) %>%
  mutate(mean_temp = sum_temp / count_temp) %>%
  select(UF, ano, mean_temp) %>%
  spread(ano, mean_temp)

  
#######
# TMIN
convencional_tmin <- convencional %>%
  separate(ANO, c("ano", "mes"), sep = "/") %>%
  filter(ano != "2019") %>%
  mutate(TMIN = str_replace_all(TMIN, "\\,", "\\.")) %>%
  group_by(NOME, UF, ano) %>%
  summarise(int = sum(as.integer(TMIN))) %>%
  arrange(desc(int))

# TMIN JOIN
joined_convencional_tmin <- convencional_tmin %>%
  left_join(convencional_tidy, by = c("NOME", "UF", "ano")) %>%
  rename("sum_temp" = `int.x`,
         "count_temp" = `int.y`) %>%
  filter(count_temp != "NA") %>%
  mutate(mean_temp = sum_temp / count_temp) %>%
  select(NOME, UF, ano, mean_temp) %>%
  group_by(UF, ano) %>%
  summarise(sum_temp = sum(mean_temp),
            count_temp = n()) %>%
  mutate(mean_temp = sum_temp / count_temp) %>%
  select(UF, ano, mean_temp) %>%
  spread(ano, mean_temp)



#######
# TMED
convencional_tmed <- convencional %>%
  separate(ANO, c("ano", "mes"), sep = "/") %>%
  filter(ano != "2019") %>%
  mutate(TMED = str_replace_all(TMED, "\\,", "\\.")) %>%
  group_by(NOME, UF, ano) %>%
  summarise(int = sum(as.integer(TMED))) %>%
  arrange(desc(int))

# TMED JOIN
joined_convencional_tmed <- convencional_tmed %>%
  left_join(convencional_tidy, by = c("NOME", "UF", "ano")) %>%
  rename("sum_temp" = `int.x`,
         "count_temp" = `int.y`) %>%
  filter(count_temp != "NA") %>%
  mutate(mean_temp = sum_temp / count_temp) %>%
  select(NOME, UF, ano, mean_temp) %>%
  group_by(UF, ano) %>%
  summarise(sum_temp = sum(mean_temp),
            count_temp = n()) %>%
  mutate(mean_temp = sum_temp / count_temp) %>%
  select(UF, ano, mean_temp) %>%
  spread(ano, mean_temp)

########################################################
# automáticas
# http://www.inmet.gov.br/portal/index.php?r=estacoes/estacoesAutomaticas
########################################################

automaticas_tidy <- automaticas %>%
  separate(ANO, c("ano", "mes"), sep = "/") %>%
  group_by(NOME, UF, ano) %>%
  summarise(int = n()) %>%
  arrange(desc(int)) %>%
  filter(int > 10)


#######
# TMAX
automaticas_tmax <- automaticas %>%
  separate(ANO, c("ano", "mes"), sep = "/") %>%
  filter(ano != "2019") %>%
  mutate(TMAX = str_replace_all(TMAX, "\\,", "\\.")) %>%
  group_by(NOME, UF, ano) %>%
  summarise(int = sum(as.integer(TMAX))) %>%
  arrange(desc(int))

# TMAX JOIN
joined_automaticas_tmax <- automaticas_tmax %>%
  left_join(automaticas_tidy, by = c("NOME", "UF", "ano")) %>%
  rename("sum_temp" = `int.x`,
         "count_temp" = `int.y`) %>%
  filter(count_temp != "NA") %>%
  mutate(mean_temp = sum_temp / count_temp) %>%
  select(NOME, UF, ano, mean_temp) %>%
  group_by(UF, ano) %>%
  summarise(sum_temp = sum(mean_temp),
            count_temp = n()) %>%
  mutate(mean_temp = sum_temp / count_temp) %>%
  select(UF, ano, mean_temp) %>%
  spread(ano, mean_temp)


#######
# TMIN
automaticas_tmin <- automaticas %>%
  separate(ANO, c("ano", "mes"), sep = "/") %>%
  filter(ano != "2019") %>%
  mutate(TMIN = str_replace_all(TMIN, "\\,", "\\.")) %>%
  group_by(NOME, UF, ano) %>%
  summarise(int = sum(as.integer(TMIN))) %>%
  arrange(desc(int))

# TMIN JOIN
joined_automaticas_tmin <- automaticas_tmin %>%
  left_join(automaticas_tidy, by = c("NOME", "UF", "ano")) %>%
  rename("sum_temp" = `int.x`,
         "count_temp" = `int.y`) %>%
  filter(count_temp != "NA") %>%
  mutate(mean_temp = sum_temp / count_temp) %>%
  select(NOME, UF, ano, mean_temp) %>%
  group_by(UF, ano) %>%
  summarise(sum_temp = sum(mean_temp),
            count_temp = n()) %>%
  mutate(mean_temp = sum_temp / count_temp) %>%
  select(UF, ano, mean_temp) %>%
  spread(ano, mean_temp)

#######
# TMED
automaticas_tmed <- automaticas %>%
  separate(ANO, c("ano", "mes"), sep = "/") %>%
  filter(ano != "2019") %>%
  mutate(TMED = str_replace_all(TMED, "\\,", "\\.")) %>%
  group_by(NOME, UF, ano) %>%
  summarise(int = sum(as.integer(TMED))) %>%
  arrange(desc(int))

# TMED JOIN
joined_automaticas_tmed <- automaticas_tmed %>%
  left_join(automaticas_tidy, by = c("NOME", "UF", "ano")) %>%
  rename("sum_temp" = `int.x`,
         "count_temp" = `int.y`) %>%
  filter(count_temp != "NA") %>%
  mutate(mean_temp = sum_temp / count_temp) %>%
  select(NOME, UF, ano, mean_temp) %>%
  group_by(UF, ano) %>%
  summarise(sum_temp = sum(mean_temp),
            count_temp = n()) %>%
  mutate(mean_temp = sum_temp / count_temp) %>%
  select(UF, ano, mean_temp) %>%
  spread(ano, mean_temp)


########################################################
##### por região
########################################################

# criar coluna com regiao
# sudeste
convencional$regiao[convencional$UF == "SP"] <- "Sudeste"
convencional$regiao[convencional$UF == "RJ"] <- "Sudeste"
convencional$regiao[convencional$UF == "ES"] <- "Sudeste"
convencional$regiao[convencional$UF == "MG"] <- "Sudeste"
# sul
convencional$regiao[convencional$UF == "RS"] <- "Sul"
convencional$regiao[convencional$UF == "SC"] <- "Sul"
convencional$regiao[convencional$UF == "PR"] <- "Sul"
# centro-oeste
convencional$regiao[convencional$UF == "MT"] <- "Centro-Oeste"  
convencional$regiao[convencional$UF == "MS"] <- "Centro-Oeste" 
convencional$regiao[convencional$UF == "GO"] <- "Centro-Oeste" 
convencional$regiao[convencional$UF == "DF"] <- "Centro-Oeste" 
# norte
convencional$regiao[convencional$UF == "AM"] <- "Norte" 
convencional$regiao[convencional$UF == "AC"] <- "Norte" 
convencional$regiao[convencional$UF == "RO"] <- "Norte" 
convencional$regiao[convencional$UF == "RR"] <- "Norte" 
convencional$regiao[convencional$UF == "AP"] <- "Norte" 
convencional$regiao[convencional$UF == "TO"] <- "Norte"
convencional$regiao[convencional$UF == "PA"] <- "Norte" 
# nordeste
convencional$regiao[convencional$UF == "MA"] <- "Nordeste" 
convencional$regiao[convencional$UF == "PI"] <- "Nordeste" 
convencional$regiao[convencional$UF == "CE"] <- "Nordeste" 
convencional$regiao[convencional$UF == "RN"] <- "Nordeste" 
convencional$regiao[convencional$UF == "PB"] <- "Nordeste" 
convencional$regiao[convencional$UF == "PE"] <- "Nordeste" 
convencional$regiao[convencional$UF == "AL"] <- "Nordeste" 
convencional$regiao[convencional$UF == "SE"] <- "Nordeste" 
convencional$regiao[convencional$UF == "BA"] <- "Nordeste" 

convencional_tidy_regiao <- convencional %>%
  separate(ANO, c("ano", "mes"), sep = "/") %>%
  group_by(NOME, UF, ano) %>%
  summarise(int = n()) %>%
  arrange(desc(int)) %>%
  filter(int > 10)


convencional_tmed_regiao <- convencional %>%
  separate(ANO, c("ano", "mes"), sep = "/") %>%
  filter(ano != "2019") %>%
  mutate(TMED = str_replace_all(TMED, "\\,", "\\.")) %>%
  group_by(NOME, UF, regiao, ano) %>%
  summarise(int = sum(as.integer(TMED))) %>%
  arrange(desc(int))

# TMED JOIN
joined_convencional_tmed_regiao <- convencional_tmed_regiao %>%
  left_join(convencional_tidy_regiao, by = c("NOME", "UF", "ano")) %>%
  rename("sum_temp" = `int.x`,
         "count_temp" = `int.y`) %>%
  filter(count_temp != "NA") %>%
  mutate(mean_temp = sum_temp / count_temp) %>%
  select(NOME, UF, regiao, ano, mean_temp) %>%
  group_by(regiao, ano) %>%
  summarise(sum_temp = sum(mean_temp),
            count_temp = n()) %>%
  mutate(mean_temp = sum_temp / count_temp) %>%
  select(regiao, ano, mean_temp) %>%
  spread(ano, mean_temp)


# Estação: CANARANA-MT

convencional_CANARANA_tmax <- convencional %>%
  separate(ANO, c("ano", "mes"), sep = "/") %>%
  filter(NOME == "CANARANA") %>%
  mutate(TMAX = str_replace_all(TMAX, "\\,", "\\.")) %>%
  group_by(NOME, UF, ano) %>%
  summarise(soma = sum(as.integer(TMAX)),
    contagem = n()) %>%
  filter(contagem > 10 & contagem < 13) %>%
  mutate(media = soma / contagem) %>%
  select(NOME, UF, ano, media)

write.csv(convencional_CANARANA_tmax, "convencional_CANARANA_tmax.csv")

convencional_CANARANA_tmin <- convencional %>%
  separate(ANO, c("ano", "mes"), sep = "/") %>%
  filter(NOME == "CANARANA") %>%
  mutate(TMIN = str_replace_all(TMIN, "\\,", "\\.")) %>%
  group_by(NOME, UF, ano) %>%
  summarise(soma = sum(as.integer(TMIN)),
            contagem = n()) %>%
  filter(contagem > 10 & contagem < 13) %>%
  mutate(media = soma / contagem) %>%
  select(NOME, UF, ano, media)

write.csv(convencional_CANARANA_tmin, "convencional_CANARANA_tmin.csv")

convencional_CANARANA_tmed <- convencional %>%
  separate(ANO, c("ano", "mes"), sep = "/") %>%
  filter(NOME == "CANARANA") %>%
  mutate(TMED = str_replace_all(TMED, "\\,", "\\.")) %>%
  group_by(NOME, UF, ano) %>%
  summarise(soma = sum(as.integer(TMED)),
            contagem = n()) %>%
  filter(contagem > 10 & contagem < 13) %>%
  mutate(media = soma / contagem) %>%
  select(NOME, UF, ano, media)

write.csv(convencional_CANARANA_tmed, "convencional_CANARANA_tmed.csv")

