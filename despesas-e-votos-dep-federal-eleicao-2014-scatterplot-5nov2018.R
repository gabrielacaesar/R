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
install.packages("scalles")
library(scalles)

getwd()
setwd("~/Downloads/")

dep_federal_2014 <- fread("congresso-despesas-e-votos-de-dep-federais2018-consolidado-dep-federal-2014-5nov2018.csv", sep= ",", dec = ".")


###################
## ggplot2
# scatterplot com despesa total por UF

despesa_scatterplot <- ggplot(dep_federal_2014, aes(x = dep_federal_2014$procv_despesa_total_new, 
                                                y = factor(dep_federal_2014$UF, levels = rev(levels(factor(dep_federal_2014$UF)))),
                                                col = "#c4170c")) +
  geom_point(position = "jitter", alpha = 0.4, size = 3.5) +
  labs(y = "UF", caption = "Fonte: TSE e Camara dos Deputados",
       title = "Eleicao 2014: Despesas totais (em RS) dos deputados federais eleitos",
       subtitle = "Na época, valor máximo declarado pelos 513 deputados federais foi de R$ 8,5 milhões",
       family = "Open sans") +
  scale_x_continuous(labels=function(x) format(x, big.mark = ".", scientific = FALSE)) +
  theme(legend.position="none",
        axis.title.y = element_blank(),
        axis.title.x = element_blank(),
        panel.border = element_blank()) 

ggsave("~/a-scatterplot-gc-5nov2018/despesa_scatterplot.png", width = 56, height = 40, units = "cm")



###################
## ggplot2
# scatterplot com relação de votos e despesas

votos_despesas_scatterplot <- ggplot(dep_federal_2014, aes(x = dep_federal_2014$procv_despesa_total_new, 
                                                  y = dep_federal_2014$votos_new,
                                                  col = "#c4170c")) +
  geom_point(position = "jitter", alpha = 0.4, size = 3.5) +
  labs(x = "Despesas totais em R$", y = "Nº de votos", caption = "Fonte: TSE e Câmara dos Deputados",
       title = "Eleição 2014: Relação entre votos e despesas dos 513 deputados federais",
       subtitle = "Na época, xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx",
       family = "Open sans") +
  scale_x_continuous(labels=function(x) format(x, big.mark = ".", scientific = FALSE)) +
  scale_y_continuous(labels=function(x) format(x, big.mark = ".", scientific = FALSE)) +
  theme(legend.position="none",
        panel.border = element_blank()) 

ggsave("~/a-scatterplot-gc-5nov2018/votos_despesas_scatterplot.png", width = 56, height = 40, units = "cm")



###################
## ggplot2
# scatterplot com o custo de cada voto

custo_voto <- fread("custo-voto-rel-voto-despesa-consolidado-dep-federal-2014.csv")

custo_do_voto_scatterplot <- ggplot(custo_voto, aes(x = custo_voto$rel_despesa_voto_new, 
                                                    y = factor(custo_voto$UF, levels = rev(levels(factor(custo_voto$UF)))),
                                                    col = "#c4170c")) +
  geom_point(position = "jitter", alpha = 0.4, size = 3.5) +
  labs(y = "UF", caption = "Fonte: TSE e Câmara dos Deputados",
       title = "Eleição 2014: Custo de cada voto dos 513 deputados federais",
       subtitle = "XXXXXXXXX",
       family = "Open sans") +
  scale_x_continuous(labels= scales::dollar) +
  theme(legend.position="none",
        axis.title.y = element_blank(),
        axis.title.x = element_blank(),
        panel.border = element_blank())

ggsave("~/a-scatterplot-gc-5nov2018/custo_do_voto_scatterplot.png", width = 56, height = 40, units = "cm")


###################
## ggplot2
# scatterplot com votos por UF


votos_scatterplot <- ggplot(dep_federal_2014, aes(x = as.numeric(as.character(dep_federal_2014$votos_new)), 
                                                    y = factor(dep_federal_2014$UF, levels = rev(levels(factor(dep_federal_2014$UF)))),
                                                    col = "#c4170c")) +
  geom_point(position = "jitter", alpha = 0.4, size = 15) +
  labs(y = "UF", caption = "Fonte: TSE e Câmara dos Deputados",
       title = "Eleição 2014: Número de votos dos 513 deputados federais",
       subtitle = "Na época, maior número de votos foi de R$ 1,5 milhão",
       family = "Open sans") +
  scale_x_continuous(labels=function(x) format(x, big.mark = ".", scientific = FALSE)) +
  theme(legend.position="none",
        axis.title.y = element_blank(),
        axis.title.x = element_blank(),
        panel.border = element_blank()) 

ggsave("~/a-scatterplot-gc-5nov2018/votos_scatterplot-size-15.png", width = 56, height = 40, units = "cm")
