install.packages("readxl")
library(readxl)
nota_alunos <- read_excel("Downloads/NotadeAlunos-Parte1.xlsx")
View(nota_alunos)

freq_genero <- table(nota_alunos$Genero)
freq_genero

prop_genero <- prop.table(freq_genero)
perc_genero <- round(prop_genero*100,digits=2)

coluna_freq <- c(freq_genero,sum(freq_genero))
coluna_perc <- c(perc_genero,sum(perc_genero))

names(coluna_freq)[length(coluna_freq)] <- "Total"
tabela_freq <- cbind(coluna_freq,coluna_perc)
tabela_freq

#### cbind = juntando duas colunas
### a tabela acima mostou quantos homes
## e quantas mulheres temos e quanto em % 
# isso representa do total

freq_conceito <- table(nota_alunos$Conceito)
freq_conceito
prop_conceito <- prop.table(freq_conceito)
perc_conceito <- round(prop_conceito*100, digits=2)
coluna_freq <- c(freq_conceito,sum(freq_conceito))
coluna_perc <- c(perc_conceito,sum(perc_conceito))
names(coluna_freq)[length(coluna_freq)] <- "Total"
tabela_freq <- cbind(coluna_freq,coluna_perc)
tabela_freq

#### nosso output mostrou o numero
### de pessoas que tiraram cada nota
## e quanto em % isso representa
# do total

# agora vamos criar uma tabela de frequ??ncias

intervalos <- cut(nota_alunos$Nota_Final,breaks=0:10,right=F)
freq_notas <- table(intervalos)
freq_notas
prop_notas <- prop.table(freq_notas)
perc_notas <- round(prop_notas*100,digits=2)
coluna_freq <- c(freq_notas,sum(freq_notas))
coluna_perc <- c(perc_notas,sum(perc_notas))
names(coluna_freq)[length(coluna_freq)] <- "Total"
tabela_freq <- cbind(coluna_freq,coluna_perc)
tabela_freq

#usamos o 'cut'
#e o 'breaks', que eh o espacamento

rotulos <- paste(perc_genero,"%",sep="")
pie(freq_genero,main="Gr??fico de pizza: g??nero dos alunos",
    labels=rotulos,col=rainbow(7))
legend(1,1,names(freq_genero),col=rainbow(7),pch=15)

# acima eh o grafico de pizza
# abaixo o grafico de barras

barplot(freq_conceito)
barplot(freq_conceito,horiz=T)
freq_cruzada <- table(nota_alunos$Genero,nota_alunos$Conceito)
barplot(freq_cruzada,beside=T,main="Conceito vs G??nero",
        ylab="N??mero de aluno",col=c("darkblue","red"))
legend(1,30,rownames(freq_cruzada),col=c("darkblue","red"),
       pch=15)

# abaixo o histograma

hist(nota_alunos$Nota_Final,breaks=0:10,right=F,col="green",
     xlab="Notas",ylab="Frequ??ncia",main="Distribui????o de notas")

# abaixo o gr??fico de s??ries

plot(nota_alunos$Prova_1,type="l",xlab="ID Aluno",ylab="Nota")
lines(nota_alunos$Prova_2,col="blue")
lines(nota_alunos$Prova_3,col="red")

# abaixo o gr??fico de caixa / boxplot

boxplot(nota_alunos$Nota_Final ~ nota_alunos$Disciplina,
        main = "Nota final por disciplina",
        xlab = "Disciplina", col=c("orange","green"))

