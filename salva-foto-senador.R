install.packages("RCUrl")

library(data.table) # necessário
library(rvest)
library(lubridate)
library(stringr)
library(RCurl) # necessário
library(XML) # idem
# link que contém todos os deputados em exercício
url <- "https://www25.senado.leg.br/web/senadores/em-exercicio/-/e/por-nome"


# get all url on the webpage
url2 <- getURL(url)
parsed <- htmlParse(url2)
links <- xpathSApply(parsed,path = "//a",xmlGetAttr,"href")

links <- do.call(rbind.data.frame, links) 

colnames(links)[1] <- "links" 



