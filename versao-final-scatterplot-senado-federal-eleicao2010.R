library(dplyr)
library(readr)
library(readxl)
library(data.table)
library(ggplot2)
library(tidyverse)



getwd()
setwd("~/Downloads/")


senador_2010 <- fread("6nov2018-despesas-e-votos-senador-2010.csv")



###################
## ggplot2
# scatterplot com despesa total por UF

despesa_senador_scatterplot <- ggplot(senador_2010, aes(x = senador_2010$despesa_total_new, 
                                                    y = factor(senador_2010$UF, levels = rev(levels(factor(senador_2010$UF)))),
                                                    col = "#c4170c")) +
  geom_point(alpha = 0.4, size = 3.5) +
  labs(y = "UF", caption = "*Partidos a que os senadores estavam filiados quando disputaram a eleição de 2010.                                                                     Fonte: TSE",
       title = "Eleição 2010: Despesas totais (em R$) dos senadores",
       subtitle = "Na época, montante mais alto declarado foi de R$ 14 milhões. Valores não foram corrigidos pela inflação*",
       family = "Open sans") +
  scale_x_continuous(labels=function(x) format(x, big.mark = ".", scientific = FALSE)) +
  theme(legend.position="none",
        axis.title.y = element_blank(),
        axis.title.x = element_blank(),
        panel.border = element_blank(),
        plot.title = element_text(size = 14, face="bold")) 

ggsave("a-scatterplot-gc-6nov2018/despesa_senador_scatterplot.png", width = 20, height = 20, units = "cm", dpi = 600)





###################
## ggplot2
# scatterplot com votos por UF


votos_senador_scatterplot <- ggplot(senador_2010, aes(x = as.numeric(as.character(senador_2010$votos_new)), 
                                                  y = factor(senador_2010$UF, levels = rev(levels(factor(senador_2010$UF)))),
                                                  col = "#c4170c")) +
  geom_point(alpha = 0.4, size = 3.5) +
  labs(y = "UF", caption = "*Partidos a que os senadores estavam filiados quando disputaram a eleição de 2010.                                                                 Fonte: TSE",
       title = "Eleição 2010: Número de votos dos 54 candidatos a senador eleitos",
       subtitle = "Na época, senador mais votado recebeu R$ 11,2 milhões de votos*",
       family = "Open sans") +
  scale_x_continuous(labels=function(x) format(x, big.mark = ".", scientific = FALSE)) +
  theme(legend.position="none",
        axis.title.y = element_blank(),
        axis.title.x = element_blank(),
        panel.border = element_blank(),
        plot.title = element_text(size = 14, face="bold"),
        plot.caption = element_text(hjust = 0)) 

ggsave("a-scatterplot-gc-6nov2018/votos_senador_scatterplot.png", width = 20, height = 20, units = "cm", dpi = 600)







###################
## ggplot2
# scatterplot com o custo de cada voto

custo_voto_sf <- fread("6nov2018-custo-voto-sf.csv")

custo_do_voto_senador_scatterplot <- ggplot(custo_voto_sf, aes(x = custo_voto_sf$rel_despesa_voto_new, 
                                                          y = factor(custo_voto_sf$UF, levels = rev(levels(factor(custo_voto_sf$UF)))),
                                                          col = "#c4170c")) +
  geom_point(alpha = 0.4, size = 3.5) +
  labs(y = "UF", caption = "*Partidos a que os senadores estavam filiados quando disputaram a eleição de 2010.                                                                Fonte: TSE",
       title = "Eleição 2010: Custo de cada voto dos 54 senadores eleitos",
       subtitle = "Relação entre o número de votos e as despesas totais. Valores não foram corrigidos pela inflação*",
       family = "Open sans") +
  theme(legend.position="none",
        axis.title.y = element_blank(),
        axis.title.x = element_blank(),
        panel.border = element_blank(),
        plot.title = element_text(size = 14, face="bold"),
        plot.caption = element_text(hjust = 0))

ggsave("a-scatterplot-gc-6nov2018/custo_do_voto_senador_scatterplot.png", width = 20, height = 20, units = "cm", dpi = 600)




###################
## ggplot2
# scatterplot - número de votos e despesas totais


votos_despesas_senador_scatterplot <- ggplot(senador_2010, aes(x = senador_2010$despesa_total_new, 
                                                           y = senador_2010$votos_new,
                                                           col = "#c4170c")) +
  geom_point(alpha = 0.4, size = 3.5) +
  labs(x = "Despesas totais (em R$)", y = "Nº de votos", caption = "*Partidos a que os senadores estavam filiados quando disputaram a eleição de 2010.                                                                Fonte: TSE",
       title = "Eleição 2010: Relação entre votos e despesas dos senadores",
       subtitle = "Na época, xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx",
       family = "Open sans") +
  scale_x_continuous(labels=function(x) format(x, big.mark = ".", scientific = FALSE)) +
  scale_y_continuous(labels=function(x) format(x, big.mark = ".", scientific = FALSE)) +
  theme(legend.position="none",
        panel.border = element_blank(),
        plot.title = element_text(size = 14, face="bold")) 

ggsave("a-scatterplot-gc-6nov2018/votos_despesas_senador_scatterplot.png", width = 20, height = 20, units = "cm", dpi = 600)




