library(tidyverse)
library(data.table)
library(XML)
library(abjutils)
library(stringi)

setwd("~/Downloads/")

list <- fread("min_PR_tidy_min-lista_cargos-7fev2020.csv")
url <- "http://dadosabertos.presidencia.gov.br/dataset/e00e5081-b47e-479f-a6e2-f4419207a69e/resource/4f9f4f64-6e13-47bf-a65a-0a5b62c8f03e/download/agendas-2019.xml"

min_PR <- xmlParse(url, encoding = "Latin-1") %>%
        xmlToDataFrame()

min_PR_tidy <- min_PR %>%
  select(data, tipo, titulo, descricao, local, texto) %>%
  filter(!is.na(tipo)) %>%
  separate(data, c("dia", "mes", "ano"), sep = "/") %>%
  mutate(texto_2 = toupper(rm_accent(texto)),
         texto_2 = str_replace_all(texto_2, "WAGNER DE CAMPOS ROSARIO", "WAGNER ROSARIO"))

## CONTAGEM DE OCORRENCIAS
min_PR_tidy_min <- min_PR_tidy

min_PR_tidy_min$moroCount <- stri_count_fixed(min_PR_tidy_min$texto_2, "SERGIO MORO")
min_PR_tidy_min$guedesCount <- stri_count_fixed(min_PR_tidy_min$texto_2, "PAULO GUEDES")
min_PR_tidy_min$weintraubCount <- stri_count_fixed(min_PR_tidy_min$texto_2, "ABRAHAM WEINTRAUB")
min_PR_tidy_min$pontesCount <- stri_count_fixed(min_PR_tidy_min$texto_2, "MARCOS PONTES")
min_PR_tidy_min$ramosCount <- stri_count_fixed(min_PR_tidy_min$texto_2, "LUIZ EDUARDO RAMOS")
min_PR_tidy_min$oliveiraCount <- stri_count_fixed(min_PR_tidy_min$texto_2, "JORGE ANTONIO DE OLIVEIRA")

min_PR_tidy_min$onyxCount <- stri_count_fixed(min_PR_tidy_min$texto_2, "ONYX LORENZONI")
min_PR_tidy_min$augustoCount <- stri_count_fixed(min_PR_tidy_min$texto_2, "AUGUSTO HELENO")
min_PR_tidy_min$ernestoCount <- stri_count_fixed(min_PR_tidy_min$texto_2, "ERNESTO ARAUJO")
min_PR_tidy_min$azevedoCount <- stri_count_fixed(min_PR_tidy_min$texto_2, "FERNANDO AZEVEDO")
min_PR_tidy_min$bentoCount <- stri_count_fixed(min_PR_tidy_min$texto_2, "BENTO ALBUQUERQUE")
min_PR_tidy_min$sallesCount <- stri_count_fixed(min_PR_tidy_min$texto_2, "RICARDO SALLES")
min_PR_tidy_min$osmarCount <- stri_count_fixed(min_PR_tidy_min$texto_2, "OSMAR TERRA")
min_PR_tidy_min$terezaCount <- stri_count_fixed(min_PR_tidy_min$texto_2, "TEREZA CRISTINA")
min_PR_tidy_min$mandettaCount <- stri_count_fixed(min_PR_tidy_min$texto_2, "LUIZ HENRIQUE MANDETTA")
min_PR_tidy_min$damaresCount <- stri_count_fixed(min_PR_tidy_min$texto_2, "DAMARES ALVES")
min_PR_tidy_min$marceloCount <- stri_count_fixed(min_PR_tidy_min$texto_2, "MARCELO ALVARO ANTONIO")
min_PR_tidy_min$canutoCount <- stri_count_fixed(min_PR_tidy_min$texto_2, "GUSTAVO CANUTO")

min_PR_tidy_min$wagnerCount <- stri_count_fixed(min_PR_tidy_min$texto_2, "WAGNER ROSARIO")
min_PR_tidy_min$tarcisioCount <- stri_count_fixed(min_PR_tidy_min$texto_2, "TARCISIO GOMES DE FREITAS")
min_PR_tidy_min$robertoCount <- stri_count_fixed(min_PR_tidy_min$texto_2, "ROBERTO CAMPOS")
min_PR_tidy_min$andreCount <- stri_count_fixed(min_PR_tidy_min$texto_2, "ANDRE LUIZ DE ALMEIDA")
min_PR_tidy_min$bebiannoCount <- stri_count_fixed(min_PR_tidy_min$texto_2, "GUSTAVO BEBIANNO")
min_PR_tidy_min$florianoCount <- stri_count_fixed(min_PR_tidy_min$texto_2, "FLORIANO")
min_PR_tidy_min$velezCount <- stri_count_fixed(min_PR_tidy_min$texto_2, "RICARDO VELEZ")
min_PR_tidy_min$santosCruzCount <- stri_count_fixed(min_PR_tidy_min$texto_2, "SANTOS CRUZ")

