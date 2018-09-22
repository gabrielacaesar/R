library(readxl)
Casas <- read_excel("D:/Google Drive/PUC Pós/PUC Virtual/Análise Preditiva/Casas.xlsx")

#-----Exemplo 1 de Correlação------
r1 <- cor(Casas$Preco_Anunciado, Casas$Idade)
r1
plot(Casas$Preco_Anunciado, Casas$Idade)

#-----Exemplo 2 de Correlação-----
r2<- cor(Casas$Preco_Anunciado, Casas$Area_Util)
r2
plot(Casas$Preco_Anunciado, Casas$Area_Util)

#----Teste de Correlação Linear----
teste1 <- cor.test(Casas$Preco_Anunciado, Casas$Idade)
teste1
teste2 <- cor.test(Casas$Preco_Anunciado, Casas$Area_Util)
teste2

#----Exemplo 1 de Regressão----
r1 <- cor(Casas$Idade, Casas$Preco_Anunciado)
r1
plot(Casas$Idade, Casas$Preco_Anunciado)
ajuste <- lm(Preco_Anunciado ~ Idade, data = Casas)
summary(ajuste)
lines(Casas$Idade, ajuste$fitted.values, col = 2)

#----Exemplo 2 de Regressão----
r2<- cor(Casas$Area_Util, Casas$Preco_Anunciado)
r2
plot(Casas$Area_Util, Casas$Preco_Anunciado)
ajuste <- lm(Preco_Anunciado ~ Area_Util, data = Casas)
summary(ajuste)
lines(Casas$Area_Util, ajuste$fitted.values, col = 2)

#----Exemplo de Regressão Múltipla----
attach(Casas)
ajuste_multi <- lm(Preco_de_Venda ~ Area_Util + Idade + Comodos)
summary(ajuste_multi)

install.packages("car")
library(car)
vif(ajuste_multi)

install.packages("MASS")
library(MASS)
stepAIC(ajuste_multi, direction = "both")

#----Exemplo Geral Regressão Linear Simples----
attach(RLS_BEZERRO)
plot(`Medida(CM)`,`Peso (KG)`, pch = 19, col = "Dark Blue", main = "Medida x Peso",
     cex.axis = 1.5, cex.main = 1.5, cex.lab = 1.5, cex = 1.5)
cor.test(`Medida(CM)`,`Peso (KG)`)
ajuste <- lm(`Peso (KG)` ~ `Medida(CM)`)
summary(ajuste)
boxplot(`Medida(CM)`, col = "Light Blue", main = "Box Plot Medida (CM)",
        cex.axis = 1.5, cex.main = 1.5, cex.lab = 1.5)
boxplot(`Peso (KG)`, col = "Light Green", main = "Box Plot Peso (KG)",
        cex.axis = 1.5, cex.main = 1.5, cex.lab = 1.5)
RLS_BEZERRO$Z_Medida <- scale(`Medida(CM)`)
RLS_BEZERRO$Z_Peso <- scale(`Peso (KG)`)
range(RLS_BEZERRO$Z_Medida)
range(RLS_BEZERRO$Z_Peso)
par(mfrow=c(2,2))
plot(ajuste)

predicao <- data.frame(Peso_previsto = c(20, 28))
coef_ajuste <- coefficients(ajuste)
predicao$Peso_Previsto <- coef_ajuste[1]+coef_ajuste[2]*predicao
colnames(predicao) <- c("Medida", "Peso_previsto")
predicao

#----Exemplo Geral Regressão Linear Composta----
attach(HOUSES_EUA)
install.packages("PerformanceAnalytics")
library(PerformanceAnalytics)
HOUSES_Numeric <- HOUSES_EUA[,-2]
HOUSES_Numeric <- HOUSES_Numeric[,-4]
chart.Correlation(HOUSES_Numeric)
ajuste <- lm(Preco ~ Ofertas + `Tamanho (pes)` + Quartos + Banheiros + factor(Bairro) + Feita_tijolos)
summary(ajuste)
install.packages("car")
library(car)
vif(ajuste)
install.packages("MASS")
library(MASS)
stepAIC(ajuste, direction = "both")
par(mfrow=c(2,2))
plot(ajuste)

