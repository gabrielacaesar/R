library(tidyverse)
library(rvest)

url <- c(paste0("http://www.ssp.sp.gov.br/Estatistica/plantrim/2020-0", 
              1:4,
              ".htm"),
         paste0("http://www.ssp.sp.gov.br/Estatistica/plantrim/2019-0", 
              1:4,
              ".htm"))

get_crimes <- function(i){
  url[i] %>%
  read_html() %>%
  html_table(fill = TRUE) %>%
  as.data.frame() %>%
  filter(!str_detect(X1, "Comunicado|Lei|Resolução|01Trim20")) %>%
  filter(X2 != "") %>%
  `colnames<-`(c("item", "crime", "capital", "grande sp",
                "interior", "deinter_1", "deinter_2",
                "deinter_3", "deinter_4", "deinter_5",
                "deinter_6", "deinter_7", "deinter_8",
                "deinter_9", "deinter_10", "estado")) %>%
  select(-item) %>%
  filter(!str_detect(capital, "Capital")) %>%
  filter(!str_detect(estado, "8A") &
         estado != "") %>%
  mutate(boletim = url[1])
}

todos_crimes <- map_dfr(1:length(url), get_crimes)

todos_crimes <- todos_crimes %>%
  mutate(dt_boletim = basename(todos_crimes$boletim),
         dt_boletim = str_remove_all(dt_boletim, "\\.htm"))



