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

dep_federal_2014 <- fread("congresso-despesas-e-votos-de-dep-federais2018-consolidado-dep-federal-2014.csv", sep= ",", dec = ".")

# ggplot2
# scatterplot com despesa total por UF
gc_scatterplot <- ggplot(dep_federal_2014, aes(x = dep_federal_2014$UF, 
                             y = dep_federal_2014$procv_despesa_total_new)) +
geom_point(col = "red", alpha = 0.4)

#

gc_scatterplot2 <- ggplot(dep_federal_2014, aes(x = dep_federal_2014$UF, 
                                               y = dep_federal_2014$procv_despesa_total_new,
                                               col = dep_federal_2014$reeleicao)) +
  geom_point(position = "jitter", alpha = 0.5) +
  labs(x = "UF") +
  scale_y_continuous("Despesas totais (em RS)", limits = c(100000,10000000),
                     breaks = seq(100000,10000000,4900000)) + 
  scale_color_discrete("Reeleito:", 
                       labels = c("Nao", "Sim")) +
  ggtitle("Eleicao 2014: Deputados federais")


#
## agora invertendo os eixos
# o codigo maior no 'y' eh porque quermos ordem alfabetica
gc_scatterplot3 <- ggplot(dep_federal_2014, aes(x = dep_federal_2014$procv_despesa_total_new, 
                                                y = factor(dep_federal_2014$UF, levels = rev(levels(factor(dep_federal_2014$UF)))),
                                                col = dep_federal_2014$reeleicao)) +
  geom_point(position = "jitter", alpha = 0.5) +
  labs(y = "UF", caption = "TSE e Camara dos Deputados") +
  scale_x_continuous("Despesas totais (em RS)", limits = c(100000,9000000)) + 
  scale_color_discrete("Reeleito:", 
                       labels = c("Nao", "Sim")) +
  ggtitle("Eleicao 2014: Deputados federais eleitos")


