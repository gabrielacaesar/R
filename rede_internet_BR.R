library(tidyverse)
library(data.table)


sinal_internet <- fread("C:/Users/acaesar/Desktop/MapaInternetAnatel_rikardi.csv", sep=";")

 
rede_4g <- sinal_internet %>%
  gather("sinal", "int", 2:22) %>%
  filter(int == "3") %>%
  group_by(COD) %>%
  summarise(int = n())
  
rede_3g <- sinal_internet %>%
  gather("sinal", "int", 2:22) %>%
  filter(int == "2") %>%
  group_by(COD) %>%
  summarise(int = n()) 

rede_3g_2 <- rede_3g %>%
  left_join(rede_4g, by = "COD") %>%
  filter(is.na(`int.y`)) %>%
  mutate(sinal = "3g") %>%
  select(COD, sinal)

rede_4g_2 <- rede_4g %>%
  select(COD) %>%
  mutate(sinal = "4g")

rede_4g_3g <- bind_rows(merged, rede_4g_2)

rede_2g <- sinal_internet %>%
  gather("sinal", "int", 2:22) %>%
  filter(int == "1") %>%
  group_by(COD) %>%
  summarise(int = n())

rede_2g_2 <- rede_2g %>%
  left_join(rede_4g_3g, by = "COD") %>%
  filter(is.na(sinal)) %>%
  mutate(sinal = "2g") %>%
  select(COD, sinal)

rede_FINAL <- bind_rows(rede_3g_2, rede_4g_2, rede_2g_2)

write.csv(rede_FINAL, "rede_final.csv")


