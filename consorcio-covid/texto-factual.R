library(tidyverse)
library(readxl)
library(googledrive)

# pasta para DADOS - consorcio
dir.create(paste0("dados_consorcio_", Sys.Date()))
setwd(paste0("dados_consorcio_", Sys.Date()))

# download do XLSX - consorcio
drive_auth(email = "gabriela.caesar.g1@gmail.com")
drive_download(file = as_id("1qrzNw0_M5w45WlHpNT6k5I8YGaJTURyXbKIrxwbXuT0"), type = "xlsx")

# leitura do XLSX - consorcio
## ABA - BOLETIM
arquivo <- list.files()
boletim <- read_xlsx(arquivo, sheet = 'Boletim')
media_movel <- read_xlsx(arquivo, sheet = 6, skip = 1)

boletim_tidy <- boletim %>%
  janitor::clean_names() %>%
  filter(str_detect(x1, "MORTES|TESTES|DOSE")) %>%
  .[1:11, 1:2] %>%
  rename(tipo = x1, numero = x2) 

## ABA - MEDIA MOVEL CRITERIO
vezes_100 <- function(x){
  return(x * 100)
}

media_movel_tidy <- media_movel %>%
  janitor::clean_names() %>%
  filter(dia == Sys.Date()) %>%
  mutate_at(vars(-1), as.double) %>%
  mutate_at(vars(starts_with("variacao")), vezes_100) %>%
  pivot_longer(cols = -1, names_to = "tipo", values_to = "numero") %>%
  mutate_at(vars(numero), round) %>%
  pivot_wider(names_from = tipo, values_from = numero)

# TENDENCIA - UFs
tendencia_uf <- media_movel_tidy %>%
  pivot_longer(-1, names_to = "tipo", values_to = "numero") %>%
  filter(str_detect(tipo, "variacao_mortes_") & tipo != "variacao_mortes_br") %>%
  mutate(uf = toupper(str_sub(tipo, start = -2, end = -1))) %>%
  mutate(tendencia = case_when(numero > 15 ~ "alta",
                               numero <= 15 & numero >= -15 ~ "estabilidade",
                               numero < -15 ~ "queda"))

alta_n_uf <- tendencia_uf %>% filter(tendencia == "alta") %>% nrow()
estabilidade_n_uf <- tendencia_uf %>% filter(tendencia == "estabilidade") %>% nrow()
queda_n_uf <- tendencia_uf %>% filter(tendencia == "queda") %>% nrow()

alta_lista_uf <- tendencia_uf %>% filter(tendencia == "alta") %>% select(uf) 
estabilidade_lista_uf <- tendencia_uf %>% filter(tendencia == "estabilidade") %>% select(uf) 
queda_lista_uf <- tendencia_uf %>% filter(tendencia == "queda") %>% select(uf) 

# info DATA
dia_da_semana_EN <- weekdays(Sys.Date())
dia_da_semana_PT <- case_when(dia_da_semana_EN == "Monday" ~ "segunda-feira",
                              dia_da_semana_EN == "Tuesday" ~ "terça-feira",
                              dia_da_semana_EN == "Wednesday" ~ "quarta-feira",
                              dia_da_semana_EN == "Thursday" ~ "quinta-feira",
                              dia_da_semana_EN == "Friday" ~ "sexta-feira",
                              dia_da_semana_EN == "Saturday" ~ "sábado",
                              dia_da_semana_EN == "Sunday" ~ "domingo")
neste_nesta <- ifelse(dia_da_semana_PT == "sábado|domingo", "neste", "nesta")
deste_desta <- ifelse(dia_da_semana_PT == "sábado|domingo", "deste", "desta")
dia_hoje <- Sys.Date() %>% str_sub(start = -2, end = -1)
mes_hoje <- Sys.Date() %>% str_sub(start = 6, end = 7) 
mes_hoje_string <- case_when(mes_hoje == "01" ~ "janeiro",
                             mes_hoje == "02" ~ "fevereiro",
                             mes_hoje == "03" ~ "março",
                             mes_hoje == "04" ~ "abril",
                             mes_hoje == "05" ~ "maio",
                             mes_hoje == "06" ~ "junho",
                             mes_hoje == "07" ~ "julho",
                             mes_hoje == "08" ~ "agosto",
                             mes_hoje == "09" ~ "setembro",
                             mes_hoje == "10" ~ "outubro",
                             mes_hoje == "11" ~ "novembro",
                             mes_hoje == "12" ~ "dezembro")

# info MORTES
total_mortes <- boletim_tidy$numero[1]
mortes_24h <- boletim_tidy$numero[2]
media_mortes <- media_movel_tidy$media_movel_mortes_br
variacao_mortes <- media_movel_tidy$variacao_mortes_br
tendencia_mortes <- case_when(variacao_mortes > 15 ~ "alta",
                              variacao_mortes <= 15 & variacao_mortes >= -15 ~ "estabilidade",
                              variacao_mortes < -15 ~ "queda")

# info CASOS
total_casos <- boletim_tidy$numero[4]
casos_24h <- boletim_tidy$numero[5]
media_casos <- media_movel_tidy$media_movel_casos_br
variacao_casos <- media_movel_tidy$variacao_casos_br
tendencia_casos <- case_when(variacao_casos >= 15 ~ "alta",
                             variacao_casos <= 15 & variacao_casos >= -15 ~ "estabilidade",
                             variacao_casos < -15 ~ "queda")

