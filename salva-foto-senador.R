install.packages("RCUrl")

library(data.table) # necessário
library(rvest)
library(lubridate)
library(stringr)
library(dplyr)
library(RCurl) # necessário
library(XML) # idem
library(httr)
library(purrr)
# link que contém todos os senadores em exercício
url <- "https://www25.senado.leg.br/web/senadores/em-exercicio/-/e/por-nome"


# get all url on the webpage
url2 <- getURL(url)
parsed <- htmlParse(url2)
links <- xpathSApply(parsed,path = "//a",xmlGetAttr,"href")

links <- do.call(rbind.data.frame, links) 

colnames(links)[1] <- "links" 


# filtering to get the urls of the senators
links_senador <- links %>%
  filter(links %like% "/senadores/senador/")

links_senador <- data.frame(links_senador)


# creating a new directory for the pics
setwd("~/Downloads/")
dir.create("senadores-new")
setwd("~/Downloads/senadores-new")


######################### loop
  
i <- 1
while(1 <= 81){
  tryCatch({
# defining the row of each senator
  foto_webpage <- data.frame(links_senador$links[i])
# renaming the column's name
  colnames(foto_webpage) <- "links" 
# getting all images of html page
# filtering the photo which we want
  html <- as.character(foto_webpage$links) %>%
    httr::GET() %>%
    xml2::read_html() %>%
    rvest::html_nodes("img") %>%
    map(xml_attrs) %>%
    map_df(~as.list(.)) %>%
    filter(src %like% "senadores/img/fotos-oficiais/") %>%
    as.data.frame(html)
# downloading the photo
    foto_senador <- html$src
    download.file(foto_senador, basename(foto_senador), mode = "wb", header = TRUE)
    Sys.sleep(5)
  }, error = function(e) return(NULL)
  )
  i <- i + 1
}
