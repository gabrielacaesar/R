library(dplyr)
library(readr)
library(readxl)
library(data.table)
install.packages("ggplot2")
library(ggplot2)

getwd()
setwd("~/Downloads/")

dep_federal_2014 <- fread("congresso-despesas-e-votos-de-dep-federais2018-consolidado-dep-federal-2014.csv", sep= ",", dec = ".")
senador_2010 <- fread("congresso-despesas-e-votos-de-dep-federais2018-consolidado-senador-2010.csv")

# informamos eixos x e y
# renomeamos as legendas de x e y
# definimos o titulo do grafico
# definimos os limites dos eixos x e y
# definimos a forma do simbolo (ponto)
# definimos a cor dos pontos
plot(dep_federal_2014$procv_despesa_total_new, dep_federal_2014$votos, 
     xlab = "Despesa total (em R$)", ylab = "N de votos",
     main = "Eleicao 2014: Deputados federais eleitos",
     xlim = c(0,10000000), ylim = c(0,800),
     pch = 20, col = "red")

# estou pintando apenas parte dos pontos de azul
points(dep_federal_2014$procv_despesa_total_new[dep_federal_2014$reeleicao == "S"],
       dep_federal_2014$votos[dep_federal_2014$reeleicao == "S"], pch=20, col="blue")


