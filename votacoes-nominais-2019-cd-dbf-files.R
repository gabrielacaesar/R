library(tidyverse)

path <- setwd("~/Downloads/votacoes-2019")

dados_2019 <- path %>%
            list.files() %>%
            map_df(~read.dbf(.)) 

tidy_dados_2019 <- dados_2019 %>%
                    mutate(VOTO = str_replace_all(VOTO, 
                           "<------->", "ausente"),
                           VOTO = str_replace_all(VOTO, 
                           "OBSTRUCAO", "obstrucao"),
                           VOTO = str_replace_all(VOTO, 
                           "ABSTENCAO", "abstencao"),
                           VOTO = str_replace_all(VOTO, 
                           "ART. 17", "naovotou"),
                           VOTO = str_replace_all(VOTO, 
                           "SIM", "sim"),
                           VOTO = str_replace_all(VOTO, 
                           "NAO", "nao")) %>%
                    group_by(NOME_PAR, VOTO) %>%
                    summarize(int = n()) %>%
                    spread(VOTO, int) %>%
                    replace(is.na(.), 0) %>%
                    mutate(total = ausente + sim + nao + abstencao + obstrucao + naovotou,
                           ausente_perc = (ausente / total) * 100) %>%
                    arrange(ausente_perc)


write.csv(tidy_dados_2019, "tidy_dados_2019.csv")



            
