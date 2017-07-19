install.packages(c("tidyverse", "stringr", "rvest"))


library(tidyverse)
library(rvest)
library(stringr)

library(dplyr)


site <- "http://www.imdb.com/search/title?year=2016,2016&title_type=feature&sort=moviemeter,asc"

ler_site <- read_html(site)

notas_html <- html_nodes(ler_site, ".text-primary")
head(notas_html)

notas <- html_text(notas_html)
head(notas)

str(notas)
notas <- as.integer(notas)
head(notas)

titulos_html <- html_nodes(ler_site, ".lister-item-header a")
head(titulos_html)

titulos <- html_text(titulos_html)
head(titulos)

descricoes_html <- html_nodes(ler_site, ".ratings-bar+ .text-muted")
head(descricoes_html)

descricoes <- html_text(descricoes_html)
head(descricoes)

descricoes <- str_replace_all(descricoes, "^\n", "")
head(descricoes)

base_dados <- data.frame(notas, titulos, descricoes)
View(base_dados)


