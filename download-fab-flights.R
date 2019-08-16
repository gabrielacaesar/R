library(tidyverse)
library(rvest)
#install.packages("downloader")
library(downloader)

dir.create("~/Downloads/PDFvoosFAB")
setwd("~/Downloads/PDFvoosFAB")

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

# empilhar PDFs e converter em site
# https://www.pdftoexcel.com/
files <- list.files(pattern = "*.pdf") 

teste_merged_2 <- pdf_combine(files[1:50], output = "joined.pdf")
teste_merged_2 <- pdf_combine(files[50:100], output = "joined.pdf")
teste_merged_2 <- pdf_combine(files[101:141], output = "joined.pdf")


