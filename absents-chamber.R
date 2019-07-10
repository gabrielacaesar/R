# missing deputies

library(abjutils)
library(data.table)
library(tidyverse)
setwd("~/Downloads/")

dep <- fread("plenario2019_CD_politicos_9jul2019.csv")
presentes <- fread("presentes_9jul2019.csv")

presentes_df <- presentes %>%
  mutate(nome_upper = str_to_upper(Parlamentar)) %>%
  mutate(nome_upper = abjutils::rm_accent(nome_upper))

dep_exercicio <- dep %>%
  filter(exercicio == "sim")

joined_data <- left_join(dep_exercicio, presentes_df, by = "nome_upper")

dep_ausentes <- joined_data %>%
  filter(is.na(Parlamentar))

# checking error of chamber of deputies
error <- left_join(presentes_df, dep, by = "nome_upper") %>%
  filter(exercicio == "nao")

