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

gc_scatterplot4 <- ggplot(dep_federal_2014, aes(x = dep_federal_2014$procv_despesa_total_new, 
                                                y = factor(dep_federal_2014$UF, levels = rev(levels(factor(dep_federal_2014$UF)))),
                                                col = "red")) +
  geom_point(position = "jitter", alpha = 0.5) +
  labs(y = "UF", caption = "TSE e Camara dos Deputados") +
  scale_x_continuous("Despesas totais (em RS)", limits = c(100000,9000000)) +
  ggtitle("Eleicao 2014: Deputados federais eleitos") +
  theme(legend.position="none")
  
ggsave("~/gc_scatterplot4.png")


