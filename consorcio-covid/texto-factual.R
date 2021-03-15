library(tidyverse)

# info DATA
dia_da_semana_EN <- weekdays(Sys.Date())
dia_da_semana_PT <- case_when(dia_da_semana_EN == "Monday" ~ "segunda-feira",
                              dia_da_semana_EN == "Tueday" ~ "terça-feira",
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
total_mortes <- "278.327"
mortes_24h <- "1.111"
media_mortes <- "1.832"
variacao_mortes <- "+50%"
tendencia_mortes <- case_when(parse_number(variacao_mortes) >= 15 ~ "alta",
                           parse_number(variacao_mortes) < 15 & parse_number(variacao_mortes) > -15 ~ "estabilidade",
                           parse_number(variacao_mortes) >= -15 ~ "queda")

# info CASOS
total_casos <- "11.483.031"
casos_24h <- "43.781"
media_casos <- "66.353"
variacao_casos <- "+18%"
tendencia_casos <- case_when(parse_number(variacao_casos) >= 15 ~ "alta",
                              parse_number(variacao_casos) < 15 & parse_number(variacao_casos) > -15 ~ "estabilidade",
                              parse_number(variacao_casos) >= -15 ~ "queda")
# PARAGRAFOS
texto_0 <- c("Brasil registra {mortes_24h} mortes em 24 horas")
texto_1 <- c("País contabilizou {total_casos} casos e {total_mortes} óbitos por Covid-19 desde o início da pandemia, segundo balanço do consórcio de veículos de imprensa. Casos e mortes apresentam tendência de alta.")
texto_2 <- c("O país registrou {mortes_24h} mortes pela Covid-19 nas últimas 24 horas e totalizou {neste_nesta} {dia_da_semana_PT} ({dia_hoje}) {total_mortes} óbitos. Com isso, a média móvel de mortes no Brasil nos últimos 7 dias chegou a {media_mortes}, novamente um recorde. Em comparação à média de 14 dias atrás, a variação foi de {variacao_mortes}, indicando tendência de {tendencia_mortes} nos óbitos pela doença.")
texto_3 <- c("É o que mostra novo levantamento do consórcio de veículos de imprensa sobre a situação da pandemia de coronavírus no Brasil a partir de dados das secretarias estaduais de Saúde, consolidados às 20h {deste_desta} {dia_da_semana_PT}.")
texto_4 <- c("Em casos confirmados, desde o começo da pandemia {total_casos} brasileiros já tiveram ou têm o novo coronavírus, com {casos_24h} desses confirmados no último dia. A média móvel nos últimos 7 dias foi de {media_casos} novos diagnósticos por dia. Isso representa uma variação de {variacao_casos} em relação aos casos registrados em duas semanas, o que indica tendência de {tendencia_casos} também nos diagnósticos.")
texto_5 <- c("Brasil, {dia_hoje} de {mes_hoje_string}
Total de mortes: {total_mortes}
Registro de mortes em 24 horas: {mortes_24h}
Média de novas mortes nos últimos 7 dias: {media_mortes} por dia (variação em 14 dias: {variacao_mortes})
Total de casos confirmados: {total_casos}
Registro de casos confirmados em 24 horas: {casos_24h}
Média de novos casos nos últimos 7 dias: {media_casos} por dia (variação em 14 dias: {variacao_casos})")

str_glue(texto_0)
str_glue(texto_1)
str_glue(texto_2)
str_glue(texto_3)
str_glue(texto_4)
str_glue(texto_5)
