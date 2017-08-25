#Carrega pacotes
install.packages(c("tidyverse", "stringr", "rvest"))
install.packages("haven")
library(haven)

library(dplyr)

install.packages("janitor")
library(janitor)

install.packages("ggplot2")
library(ggplot2)

#Seleciona o arquivo
base_wvs <- read_spss("/Users/anagabrielacaesar/Documents/WV6_Data_Brasil_2014_spss_v_2015-04-18.sav")

escala <- base_wvs %>%
select(V95)

tabula <- escala %>%
tabyl(V95)

tabula %>%
  mutate(V95 = as_factor(V95)) %>%
  ggplot(aes(V95,percent)) + geom_bar(stat="identity") + coord_flip()

