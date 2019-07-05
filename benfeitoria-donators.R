# get list of donators of benfeitoria
# after downloading the html file and keeping the donators part

library(tidyverse)
library(rvest)
library(xml2)

setwd("~/Downloads/")

df <- read_html("doadores.html", encoding = "UTF-8")

donators <- df %>%
  html_nodes("a") %>%
  html_attr("title") 

final <- as.data.frame(donators) %>%
  arrange(donators)

write.csv(final, "final.csv")
