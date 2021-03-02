library(tidyverse)
library(readxl)

path_2020 <- "dados/2020/"
boletins_2020 <- map_df(paste0(path_2020, list.files(path_2020, pattern = "*xls")), read.delim,
                   fileEncoding = "UTF-16LE", sep = "\t", header = T, stringsAsFactors = F)

path_2019 <- "dados/2019/"
boletins_2019 <- map_df(paste0(path_2019, list.files(path_2019, pattern = "*xls")), read.delim,
                        fileEncoding = "UTF-16LE", sep = "\t", header = T, stringsAsFactors = F)

b_2020 <- boletins_2020 %>%
  filter(STATUS == "Consumado") %>%
  filter(str_detect(DESDOBRAMENTO, "Morte decorrente de intervenção policial")) %>%
  distinct(NUMERO_BOLETIM, NOMEPESSOA, .keep_all = TRUE) %>%
  #unite("endereco", c("LOGRADOURO", "NUMERO", "BAIRRO", "CIDADE", "UF"), sep = ", ") %>%
  group_by(CORCUTIS) %>%
  summarise(qt = n())

b_2019 <- boletins_2019 %>%
  filter(STATUS == "Consumado") %>%
  filter(str_detect(DESDOBRAMENTO, "Morte decorrente de intervenção policial")) %>%
  distinct(NUMERO_BOLETIM, NOMEPESSOA, .keep_all = TRUE) %>%
  #unite("endereco", c("LOGRADOURO", "NUMERO", "BAIRRO", "CIDADE", "UF"), sep = ", ") %>%
  group_by(CORCUTIS) %>%
  summarise(qt = n())

# write.csv(b_2020, "b_2020.csv")
# write.csv(b_2019, "b_2019.csv")