ajuste <- lm(scale(Preco) ~ Ofertas + scale(`Tamanho (pes)`) + Quartos + Banheiros + factor(Bairro) + Feita_tijolos)
summary(ajuste)
vif(ajuste)
stepAIC(ajuste, direction = "both")
par(mfrow=c(2,2))
plot(ajuste)


#----Exemplo 1 Regressão Logística Simples----
attach(Experiencia_Tarefa)
ajuste <- glm(Tarefa_concluidda ~ Experiencia, family = binomial)
summary(ajuste)
anova(ajuste, test = 'Chisq')
require(MASS)
exp(cbind(coef(ajuste), confint.default(ajuste)))
install.packages('pscl')
library(pscl)
pR2(ajuste)
plot(Experiencia_Tarefa)
y_chapeu <- data.frame(X = Experiencia_Tarefa$Experiencia, y_chapeu = ajuste$fitted.values)
y_chapeu <- y_chapeu[order(y_chapeu$X),]
lines(y_chapeu, col = 2)
y_chapeu
par(mfrow=c(2,2))
plot(ajuste)
y_chapeu <- data.frame(X = Experiencia_Tarefa$Experiencia, y_chapeu = ajuste$fitted.values)
y_chapeu$conclusão <- ifelse(y_chapeu$y_chapeu > .5, 1, 0)
y_chapeu$y <- Tarefa_concluidda
table(y_chapeu[,3:4])
mean(y_chapeu$conclusão == y_chapeu$y)

#----Exemplo 2 Regressão Logística Composta----
library(readxl)
Lasagna_Triers <- read_excel("D:/Google Drive/PUC Pós/PUC Virtual/Análise Preditiva/Lasagna Triers.xlsx")
View(Lasagna_Triers)
attach(Lasagna_Triers)
Lasagna_Triers$Compra <- ifelse(Lasagna_Triers$`Have Tried`=="Yes", 1, 0)
ajuste <- glm(Compra ~ Age + Weight + Income + `Pay Type` +
                `Car Value` + `CC Debt` + Gender + `Live Alone` +
                `Dwell Type` + `Mall Trips` + Nbhd, family = binomial)
summary(ajuste)
require(MASS)
stepAIC(ajuste, direction = "both")
ajuste2 <- glm(Compra ~ Age + `Pay Type` + Gender + `Live Alone` + 
                 `Mall Trips` + Nbhd, family = binomial)
summary(ajuste2)
exp(cbind(coef(ajuste2), confint.default(ajuste2)))
pchisq(ajuste2$deviance, ajuste2$df.residual, lower.tail = F) #Teste Chi-quadrado do Deviance
pchisq(ajuste2$null.deviance - ajuste2$deviance,
       ajuste2$df.null - ajuste$df.residual, lower.tail = F) #Teste Chi-quadrado da Regressão
library(car)
vif(ajuste2)
install.packages('pscl')
library(pscl)
pR2(ajuste2)
par(mfrow=c(2,2))
plot(ajuste2)
coef2 <- data.frame(coef(ajuste2))
p_hat <- (exp(coef2[1,] + coef2[2,]*20 + coef2[3,] + coef2[4,] +
              coef2[5,] + coef2[6,]*10 + coef2[8,]))/
          (1+exp(coef2[1,] + coef2[2,]*20 + coef2[3,] + coef2[4,] +
             coef2[5,] + coef2[6,]*10 + coef2[8,]))
p_hat

