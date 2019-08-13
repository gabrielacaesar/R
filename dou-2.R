library(tidyverse)
library(rvest)
library(xml2)
library(janitor)
library(zoo)
library(abjutils)
library(data.table)

url1 <- "http://www.in.gov.br/consulta?q=%22Expulsar%20do%20territ%C3%B3rio%20nacional%22&publishFrom=2016-01-01&publishTo=2019-08-03&start=1&delta=75"
url2 <- "http://www.in.gov.br/consulta?q=%22Expulsar%20do%20territ%C3%B3rio%20nacional%22&publishFrom=2016-01-01&publishTo=2019-08-03&start=2&delta=75"
url3 <- "http://www.in.gov.br/consulta?q=%22Expulsar%20do%20territ%C3%B3rio%20nacional%22&publishFrom=2016-01-01&publishTo=2019-08-03&start=3&delta=75"
url4 <- "http://www.in.gov.br/consulta?q=%22Expulsar%20do%20territ%C3%B3rio%20nacional%22&publishFrom=2016-01-01&publishTo=2019-08-03&start=4&delta=75"
url5 <- "http://www.in.gov.br/consulta?q=%22Expulsar%20do%20territ%C3%B3rio%20nacional%22&publishFrom=2016-01-01&publishTo=2019-08-03&start=5&delta=75"
url6 <- "http://www.in.gov.br/consulta?q=%22Expulsar%20do%20territ%C3%B3rio%20nacional%22&publishFrom=2016-01-01&publishTo=2019-08-03&start=6&delta=75"
url7 <- "http://www.in.gov.br/consulta?q=%22Expulsar%20do%20territ%C3%B3rio%20nacional%22&publishFrom=2016-01-01&publishTo=2019-08-03&start=7&delta=75"
url8 <- "http://www.in.gov.br/consulta?q=%22Expulsar%20do%20territ%C3%B3rio%20nacional%22&publishFrom=2016-01-01&publishTo=2019-08-03&start=8&delta=75"

urls <- rbind(url1, url2, url3, url4, url5, url6, url7, url8)

conteudo <- NULL
i <- 1 

while(i < 9) {
  tryCatch({
  portaria <- as.character(urls[i])
  
  conteudo <- read_html(portaria) %>%
    html_nodes("a") %>%
    html_attr("href") %>%
    str_trim() %>%
    as.data.frame() %>%
    setnames(".", "link") %>%
    filter(stringr::str_detect(link, "in.gov.br/web/dou/")) %>%
    filter(!stringr::str_detect(link, "inheritRedirect=true")) %>%
    rbind(conteudo)
  }, error = function(e) return(NULL)
)
i <- i + 1
}

length(unique(conteudo$link))

########
j <- 1 

while(j < 600) {
  tryCatch({
  url_portaria <- as.character(conteudo$link[j])
  
  extracao_portaria <- read_html(url_portaria) %>%
    html_nodes("p.dou-paragraph") %>%
    html_text() %>%
    str_trim() %>%
    as.data.frame(stringsAsFactors = FALSE) %>%
    `colnames<-`("txt_portaria") %>%
    mutate(txt_portaria = toupper(txt_portaria)) %>%
    filter(txt_portaria != "") %>%
    mutate(conteudo_portaria = ifelse(str_detect(txt_portaria, "EXPULSA"), 
                               txt_portaria, NA)) %>%
    mutate(conteudo_portaria = na.locf(conteudo_portaria)) %>%
    filter(!str_detect(txt_portaria, "EXPULSA")) %>%
    mutate(url_portaria = url_portaria) %>%
    rbind(extracao_portaria)
  }, error = function(e) return(NULL)
  )
  j <- j + 1
}

length(unique(extracao_portaria$link))

##########