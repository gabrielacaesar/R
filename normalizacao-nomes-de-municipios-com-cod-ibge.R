library(data.table)
library(tidyverse)
library(abjutils)


lista_obrigatoriedade <- fread("~/lista_obrigatoriedade.csv", sep=";")


municipios <- fread("~/normalizacao-estados-e-municipios-com-cod-ibge.csv", sep=";")

lista_obrigatoriedade <- lista_obrigatoriedade %>%
  mutate(municipio_upper = toupper(rm_accent(Município))) %>%
  rename("uf" = "UF")

lista_nova1 <- lista_obrigatoriedade %>%
  left_join(municipios, by = c("uf", "municipio_upper")) %>%
  filter(codigo_ibge != "NA")

lista_nova2 <- lista_obrigatoriedade %>%
  left_join(municipios, by = c("uf", "municipio_upper" = "municipio_upper2")) %>%
  filter(codigo_ibge != "NA") %>%
  rename("municipio_upper2" = `municipio_upper.y`)

lista_nova <- rbind(lista_nova1, lista_nova2) %>%
  select(uf, municipio_upper, `Biometria obrigatória?`, codigo_ibge) %>%
  mutate(obrigatoria = ifelse(str_detect(`Biometria obrigatória?`, "Sim"), 
                                    "1", "2"))

write.csv(lista_nova, "obrigatoriedade_biometria_BR_27nov2019.csv")
