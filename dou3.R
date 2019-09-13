library(tidyverse)
library(rvest)
library(xml2)
library(zoo)

url <- "http://www.in.gov.br/consulta?q=%22Declarar%20a%20perda%20da%20nacionalidade%20brasileira%22&publishFrom=2017-01-01&publishTo=2019-09-12&delta=75"


conteudo <- read_html(url) %>%
  html_nodes("a") %>%
  html_attr("href") %>%
  str_trim() %>%
  as.data.frame() %>%
  `colnames<-`("urls")

conteudo_urls <- conteudo %>%
  filter(str_detect(urls, "web/dou/")) %>%
  filter(!str_detect(urls, "inheritRedirect"))

i <- 1

while(i < 55) {
  tryCatch({
url_portaria <- as.character(conteudo_urls$urls[i])

extracao_portaria <- read_html(url_portaria) %>%
  html_nodes("p.dou-paragraph") %>%
  html_text() %>%
  str_trim() %>%
  as.data.frame(stringsAsFactors = FALSE) %>%
  `colnames<-`("txt_portaria") %>%
  mutate(txt_portaria = toupper(txt_portaria)) %>%
  filter(txt_portaria != "") %>%
  mutate(conteudo_portaria = ifelse(str_detect(txt_portaria, "DECLARAR A PERDA"), 
                                    txt_portaria, NA)) %>%
  fill(conteudo_portaria, .direction = "down") %>%
  filter(!str_detect(txt_portaria, "DECLARAR A PERDA"),
         !str_detect(txt_portaria, "COORDENADOR DE PROCESSOS"),
         !str_detect(txt_portaria, "SECRETÁRIA NACIONAL"),
         !str_detect(txt_portaria, "MINISTRO DE ESTADO"),
         !str_detect(txt_portaria, "SECRETÁRIO NACIONAL"),
         !str_detect(txt_portaria, "EXPULSAR")) %>%
  mutate(url_portaria = url_portaria) %>%
  rbind(extracao_portaria)
  }, error = function(e) return(NULL)
  )
  i <- i + 1
}

extracao_portaria <- NULL

# acima temos 44 de 51 urls
# impedir inclusao de concessoes