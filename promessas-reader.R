library(tidyverse)
library(data.table)

path <- "~/Downloads/promessas-prefeitos-novos-30dez/"
setwd(path)

pref_novos <- list.files(path, pattern = "*csv") %>%
  set_names() %>%
  map_df(read_delim, 
         delim = ",", 
         col_names = TRUE,
         .id = "arquivo")

tidy_pref_novos <- pref_novos %>%
  select(-c(X11)) %>%
  separate(arquivo, c("capital", "arquivo_2"), "\\(") %>%
  separate(arquivo_2, c("uf", "arquivo_4"), "\\)") %>%
  select(-c(arquivo_4)) %>%
  # mutate(categoria = str_trim(categoria)) %>%
  group_by(categoria) %>%
  summarise(int = n())

#erro <- pref_novos %>%
#  filter(categoria == "meio-ambiente-e-agronegocio")
  

######
path_2 <- "~/Downloads/promessas-prefeitos-velhos-30dez/"
setwd(path_2)

pref_velhos <- list.files(path_2, pattern = "*csv") %>%
  set_names() %>%
  map_df(read_delim, 
         delim = ",", 
         col_names = TRUE,
         .id = "arquivo")

tidy_pref_velhos <- pref_velhos %>%
  separate(arquivo, c("capital", "arquivo_2"), "\\(") %>%
  separate(arquivo_2, c("uf", "arquivo_4"), "\\)") %>%
  select(-c(arquivo_4)) %>%
  # mutate(status = str_trim(status)) %>%
  group_by(status, categoria) %>%
  summarise(int = n()) %>%
  pivot_wider(names_from = status, values_from = int)

# write.csv(tidy_pref_velhos, "tidy_pref_velhos.csv")

#erro <- pref_velhos %>%
#  filter(tema == "Infraestrutura ")