#----Exemplo Análise Fatorial----
library(readxl)
EFA <- read_excel("D:/Google Drive/PUC Pós/PUC Virtual/Análise Preditiva/EFA.xlsx")
View(EFA)
install.packages('psych')
install.packages('GPArotation')
library(psych)
library(GPArotation)
parallel <- fa.parallel(EFA, fm = 'pa', fa = 'fa') #escolha do número de fatores
tresfatores <- fa(EFA, nfactors = 3, rotate = "oblimin", fm="pa")
tresfatores
print(tresfatores$loadings, cutoff = .3)
quatrofatores <- fa(EFA, nfactors = 4, rotate = "oblimin", fm="pa")
quatrofatores
print(quatrofatores$loadings, cutoff = .3)
fa.diagram(quatrofatores)

#----Exemplo Análise de Cluster----
library(readxl)
Proteina <- read_excel("D:/Google Drive/PUC Pós/PUC Virtual/Análise Preditiva/Protein.xlsx")
View(Proteina)
install.packages("cluster")
library(cluster)
hc <- hclust(dist(Proteina[,-1]), method = 'average') 
plot(hc)
clusterCut <- cutree(hc, 3)
rect.hclust(hc, k=3, border="red")
clusplot(Proteina[,-1], clusterCut,
         main='Represetação Gráfica 2D - Solução com 3 Clusters',
         color=TRUE, shade=TRUE, labels=2, lines=0)
Proteina$Grupos <- clusterCut
Grupo_ordenado <- Proteina[order(Proteina$Grupos),]
somente_grupo <- subset(Grupo_ordenado,select = c(Country, Grupos))
View(somente_grupo)

#----Exemplo Análise Discriminante----
library(readxl)
Candidatos <- read_excel("D:/Google Drive/PUC Pós/PUC Virtual/Análise Preditiva/Candidatos.xlsx")
View(Candidatos)
ds_candidatos <- Candidatos[,-1]
View(ds_candidatos)
ds_candidatos$Grupo <- factor(ds_candidatos$Grupo, levels = c(1, 2, 3),
                              labels = c("Aprovado", "Espera", "Reprovado"))
View(ds_candidatos)
attach(ds_candidatos)
require(MASS)
install.packages("klaR")
library(klaR)
ajuste <- lda(Grupo ~ Nota_tecnica + Historico)
ajuste
plot(ajuste, col = as.integer(Grupo), cex = 1.5)
table(Grupo, Predito = predict(ajuste, Candidatos[,3:4])$class)
mean(Grupo == predict(ajuste, Candidatos[,3:4])$class)
partimat(Grupo ~ Nota_tecnica + Historico, method="lda")
plot(ajuste, dimen = 1, type = "b")

ajuste2 <- qda(Grupo ~ Nota_tecnica + Historico)
ajuste2
table(Grupo, Predito = predict(ajuste2, Candidatos[,3:4])$class)
mean(Grupo == predict(ajuste2, Candidatos[,3:4])$class)
partimat(Grupo ~ Nota_tecnica + Historico, method="qda")

#----Exemplo de Análise de Séries Temporais----
data("AirPassengers")
View(AirPassengers)
plot(AirPassengers)
boxplot(AirPassengers~cycle(AirPassengers))
acf(AirPassengers)
pacf(AirPassengers)
#plot(decompose(AirPassengers))
plot(log(AirPassengers))
acf(log(AirPassengers))
pacf(log(AirPassengers))
plot(diff(log(AirPassengers)))
acf(diff(log(AirPassengers)))
pacf(diff(log(AirPassengers)))
install.packages("tseries")
library(tseries)
adf.test(diff(log(AirPassengers)), alternative="stationary", k=0)
ajuste <- arima(log(AirPassengers), c(0, 1, 1), seasonal = list(order = c(0, 1, 1), period = 12))
pred <- predict(ajuste, n.ahead = 10*12)
ts.plot(AirPassengers,exp(pred$pred), log = "y", lty = c(1,3))
ts.plot(AirPassengers,exp(pred$pred), lty = c(1,3))
