library(tidyverse)
library(rvest)
# install.packages(downloader)
library(downloader)

setwd("~/Downloads/teste")

url <- "http://www.fab.mil.br/voos"

urls <- url %>%
  read_html() %>%
  html_nodes("a") %>%
  html_attr("href") %>%
  as.data.frame() %>%
  `colnames<-`("link")

urls_voo <- urls %>%
  filter(str_detect(link, "fab.mil.br/cabine/voos/"))

#for (url_voo in urls_voo){
#  teste <- as.character(urls_voo$link[url_voo], stringsAsFactors = FALSE)
#  Sys.sleep(15)
#  download.file(teste, basename(teste), mode = "wb")
#  Sys.sleep(30)
#} 

i <- 1

while(i < 142) {
  tryCatch({
    pdf_file <- as.character(urls_voo$link[i], stringsAsFactors = FALSE)
    Sys.sleep(2)
    download.file(pdf_file, basename(pdf_file), mode = "wb")
    Sys.sleep(5)
  }, error = function(e) return(NULL)
  )
  i <- i + 1
}

#################################################
#### ler as tabelas do PDF e empilha-las     ####
#################################################

# install.packages("tabulizer")
library(tabulizer)
# install.packages("pdftools")
library(pdftools)

files <- list.files(pattern = "*.pdf") 


