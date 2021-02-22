library(tidyverse)
library(rvest)

## ssp url
url <- "http://www.ssp.sp.gov.br/Estatistica/ViolenciaMulher.aspx"

## mes
mes <- url %>%
  read_html() %>%
  html_nodes(xpath = "//*[@class='table-responsive']/preceding-sibling::div") %>%
  html_nodes("span") %>%
  html_text() %>%
  as.data.frame() %>%
  rename("mes" = ".") %>%
  mutate(mes = str_remove_all(mes, "Ocorrências Registradas no mês: "),
         table_id = row_number()) %>%
  mutate(mes = str_replace_all(mes, "Janeiro de ", "01/"),
         mes = str_replace_all(mes, "Fevereiro de ",  "02/"),
         mes = str_replace_all(mes, "Março de ", "03/"),
         mes = str_replace_all(mes, "Abril de ", "04/"),
         mes = str_replace_all(mes, "Maio de ", "05/"),
         mes = str_replace_all(mes, "Junho de ", "06/"),
         mes = str_replace_all(mes, "Julho de ", "07/"),
         mes = str_replace_all(mes, "Agosto de ", "08/"),
         mes = str_replace_all(mes, "Setembro de ", "09/"),
         mes = str_replace_all(mes, "Outubro de ", "10/"),
         mes = str_replace_all(mes, "Novembro de ", "11/"),
         mes = str_replace_all(mes, "Dezembro de ", "12/")) %>%
  separate(mes, c("mes", "ano"), sep = "/")
  
## tabela
tabela_count <- url %>%
  read_html() %>%
  html_table() %>%
  length()

get_tabela <- function(x){
  url %>%
  read_html() %>%
  html_table() %>%
  .[[x]] %>%
  as.data.frame() %>%
  rename("crime" = "") %>%
  janitor::clean_names() %>%
  mutate(table_id = x)
}

all_tabela <- map_dfr(1:tabela_count, get_tabela)

## joining data
dados <- all_tabela %>%
  left_join(mes, by = "table_id")

# dir.create(paste0("~/Downloads/SSP_data", Sys.Date()))
# setwd(paste0("~/Downloads/SSP_data", Sys.Date()))
# write.csv(dados, paste0("dados", Sys.Date(), Sys.time(), ".csv"))

## EXTRA / EXTRA
# filtering crime and date 

dados_por_crime <- dados %>%
  filter(ano == "2019" | ano ==  "2020") %>%
  filter(mes %in% c("01", "02", "03", "04", "05", "06")) %>%
  filter(crime %in% c("ESTUPRO CONSUMADO", "ESTUPRO DE VULNERÁVEL CONSUMADO", "LESÃO CORPORAL DOLOSA", "FEMINICÍDIO", "HOMICÍDIO DOLOSO (exclui FEMINICÍDIO)")) %>%
  group_by(crime, ano) %>%
  summarize(soma = sum(total)) %>%
  pivot_wider(names_from = ano, values_from = soma)

dados_por_crime
  
