library(tidyverse)
library(data.table)
install.packages("textreadr")
library(textreadr)
library(rvest)

setwd("~/Downloads/fab-teste/2019")

list.files()

file_2019 <- read_html("Força Aérea Brasileira — Asas que protegem o país.htm")

file_2019

urls_2019 <- file_2019 %>%
  html_nodes("a") %>%
  html_attr("href") %>%
  as.data.frame() %>%
  `colnames<-`("link")

urls_voo_2019 <- urls_2019 %>%
  filter(str_detect(link, "fab.mil.br/cabine/voos/"))

View(urls_voo_2019)
### 
# 2018
###

setwd("~/Downloads/fab-teste/2018")

list.files()

file_2018 <- read_html("Força Aérea Brasileira — Asas que protegem o país.htm")

file_2018

urls_2018 <- file_2018 %>%
  html_nodes("a") %>%
  html_attr("href") %>%
  as.data.frame() %>%
  `colnames<-`("link")

urls_voo_2018 <- urls_2018 %>%
  filter(str_detect(link, "fab.mil.br/cabine/voos/"))

View(urls_voo_2018)
### 
# 2017
###

setwd("~/Downloads/fab-teste/2017")

list.files()

file_2017 <- read_html("Força Aérea Brasileira — Asas que protegem o país.htm")

file_2017

urls_2017 <- file_2017 %>%
  html_nodes("a") %>%
  html_attr("href") %>%
  as.data.frame() %>%
  `colnames<-`("link")

urls_voo_2017 <- urls_2017 %>%
  filter(str_detect(link, "fab.mil.br/cabine/voos/"))

View(urls_voo_2017)

### 
# 2016
###

setwd("~/Downloads/fab-teste/2016")

list.files()

file_2016 <- read_html("Força Aérea Brasileira — Asas que protegem o país.htm")

file_2016

urls_2016 <- file_2016 %>%
  html_nodes("a") %>%
  html_attr("href") %>%
  as.data.frame() %>%
  `colnames<-`("link")

urls_voo_2016 <- urls_2016 %>%
  filter(str_detect(link, "fab.mil.br/cabine/voos/"))

View(urls_voo_2016)

### 
# 2015
###

setwd("~/Downloads/fab-teste/2015")

list.files()

file_2015 <- read_html("Força Aérea Brasileira — Asas que protegem o país.htm")

file_2015

urls_2015 <- file_2015 %>%
  html_nodes("a") %>%
  html_attr("href") %>%
  as.data.frame() %>%
  `colnames<-`("link")

urls_voo_2015 <- urls_2015 %>%
  filter(str_detect(link, "fab.mil.br/cabine/voos/"))

View(urls_voo_2015)


### 
# 2014
###

setwd("~/Downloads/fab-teste/2014")

list.files()

file_2014 <- read_html("Força Aérea Brasileira — Asas que protegem o país.htm")

file_2014

urls_2014 <- file_2014 %>%
  html_nodes("a") %>%
  html_attr("href") %>%
  as.data.frame() %>%
  `colnames<-`("link")

urls_voo_2014 <- urls_2014 %>%
  filter(str_detect(link, "fab.mil.br/cabine/voos/"))

View(urls_voo_2014)


### 
# 2013
###

setwd("~/Downloads/fab-teste/2013")

list.files()

file_2013 <- read_html("Força Aérea Brasileira — Asas que protegem o país.htm")

file_2013

urls_2013 <- file_2013 %>%
  html_nodes("a") %>%
  html_attr("href") %>%
  as.data.frame() %>%
  `colnames<-`("link")

urls_voo_2013 <- urls_2013 %>%
  filter(str_detect(link, "fab.mil.br/cabine/voos/"))

View(urls_voo_2013)

###### empilhar
#### faltam 2017, 2018 e 2019

urls_voo <- bind_rows(urls_voo_2013, urls_voo_2014, urls_voo_2015,
                  urls_voo_2016, urls_voo_2017, urls_voo_2018,
                  urls_voo_2019)

dir.create("~/Downloads/PDFvoosFAB")
setwd("~/Downloads/PDFvoosFAB")

i <- 1

while(i < 1550) {
  tryCatch({
    pdf_file <- as.character(urls_voo$link[i], stringsAsFactors = FALSE)
    Sys.sleep(5)
    download.file(pdf_file, basename(pdf_file), mode = "wb")
    Sys.sleep(15)
  }, error = function(e) return(NULL)
  )
  i <- i + 1
}
