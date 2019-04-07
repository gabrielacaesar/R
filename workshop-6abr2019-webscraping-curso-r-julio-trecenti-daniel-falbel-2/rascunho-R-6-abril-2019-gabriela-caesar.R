##################################
##           curso-R            ##
##         webscraping          ##
##    https://ws.curso-r.com    ##
##                              ##
##        gabriela caesar       ##
##   SP - 6 de abril de 2019    ##
##                              ##
##                              ##
##################################


library(tidyverse)
library(rvest)
library(webdriver)
library(abjutils)
library(magrittr)
library(janitor)

url <- "https://www.chancedegol.com.br/br17.htm"

r <- httr::GET(url)

r %>%
  xml2::read_html() %>%
  rvest::html_table() %>%
  dplyr::first() %>%
  janitor::clean_names() %>%
  tibble::as.tibble()

summary(r)

#######################









