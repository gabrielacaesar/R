library(dplyr)
library(readr)
library(readxl)
library(data.table)
install.packages("ggplot2")
library(ggplot2)
install.packages("tidyverse")
library(tidyverse)
install.packages("gridExtra")
library(gridExtra)


getwd()
setwd("~/Downloads/")

dep_federal_2014 <- fread("6nov2018-congresso-despesas-e-votos-de-dep-federais2018 - consolidado-dep-federal-2014.csv", sep= ",", dec = ".")


###################
## ggplot2
# scatterplot com despesa total por UF

despesa_scatterplot <- ggplot(dep_federal_2014, aes(x = dep_federal_2014$procv_despesa_total_new, 
                                                    y = factor(dep_federal_2014$UF, levels = rev(levels(factor(dep_federal_2014$UF)))),
                                                    col = "#c4170c")) +
  geom_point(alpha = 0.4, size = 3.5) +
  labs(y = "UF", caption = "*Partidos a que os deputados estavam filiados quando disputaram a eleição de 2014.                    Fonte: TSE e Câmara dos Deputados",
       title = "Eleição 2014: Despesas totais (em R$) dos deputados federais eleitos",
       subtitle = "Na época, montante mais alto declarado foi de R$ 8,5 milhões. Valores não foram corrigidos pela inflação*",
       family = "Open sans") +
  scale_x_continuous(labels=function(x) format(x, big.mark = ".", scientific = FALSE)) +
  theme(legend.position="none",
        axis.title.y = element_blank(),
        axis.title.x = element_blank(),
        panel.border = element_blank(),
        plot.title = element_text(size = 14, face="bold"))

ggsave("a-scatterplot-gc-6nov2018/despesa_scatterplot.png", width = 20, height = 20, units = "cm", dpi = 600)



###################
## ggplot2
# scatterplot com votos por UF


votos_scatterplot <- ggplot(dep_federal_2014, aes(x = as.numeric(as.character(dep_federal_2014$votos_new)), 
                                                  y = factor(dep_federal_2014$UF, levels = rev(levels(factor(dep_federal_2014$UF)))),
                                                  col = "#c4170c")) +
  geom_point(alpha = 0.4, size = 3.5) +
  labs(y = "UF", caption = "*Partidos a que os deputados estavam filiados quando disputaram a eleição de 2014.                    Fonte: TSE e Câmara dos Deputados",
       title = "Eleição 2014: Número de votos dos 513 deputados federais eleitos",
       subtitle = "Na época, deputado mais votado para a Câmara dos Deputados recebeu R$ 1,5 milhão de votos*",
       family = "Open sans") +
  scale_x_continuous(labels=function(x) format(x, big.mark = ".", scientific = FALSE)) +
  theme(legend.position="none",
        axis.title.y = element_blank(),
        axis.title.x = element_blank(),
        panel.border = element_blank(),
        plot.title = element_text(size = 14, face="bold"),
        plot.caption = element_text(hjust = 0)) 

ggsave("a-scatterplot-gc-6nov2018/votos_scatterplot.png", width = 20, height = 20, units = "cm", dpi = 600)






###################
## ggplot2
# scatterplot com o custo de cada voto

custo_do_voto_scatterplot <- ggplot(dep_federal_2014, aes(x = dep_federal_2014$rel_despesa_voto_new, 
                                                    y = factor(dep_federal_2014$UF, levels = rev(levels(factor(dep_federal_2014$UF)))),
                                                    col = "#c4170c")) +
  geom_point(alpha = 0.4, size = 3.5) +
  labs(y = "UF", caption = "*Partidos a que os deputados estavam filiados quando disputaram a eleição de 2014.                    Fonte: TSE e Câmara dos Deputados",
       title = "Eleição 2014: Custo de cada voto dos 513 deputados federais eleitos",
       subtitle = "Relação entre o número de votos e as despesas totais. Valores não foram corrigidos pela inflação*",
       family = "Open sans") +
  theme(legend.position="none",
        axis.title.y = element_blank(),
        axis.title.x = element_blank(),
        panel.border = element_blank(),
        plot.title = element_text(size = 14, face="bold"),
        plot.caption = element_text(hjust = 0))

ggsave("a-scatterplot-gc-6nov2018/custo_do_voto_scatterplot.png", width = 20, height = 20, units = "cm", dpi = 600)