# info / variacao mortes - lista UFs
variacao_PR <- media_movel_tidy$variacao_mortes_pr
variacao_RS <- media_movel_tidy$variacao_mortes_rs
variacao_SC <- media_movel_tidy$variacao_mortes_sc

variacao_ES <- media_movel_tidy$variacao_mortes_es
variacao_MG <- media_movel_tidy$variacao_mortes_mg
variacao_RJ <- media_movel_tidy$variacao_mortes_rj
variacao_SP <- media_movel_tidy$variacao_mortes_sp

variacao_DF <- media_movel_tidy$variacao_mortes_df
variacao_GO <- media_movel_tidy$variacao_mortes_go
variacao_MS <- media_movel_tidy$variacao_mortes_ms
variacao_MT <- media_movel_tidy$variacao_mortes_mt

variacao_AC <- media_movel_tidy$variacao_mortes_ac
variacao_AM <- media_movel_tidy$variacao_mortes_am
variacao_AP <- media_movel_tidy$variacao_mortes_ap
variacao_PA <- media_movel_tidy$variacao_mortes_pa
variacao_RO <- media_movel_tidy$variacao_mortes_ro
variacao_RR <- media_movel_tidy$variacao_mortes_rr
variacao_TO <- media_movel_tidy$variacao_mortes_to

variacao_AL <- media_movel_tidy$variacao_mortes_al
variacao_BA <- media_movel_tidy$variacao_mortes_ba
variacao_CE <- media_movel_tidy$variacao_mortes_ce
variacao_MA <- media_movel_tidy$variacao_mortes_ma
variacao_PB <- media_movel_tidy$variacao_mortes_pb
variacao_PE <- media_movel_tidy$variacao_mortes_pe
variacao_PI <- media_movel_tidy$variacao_mortes_pi
variacao_RN <- media_movel_tidy$variacao_mortes_rn
variacao_SE <- media_movel_tidy$variacao_mortes_se

# PARAGRAFOS
texto_0 <- c("Brasil registra {mortes_24h} mortes em 24 horas")
texto_1 <- c("País contabilizou {total_casos} casos e {total_mortes} óbitos por Covid-19 desde o início da pandemia, segundo balanço do consórcio de veículos de imprensa. Mortes apresentam tendência de {tendencia_mortes}; e casos, de {tendencia_casos}.")
texto_2 <- c("O país registrou {mortes_24h} mortes pela Covid-19 nas últimas 24 horas e totalizou {neste_nesta} {dia_da_semana_PT} ({dia_hoje}) {total_mortes} óbitos. Com isso, a média móvel de mortes no Brasil nos últimos 7 dias chegou a {media_mortes}, novamente um recorde. Em comparação à média de 14 dias atrás, a variação foi de {variacao_mortes}%, indicando tendência de {tendencia_mortes} nos óbitos pela doença.")
texto_3 <- c("É o que mostra novo levantamento do consórcio de veículos de imprensa sobre a situação da pandemia de coronavírus no Brasil a partir de dados das secretarias estaduais de Saúde, consolidados às 20h {deste_desta} {dia_da_semana_PT}.")
texto_4 <- c("Em casos confirmados, desde o começo da pandemia {total_casos} brasileiros já tiveram ou têm o novo coronavírus, com {casos_24h} desses confirmados no último dia. A média móvel nos últimos 7 dias foi de {media_casos} novos diagnósticos por dia. Isso representa uma variação de {variacao_casos}% em relação aos casos registrados em duas semanas, o que indica tendência de {tendencia_casos} também nos diagnósticos.")
texto_5 <- c("Brasil, {dia_hoje} de {mes_hoje_string}
Total de mortes: {total_mortes}
Registro de mortes em 24 horas: {mortes_24h}
Média de novas mortes nos últimos 7 dias: {media_mortes} por dia (variação em 14 dias: {variacao_mortes}%)
Total de casos confirmados: {total_casos}
Registro de casos confirmados em 24 horas: {casos_24h}
Média de novos casos nos últimos 7 dias: {media_casos} por dia (variação em 14 dias: {variacao_casos}%)")
texto_6 <- c("Sul
PR: {variacao_PR}%
RS: {variacao_RS}%
SC: {variacao_SC}%
Sudeste
ES: {variacao_ES}%
MG: {variacao_MG}%
RJ: {variacao_RJ}%
SP: {variacao_SP}%
Centro-Oeste
DF: {variacao_DF}%
GO: {variacao_GO}%
MS: {variacao_MS}%
MT: {variacao_MT}%
Norte
AC: {variacao_AC}%
AM: {variacao_AM}%
AP: {variacao_AP}%
PA: {variacao_PA}%
RO: {variacao_RO}%
RR: {variacao_RR}%
TO: {variacao_TO}%
Nordeste
AL: {variacao_AL}%
BA: {variacao_BA}%
CE: {variacao_CE}%
MA: {variacao_MA}%
PB: {variacao_PB}%
PE: {variacao_PE}%
PI: {variacao_PI}%
RN: {variacao_RN}%
SE: {variacao_SE}%")
texto_7 <- c("Estados
Subindo ({alta_n_uf} estados): {alta_lista_uf}
Em estabilidade ({estabilidade_n_uf} estados): {estabilidade_lista_uf}
Em queda ({queda_n_uf} estados): {queda_lista_uf}")

# GLUUUUUUE
str_glue(texto_0)
str_glue(texto_1)
str_glue(texto_2)
str_glue(texto_3)
str_glue(texto_4)
str_glue(texto_5)
str_glue(texto_7)
str_glue(texto_6)
