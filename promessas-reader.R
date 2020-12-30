library(tidyverse)
library(data.table)

path <- "~/Downloads/promessas-prefeitos-novos/"
setwd(path)

pref_novos <- list.files(path, pattern = "*csv") %>%
  set_names() %>%
  map_df(read_delim, 
         delim = ",", 
         col_names = TRUE,
         .id = "arquivo")

tidy_pref_novos <- pref_novos %>%
  select(-c(X11, textoLightbox_1)) %>%
  separate(arquivo, c("capital", "arquivo_2"), "\\(") %>%
  separate(arquivo_2, c("uf", "arquivo_4"), "\\)") %>%
  select(-c(arquivo_4)) %>%
  group_by(categoria) %>%
  summarise(int = n())

erro <- pref_novos %>%
  filter(categoria == "meio-ambiente-e-agronegócio")
  

