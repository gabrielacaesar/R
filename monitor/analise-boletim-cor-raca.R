library(readxl)
library(tidyverse)

dados <- read_xlsx("dados/outros/MDIP_2013_Jan 2021.xlsx")

###### POLICIA MILITAR
b_2020_SERVICO_PM <- dados %>%
  janitor::clean_names() %>%
  filter(ano_bo == 2020, 
         ano == 2020,
         coorporacao == "PM") %>%
  filter(str_detect(situacao, "Serviço|serviço")) %>%
  group_by(cor) %>%
  summarise(qt = n())

b_2020_FOLGA_PM <- dados %>%
  janitor::clean_names() %>%
  filter(ano_bo == 2020, 
         ano == 2020,
         coorporacao == "PM") %>%
  filter(str_detect(situacao, "Folga|folga")) %>%
  group_by(cor) %>%
  summarise(qt = n())

###### POLICIA CIVIL
b_2020_SERVICO_PC <- dados %>%
  janitor::clean_names() %>%
  filter(ano_bo == 2020, 
         ano == 2020,
         coorporacao == "PC") %>%
  filter(str_detect(situacao, "Serviço|serviço")) %>%
  group_by(cor) %>%
  summarise(qt = n())

b_2020_FOLGA_PC <- dados %>%
  janitor::clean_names() %>%
  filter(ano_bo == 2020, 
         ano == 2020,
         coorporacao == "PC") %>%
  filter(str_detect(situacao, "Folga|folga")) %>%
  group_by(cor) %>%
  summarise(qt = n())

