library(readxl)
library(tidyverse)

dados <- read_xlsx("dados/outros/MDIP_2013_Jan 2021.xlsx")

#### dados para GEOLOCALIZACAO

dados_n <- dados %>%
  janitor::clean_names() %>%
  filter(ano_bo == 2020 | ano_bo == 2019, 
         ano == 2020 | ano == 2019) %>%
  mutate(municipio_circ = str_replace_all(municipio_circ, "S.ANDRE", "SANTO ANDRÉ"),
         municipio_circ = str_replace_all(municipio_circ, "S.PAULO", "SÃO PAULO"),
         municipio_circ = str_replace_all(municipio_circ, "S.CARLOS", "SÃO CARLOS"),
         municipio_circ = str_replace_all(municipio_circ, "S.VICENTE", "SÃO VICENTE"),
         municipio_circ = str_replace_all(municipio_circ, "S.JOSE DOS CAMPOS", "SÃO JOSE DOS CAMPOS"),
         municipio_circ = str_replace_all(municipio_circ, "AGUAS DE S. BARBARA", "AGUAS DE SANTA BARBARA"),
         municipio_circ = str_replace_all(municipio_circ, "S.LUIS DO PARAITINGA", "SÃO LUIS DO PARAITINGA"),
         municipio_circ = str_replace_all(municipio_circ, "ESPIRITO STO. PINHAL", "ESPIRITO SANTO PINHAL"),
         municipio_circ = str_replace_all(municipio_circ, "S.CRUZ DAS PALMEIRAS", "SANTA CRUZ DAS PALMEIRAS"),
         municipio_circ = str_replace_all(municipio_circ, "S.BARBARA D OESTE", "SANTA BARBARA D OESTE"),
         municipio_circ = str_replace_all(municipio_circ, "S.ROQUE", "SÃO ROQUE"),
         municipio_circ = str_replace_all(municipio_circ, "S.ISABEL", "SANTA ISABEL"),
         municipio_circ = str_replace_all(municipio_circ, "S.JOAQUIM DA BARRA", "SÃO JOAQUIM DA BARRA"),
         municipio_circ = str_replace_all(municipio_circ, "S.CAETANO DO SUL", "SÃO CAETANO DO SUL"),
         municipio_circ = str_replace_all(municipio_circ, "S.CRUZ DA CONCEICAO", "SANTA CRUZ DA CONCEICAO"),
         municipio_circ = str_replace_all(municipio_circ, "S.MIGUEL ARCANJO", "SÃO MIGUEL ARCANJO"),
         municipio_circ = str_replace_all(municipio_circ, "S.SEBASTIAO", "SÃO SEBASTIAO"),
         municipio_circ = str_replace_all(municipio_circ, "S.JOSE DO RIO PRETO", "SÃO JOSE DO RIO PRETO")) %>%
  mutate(uf = "são paulo") %>%
  mutate_at(vars(logradouro, numero_logradouro, municipio_circ), tolower) %>%
  unite(endereco, c(logradouro, numero_logradouro, municipio_circ, uf), sep = ", ") %>%
  filter(!str_detect(endereco, "vedação da divulgação dos dados relativos"))

write.csv(dados_n, "dados_n.csv")
