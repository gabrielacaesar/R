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
                             y = dep_federal_2014$procv_despesa_total_new,
                             col = dep_federal_2014$reeleicao))
gc_scatterplot + geom_point(alpha = 0.4)
#### teste: gc_scatterplot + geom_jitter(shape = 1)

#os numeros estao errados; apenas para teste de juncao
gc_scatterplot2 <- ggplot(dep_federal_2014, aes(x = dep_federal_2014$UF, 
                                               y = dep_federal_2014$votos,
                                               col = dep_federal_2014$reeleicao))
gc_scatterplot2 + geom_point(alpha = 0.4)

# juntamos os graficos numa mesma imagem
# poderia juntar despesas de 2014 e 2018
grid.arrange(gc_scatterplot, gc_scatterplot2, nrow=2)
