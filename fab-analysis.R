

library(tidyverse)
library(data.table)
library(abjutils)
library(lubridate)

consolidado_fab <- fread("C:/Users/acaesar/Downloads/consolidado-fab-2.csv", encoding="UTF-8")

colnames(consolidado_fab)

tidy_fab <- consolidado_fab %>%
  rename("autoridades_apoiadas" = `AUTORIDADES APOIADAS`) %>%
  mutate(autoridades_apoiadas_upper = str_trim(toupper(rm_accent(autoridades_apoiadas))),
         autoridades_apoiadas_upper = str_remove_all(autoridades_apoiadas_upper, "\\(1\\)"),
         autoridades_apoiadas_upper = str_remove_all(autoridades_apoiadas_upper, "\\(2\\)"),
         autoridades_apoiadas_upper = str_remove_all(autoridades_apoiadas_upper, "\\(3\\)"),
         autoridades_apoiadas_upper = str_remove_all(autoridades_apoiadas_upper, "\\(4\\)"),
         autoridades_apoiadas_upper = str_remove_all(autoridades_apoiadas_upper, "\\."),
         autoridades_apoiadas_upper = str_replace_all(autoridades_apoiadas_upper, "A DISPOSICAO DO COMANDO DA AERONAUTICA", "COMANDANTE DA AERONAUTICA"),
         autoridades_apoiadas_upper = str_trim(autoridades_apoiadas_upper)) %>%
  mutate(interino_ou_nao = ifelse(str_detect(autoridades_apoiadas_upper, "INTERINO"), "sim", "nao")) 

# quem viajou mais em 2019
tidy_fab_2019 <- tidy_fab %>%
  filter(decolagem_ano == "2019") %>%
  group_by(autoridades_apoiadas_upper, interino_ou_nao) %>%
  summarise(int = n()) %>%
  arrange(desc(int))

# idem 2018
tidy_fab_2018 <- tidy_fab %>%
  filter(decolagem_ano == "2018") %>%
  group_by(autoridades_apoiadas_upper, interino_ou_nao) %>%
  summarise(int = n()) %>%
  arrange(desc(int))

# quais foram as cidades mais frequentes em 2019
# quais foram as ponte-aéreas mais frequentes em 2019
trajeto_2019 <- tidy_fab %>%
  filter(decolagem_ano == "2019") %>%
  unite("trajeto", "origem", "destino", sep = " - ") %>%
  group_by(trajeto) %>%
  summarise(int = n()) %>%
  arrange(desc(int))

# para onde as autoridades mais viajantes foram
viajantes_2019 <- tidy_fab %>%
  filter(decolagem_ano == "2019") %>%
  filter(autoridades_apoiadas_upper == "PRESIDENTE DA CAMARA DOS DEPUTADOS" | 
          autoridades_apoiadas_upper == "MINISTRO DAS RELACOES EXTERIORES" |
          autoridades_apoiadas_upper == "MINISTRO DA CIDADANIA" |
          autoridades_apoiadas_upper == "MINISTRO DO MEIO AMBIENTE") %>%
  unite("trajeto", "origem", "destino", sep = " - ") %>%
  group_by(autoridades_apoiadas_upper, trajeto) %>%
  summarise(int = n()) %>%
  arrange(desc(int))

# quantas horas de voo em 2019
# NAO É POSSÍVEL FAZER POR CAUSA DO FUSO HORÁRIO
# ALGUNS HORÁRIOS NÃO BATEM DIREITO
voos_2019 <- tidy_fab %>%
  filter(decolagem_ano == "2019") %>%
  unite("decolagem_data", "decolagem_dia", "decolagem_mes", "decolagem_ano", sep = "/") %>%
  unite("decolagem_data", "decolagem_data", "decolagem_hora", sep = " ") %>%
  unite("pouso_data", "pouso_dia", "pouso_mes", "pouso_ano", sep = "/") %>%
  unite("pouso_data", "pouso_data", "pouso_hora", sep = " ") %>%
  mutate(duracao_voo = difftime(dmy_hm(pouso_data), dmy_hm(decolagem_data), units = "mins"))

# calcular a quilometragem por trecho