min_PR_tidy_min_new <- min_PR_tidy_min %>%
  select(1:3, 10:35) %>%
  gather("ministro", "int", 4:29) %>%
  group_by(ministro) %>%
  summarise(soma = sum(int))


## FAMILIA E OUTROS
min_PR_tidy_outros <- min_PR_tidy

min_PR_tidy_outros$marinhoCount <- stri_count_fixed(min_PR_tidy_outros$texto_2, "ROGERIO MARINHO")
min_PR_tidy_outros$eduardoCount <- stri_count_fixed(min_PR_tidy_outros$texto_2, "EDUARDO BOLSONARO")
min_PR_tidy_outros$flavioCount <- stri_count_fixed(min_PR_tidy_outros$texto_2, "FLAVIO BOLSONARO")
min_PR_tidy_outros$carlosCount <- stri_count_fixed(min_PR_tidy_outros$texto_2, "CARLOS BOLSONARO")

min_PR_tidy_outros_new <- min_PR_tidy_outros %>%
  select(1:3, 9:13) %>%
  gather("outros", "int", 5:8) %>%
  group_by(mes, outros) %>%
  summarise(soma = sum(int))

## CONGRESSO
min_PR_tidy_congresso <- min_PR_tidy

min_PR_tidy_congresso$maiaCount <- stri_count_fixed(min_PR_tidy_congresso$texto_2, "RODRIGO MAIA")
min_PR_tidy_congresso$alcolumbreCount <- stri_count_fixed(min_PR_tidy_congresso$texto_2, "DAVI ALCOLUMBRE")
min_PR_tidy_congresso$joiceCount <- stri_count_fixed(min_PR_tidy_congresso$texto_2, "JOICE HASSELMANN")
min_PR_tidy_congresso$waldirCount <- stri_count_fixed(min_PR_tidy_congresso$texto_2, "DELEGADO WALDIR")
min_PR_tidy_congresso$felicianoCount <- stri_count_fixed(min_PR_tidy_congresso$texto_2, "MARCO FELICIANO")
min_PR_tidy_congresso$bezerraCount <- stri_count_fixed(min_PR_tidy_congresso$texto_2, "FERNANDO BEZERRA")
min_PR_tidy_congresso$eduardoCount <- stri_count_fixed(min_PR_tidy_congresso$texto_2, "EDUARDO GOMES")
min_PR_tidy_congresso$chicoCount <- stri_count_fixed(min_PR_tidy_congresso$texto_2, "CHICO RODRIGUES")
min_PR_tidy_congresso$vitorCount <- stri_count_fixed(min_PR_tidy_congresso$texto_2, "VITOR HUGO")

min_PR_tidy_congresso_new <- min_PR_tidy_congresso %>%
  select(1:3, 10:18) %>%
  gather("congressista", "int", 4:12) %>%
  group_by(mes, congressista) %>%
  summarise(soma = sum(int))


## EXTRA

min_PR_tidy_extra <- min_PR_tidy

min_PR_tidy_extra$ustraCount <- stri_count_fixed(min_PR_tidy_extra$texto_2, "USTRA")
min_PR_tidy_extra$hangCount <- stri_count_fixed(min_PR_tidy_extra$texto_2, "LUCIANO HANG")
min_PR_tidy_extra$kufaCount <- stri_count_fixed(min_PR_tidy_extra$texto_2, "KARINA KUFA")
min_PR_tidy_extra$hypolitoCount <- stri_count_fixed(min_PR_tidy_extra$texto_2, "DIEGO HYPOLITO")
min_PR_tidy_extra$marroneCount <- stri_count_fixed(min_PR_tidy_extra$texto_2, "BRUNO E MARRONE")
min_PR_tidy_extra$fragaCount <- stri_count_fixed(min_PR_tidy_extra$texto_2, "ALBERTO FRAGA")

## GOVERNADORES

