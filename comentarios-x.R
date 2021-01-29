library(tidyverse)
library(rvest)
library(httr)
library(xml2)
library(RSelenium)
#install.packages("webdriver")
library(webdriver)
#webdriver::install_phantomjs()

### parte 1
url <- "https://www.xvideos.com/new/1"

links <- url %>%
  read_html() %>%
  html_nodes("a") %>%
  html_attr("href") %>%
  as.data.frame() %>%
  rename("link" = ".") %>%
  filter(str_detect(link, paste0("/video", "[0-9]"))) %>%
  distinct(link) %>%
  mutate(link = paste0("http://www.xvideos.com", link))

### parte 2
pjs <- run_phantomjs()
ses <- Session$new(port = pjs$port)

coleta <- function(i){
xvideos <- links$link[i]

ses$go(xvideos)
Sys.sleep(5)
ses$takeScreenshot()

botao <- ses$findElement(xpath = "//*[@class = 'thread-node-btn thread-node-children-load-all-btn']")
Sys.sleep(5)
botao$click()
Sys.sleep(5)
ses$takeScreenshot()  

conteudo_html <- ses$getSource()
setwd("~/Downloads/comentarios-x")
readr::write_file(conteudo_html, paste0("commentarios-x-", i, ".html"))
} 

map_dfr(1:length(links$link), coleta)

### parte 3
lista_html <- list.files(pattern = "*html") %>%
  map(read_html)

conteudo_html <- lista_html[[1]]
conteudo_html

comentarios <- conteudo_html %>%
  read_html() %>%
  html_nodes(".thread-node-message") %>%
  html_text()
  
usuario <- conteudo_html %>%
  read_html() %>%
  html_nodes(".thread-node-poster-name") %>%
  html_text()

usuario_url <- conteudo_html %>%
  read_html() %>%
  html_nodes(".thread-node-poster-name") %>%
  html_node("a") %>%
  html_attr("href")

data <- conteudo_html %>%
  read_html() %>%
  html_nodes(".thread-node-date") %>%
  html_attr("title") 
  
conteudo <- cbind(comentarios, usuario, usuario_url, data) %>%
  as.data.frame() %>%
  rbind()

