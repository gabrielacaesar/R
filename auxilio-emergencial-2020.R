library(data.table)
library(tidyverse)
library(abjutils)
library(janitor)

cod_municipios_ibge <- fread("~/Downloads/cod_ibge_gcaesar.csv")
#online: https://gist.github.com/gabrielacaesar/3a4bd8506816a22886cc8b5a454026e7

estimativa_pop_2019 <- fread("~/Downloads/estimativa_populacional_ibge_2019.csv")
#online: https://gist.github.com/gabrielacaesar/8668444f9ae97e41a700e17dc5ba86fa
#online: https://www.ibge.gov.br/estatisticas/sociais/populacao/9103-estimativas-de-populacao.html?=&t=o-que-e

cod_ibge_estimativa_2019 <- estimativa_pop_2019  %>%
                              clean_names() %>%
                              mutate(municipio_upper = 
                                       rm_accent(toupper(nome_do_municipio))) %>%
                              left_join(cod_municipios_ibge, 
                                        by = c("uf", "municipio_upper")) %>%
                              select(uf, municipio_upper, codigo_ibge,
                                     populacao_estimada)

#### AUXILIO EMERGENCIAL 
#online: http://www.portaldatransparencia.gov.br/download-de-dados/auxilio-emergencial
auxilio_abril_2020 <- "~/Downloads/202004_AuxilioEmergencial.csv" %>%
                          fread(
                            encoding = "Latin-1", 
                            #nrows = 200000,
                            select = c("MÊS DISPONIBILIZAÇÃO", 
                                      "CÓDIGO MUNICÍPIO IBGE",
                                      "NOME MUNICÍPIO", "UF",
                                      "VALOR BENEFÍCIO", "PARCELA"))

auxilio_maio_2020 <- "~/Downloads/202005_AuxilioEmergencial.csv" %>%
                          fread( 
                            encoding = "Latin-1",
                            #nrows = 200000,
                            select = c("MÊS DISPONIBILIZAÇÃO", 
                                      "CÓDIGO MUNICÍPIO IBGE",
                                      "NOME MUNICÍPIO", "UF",
                                      "VALOR BENEFÍCIO", "PARCELA"))

# linhas sem municipio e UF informados <- "NA - NÃO INFORMADO"

pop_auxilio <- auxilio_maio_2020 %>%
                  rbind(auxilio_abril_2020) %>%
                  clean_names() %>%
                  mutate(valor_beneficio = 
                           as.numeric(gsub(",00", "", valor_beneficio))) %>%
                  mutate(nome_municipio = ifelse(nome_municipio != "", 
                                                nome_municipio, "NA - NÃO INFORMADO")) %>%
                  filter(nome_municipio != "NA - NÃO INFORMADO")
  
  
pop_auxilio$nome_municipio[pop_auxilio$nome_municipio == "CAMPO GRANDE (EX-AUGUSTO SEVERO)"] <- "AUGUSTO SEVERO"
pop_auxilio$nome_municipio[pop_auxilio$nome_municipio == "JANUARIO CICCO"] <- "JANUARIO CICCO (BOA SAUDE)"
pop_auxilio$nome_municipio[pop_auxilio$nome_municipio == "SAO CAITANO"] <- "SAO CAETANO"
pop_auxilio$nome_municipio[pop_auxilio$nome_municipio == "OLHOS-D'AGUA"] <- "OLHOS D'AGUA"
pop_auxilio$nome_municipio[pop_auxilio$nome_municipio == "SAO LUIS DO PARAITINGA"] <- "SAO LUIZ DO PARAITINGA"


pop_auxilio_joined <- pop_auxilio %>%
                        left_join(cod_ibge_estimativa_2019, 
                            by = c("codigo_municipio_ibge" = "codigo_ibge")) %>%
                        group_by(codigo_municipio_ibge, nome_municipio, `uf.x`, populacao_estimada) %>%
                        summarize(qt_beneficio = n(),
                            soma_beneficio = sum(valor_beneficio)) %>%
                        mutate(valor_medio_por_habitante = soma_beneficio / populacao_estimada,
                            valor_medio_por_beneficio = soma_beneficio / qt_beneficio,
                            perc_beneficio_por_hab = (qt_beneficio / populacao_estimada) * 100) %>%
                        mutate(valor_medio_por_habitante = round(valor_medio_por_habitante),
                               valor_medio_por_beneficio = round(valor_medio_por_beneficio),
                               perc_beneficio_por_hab = round(perc_beneficio_por_hab)) %>%
                        arrange(desc(perc_beneficio_por_hab)) 


write.csv(pop_auxilio_joined, "pop_auxilio_joined.csv")
## cruzar com casos do novo coronavirus??
## populacao ocupada??

