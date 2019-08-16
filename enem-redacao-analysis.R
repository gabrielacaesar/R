library(tidyverse)
library(data.table)
library(openxlsx)

# pasta em que estão os dados
setwd("~/Downloads/microdados_enem2018/DADOS")

# leitura do arquivo, com colunas definidas
enem <- fread("MICRODADOS_ENEM_2018.csv", select = c("NU_NOTA_COMP1",
                                                     "NU_NOTA_COMP2",
                                                     "NU_NOTA_COMP3",
                                                     "NU_NOTA_COMP4",
                                                     "NU_NOTA_COMP5",
                                                     "NU_NOTA_REDACAO"))

# informações do dicionário de dados
# NU_NOTA_COMP1	Nota da competência 1 - Demonstrar domínio da modalidade escrita formal da Língua Portuguesa.
# NU_NOTA_COMP2	Nota da competência 2 - Compreender a proposta de redação e aplicar conceitos das várias áreas de conhecimento para desenvolver o tema, dentro dos limites estruturais do texto dissertativo-argumentativo em prosa.
# NU_NOTA_COMP3	Nota da competência 3 - Selecionar, relacionar, organizar e interpretar informações, fatos, opiniões e argumentos em defesa de um ponto de vista.
# NU_NOTA_COMP4	Nota da competência 4 - Demonstrar conhecimento dos mecanismos linguísticos necessários para a construção da argumentação.
# NU_NOTA_COMP5	Nota da competência 5 - Elaborar proposta de intervenção para o problema abordado, respeitando os direitos humanos.
# NU_NOTA_REDACAO	Nota da prova de redação

# quantos alunos tiraram cada nota?
# quanto isso representa do total?
# quantos alunos tiraram 1.000 e quantos tiraram 0?

notas_freq <- enem %>%
  group_by(NU_NOTA_REDACAO) %>%
  summarise(int = n()) %>%
  filter(!is.na(NU_NOTA_REDACAO)) %>%
  mutate(total = sum(int)) %>%
  mutate(nota_perc = (int / total) * 100)

# em quais competências os alunos mais perderam pontos?

perda_pontos <- enem %>%
  filter(!is.na(NU_NOTA_REDACAO)) %>%
  mutate(NU_NOTA_COMP1_pt = 200 - NU_NOTA_COMP1) %>%
  mutate(NU_NOTA_COMP2_pt = 200 - NU_NOTA_COMP2) %>%
  mutate(NU_NOTA_COMP3_pt = 200 - NU_NOTA_COMP3) %>%
  mutate(NU_NOTA_COMP4_pt = 200 - NU_NOTA_COMP4) %>%
  mutate(NU_NOTA_COMP5_pt = 200 - NU_NOTA_COMP5) %>%
  mutate(NU_NOTA_REDACAO_pt = 1000 - NU_NOTA_REDACAO) %>%
  select(NU_NOTA_COMP1_pt, NU_NOTA_COMP2_pt, NU_NOTA_COMP3_pt,
         NU_NOTA_COMP4_pt, NU_NOTA_COMP5_pt, NU_NOTA_REDACAO_pt) 

### quanto cada competência tem de perda de pontos?

sum_NU_NOTA_COMP1_pt <- sum(perda_pontos$NU_NOTA_COMP1_pt)
sum_NU_NOTA_COMP2_pt <- sum(perda_pontos$NU_NOTA_COMP2_pt)
sum_NU_NOTA_COMP3_pt <- sum(perda_pontos$NU_NOTA_COMP3_pt)
sum_NU_NOTA_COMP4_pt <- sum(perda_pontos$NU_NOTA_COMP4_pt)
sum_NU_NOTA_COMP5_pt <- sum(perda_pontos$NU_NOTA_COMP5_pt)

total_sum_perda_pontos <- sum(sum_NU_NOTA_COMP1_pt, sum_NU_NOTA_COMP2_pt, sum_NU_NOTA_COMP3_pt, 
      sum_NU_NOTA_COMP4_pt, sum_NU_NOTA_COMP5_pt) 

(sum_NU_NOTA_COMP1_pt / total_sum_perda_pontos) * 100
(sum_NU_NOTA_COMP2_pt / total_sum_perda_pontos) * 100
(sum_NU_NOTA_COMP3_pt / total_sum_perda_pontos) * 100
(sum_NU_NOTA_COMP4_pt / total_sum_perda_pontos) * 100
(sum_NU_NOTA_COMP5_pt / total_sum_perda_pontos) * 100

# quanto essa perda representa do total de perda em cada caso?

perda_pontos_perc <- perda_pontos %>%
  mutate(NU_NOTA_COMP1_pt_perc = (NU_NOTA_COMP1_pt / NU_NOTA_REDACAO_pt) * 100) %>%
  mutate(NU_NOTA_COMP2_pt_perc = (NU_NOTA_COMP2_pt / NU_NOTA_REDACAO_pt) * 100) %>%
  mutate(NU_NOTA_COMP3_pt_perc = (NU_NOTA_COMP3_pt / NU_NOTA_REDACAO_pt) * 100) %>%
  mutate(NU_NOTA_COMP4_pt_perc = (NU_NOTA_COMP4_pt / NU_NOTA_REDACAO_pt) * 100) %>%
  mutate(NU_NOTA_COMP5_pt_perc = (NU_NOTA_COMP5_pt / NU_NOTA_REDACAO_pt) * 100) 
  




            