min_PR_tidy_gov <- min_PR_tidy

min_PR_tidy_gov$witzelCount <- stri_count_fixed(min_PR_tidy_gov$texto_2, "WITZEL")
min_PR_tidy_gov$doriaCount <- stri_count_fixed(min_PR_tidy_gov$texto_2, "JOAO DORIA")
min_PR_tidy_gov$zemaCount <- stri_count_fixed(min_PR_tidy_gov$texto_2, "ROMEU ZEMA")
min_PR_tidy_gov$casagrandeCount <- stri_count_fixed(min_PR_tidy_gov$texto_2, "RENATO CASAGRANDE") # ZERO?

min_PR_tidy_gov$leiteCount <- stri_count_fixed(min_PR_tidy_gov$texto_2, "EDUARDO LEITE")
min_PR_tidy_gov$ratinhoCount <- stri_count_fixed(min_PR_tidy_gov$texto_2, "RATINHO")
min_PR_tidy_gov$moisesCount <- stri_count_fixed(min_PR_tidy_gov$texto_2, "CARLOS MOISES") # zero?

min_PR_tidy_gov$caiadoCount <- stri_count_fixed(min_PR_tidy_gov$texto_2, "RONALDO CAIADO")
min_PR_tidy_gov$azambujaCount <- stri_count_fixed(min_PR_tidy_gov$texto_2, "AZAMBUJA")
min_PR_tidy_gov$mauroCount <- stri_count_fixed(min_PR_tidy_gov$texto_2, "MAURO MENDES")
min_PR_tidy_gov$ibaneisCount <- stri_count_fixed(min_PR_tidy_gov$texto_2, "IBANEIS ROCHA")

min_PR_tidy_gov$helderCount <- stri_count_fixed(min_PR_tidy_gov$texto_2, "HELDER BARBALHO")
min_PR_tidy_gov$marcosCount <- stri_count_fixed(min_PR_tidy_gov$texto_2, "MARCOS ROCHA")
min_PR_tidy_gov$denariumCount <- stri_count_fixed(min_PR_tidy_gov$texto_2, "ANTONIO DENARIUM")
min_PR_tidy_gov$carlesseCount <- stri_count_fixed(min_PR_tidy_gov$texto_2, "MAURO CARLESSE")
min_PR_tidy_gov$wilsonCount <- stri_count_fixed(min_PR_tidy_gov$texto_2, "WILSON LIMA")
min_PR_tidy_gov$waldezCount <- stri_count_fixed(min_PR_tidy_gov$texto_2, "WALDEZ GOES")
min_PR_tidy_gov$gladsonCount <- stri_count_fixed(min_PR_tidy_gov$texto_2, "GLADSON CAMELI")

min_PR_tidy_gov$renanCount <- stri_count_fixed(min_PR_tidy_gov$texto_2, "RENAN FILHO")
min_PR_tidy_gov$ruiCount <- stri_count_fixed(min_PR_tidy_gov$texto_2, "RUI COSTA")
min_PR_tidy_gov$camiloCount <- stri_count_fixed(min_PR_tidy_gov$texto_2, "CAMILO SANTANA")
min_PR_tidy_gov$dinoCount <- stri_count_fixed(min_PR_tidy_gov$texto_2, "FLAVIO DINO")
min_PR_tidy_gov$azevedoCount <- stri_count_fixed(min_PR_tidy_gov$texto_2, "JOAO AZEVEDO")
min_PR_tidy_gov$camaraCount <- stri_count_fixed(min_PR_tidy_gov$texto_2, "PAULO CAMARA")
min_PR_tidy_gov$wellingtonCount <- stri_count_fixed(min_PR_tidy_gov$texto_2, "WELLINGTON DIAS")
min_PR_tidy_gov$bezerraCount <- stri_count_fixed(min_PR_tidy_gov$texto_2, "FATIMA BEZERRA")
min_PR_tidy_gov$belivaldoCount <- stri_count_fixed(min_PR_tidy_gov$texto_2, "BELIVALDO CHAGAS")

# OBS: 9 de maio de 2019 - evento com varios governadores do NE
# CAIADO é o mais próximo

min_PR_tidy_gov_new <- min_PR_tidy_gov %>%
  select(1:3, 10:36) %>%
  gather("governador", "int", 4:30) %>%
  group_by(governador) %>%
  summarise(soma = sum(int))


# prefeitos e vereadores principalmente de RS (?)

