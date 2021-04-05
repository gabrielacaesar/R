library(readxl)
library(tidyverse)

dados <- read_xlsx("dados/outros/MDIP_2013_Jan 2021.xlsx")

pessoas_mortas <- dados %>%
  janitor::clean_names() %>%
  filter(ano_bo %in% c(2019, 2020), 
         ano %in% c(2019, 2020),
         coorporacao %in% c("PM", "PC")) %>%
  filter(str_detect(situacao, "Serviço|serviço|Folga|folga")) %>%
  filter(municipio_circ == "S.PAULO") %>%
  group_by(coorporacao, ano_bo) %>%
  summarise(qt = n())
