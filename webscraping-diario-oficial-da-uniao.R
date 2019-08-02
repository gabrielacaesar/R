library(tidyverse)
library(rvest)
library(xml2)
library(janitor)

# coleta de links de portarias

url <- "http://www.in.gov.br/consulta?q=%22CONCEDER%20a%20nacionalidade%20brasileira%22&publishFrom=2019-01-01&publishTo=2019-07-31"

urls_portaria <- url %>%
  read_html() %>%
  html_nodes("a") %>%
  html_attr("href") %>%
  as.data.frame() %>%
  `colnames<-`("links") %>%
  filter(str_detect(links, "http://www.in.gov.br/web/dou/")) %>%
  ungroup()

# coleta de conteúdo das portarias

portaria <- as.character(urls_portaria$links[1])

data_conteudo <- read_html(portaria) %>%
  html_nodes("p.identifica") %>%
  html_text() %>%
  str_trim()

conteudo <- read_html(portaria) %>%
  html_nodes("p.dou-paragraph") %>%
  html_text() %>%
  str_trim() %>%
  as.data.frame(stringsAsFactors = FALSE) %>%
  `colnames<-`("conteudo") %>%
  filter(!conteudo == "") %>%
  mutate(data = data_conteudo) %>%
  mutate(n_portaria = ifelse(str_detect(conteudo, "Nº"), 
                             conteudo, "NA")
