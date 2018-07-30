# course intro to r 
# https://journalismcourses.org/RC0818.html
# parte 1 a 4 do módulo 1
# 30 de julho de 2018
# gcaesar

print("hello")
printer <- print("hello!!")

#para descobrir em qual diretório vc está
getwd()

#para ir para o diretório
setwd("~/Downloads")

# vc pode definir o diretório manualmente: 
# session > set working directory > choose directory

install.packages("dplyr")
library(dplyr)

10^2 + 26
a <- 4
a

a + 5

a <- 2
a + 5

b <- c(3,4,5)
b

mean(b)
summary(a)
summary(b)

x <- rnorm(100)
x

plot(x)

j <- c(1,2,NA)
j

max(j)

# remove NA 
max(j, na.rm=T)

m <- "apples"
n <- m

# formatando uma data
date1 <- strptime(c("20100225230000", "20100227230000", "20100325230000"),
                    format="%Y%m%d%H%M%S")

date1

# formatando a data com outro pacote
install.packages("lubridate")
library(lubridate)

date2 <- ymd_hms(c("20100225230000", "20100227230000", "20100325230000"))
date2

# Agora construímos uma tabela
# com dados sobre algumas pessoas
sample_df <- data.frame(id=c(1001, 1002, 1003, 1004), name=c("steve", "pam", "jim", "dwight"), age=c(26, 65, 15, 7), race=c("white", "black", "white", "hispanic"))
sample_df$race <- factor(sample_df$race)
sample_df$id <- factor(sample_df$id)
sample_df$name <- as.character(sample_df$name)
View(sample_df)

str(sample_df)

# Queremos quantificar os dados
# de apenas uma das colunas
levels(sample_df$race)
summary(sample_df$race)

as.character(sample_df$race)
sample_df$race_converted <- as.character(sample_df$race)
View(sample_df)

str(sample_df)

factor(sample_df$name)

# abaixo leu apenas o último dígito do id
as.numeric(sample_df$id)

# abaixo leu o id completo
as.numeric(as.character(sample_df$id))

first_number <- 10
second_number <- 8

# cálculo de variação / evolução 
(second_number - first_number) / first_number * 100

# agora criamos uma função que cacula a taxa acima
percent_change <- function(first_number, second_number) {
  pc <- (second_number - first_number) / first_number*100
  return(pc)
}

percent_change(100, 80)

## módulo 4 da unidade 1

vec1 <- c(1,4,6,8,10)
vec1

vec1[3]

vec2 <- seq(from=0, to=1, by=0.25)
vec2

sum(vec2)

vec1 + vec2

#matrices

mat <- matrix(data=c(9,2,3,4,5,6), ncol=3)
mat

# para pegar o 3 da matriz
# indica a linha e a coluna
mat[1,2]

# agora para pegar o 6 da matriz
mat[2,3]

mean(mat)

# vamos aprender agora data frames

patientID <- c (11,208,113,408)
age <- c(25,34,28,52)
sex <- c(1,2,1,1)
diabetes <- c("type1", "type2", "type1", "type1")
status <- c(1,2,3,1)

patientdata <- data.frame(patientID, age, sex, diabetes, status)
View(patientdata)

# Agora queremos só as duas 
# primeiras colunas do DF
patientdata[1:2]

# Agora queremos só outras duas colunas
patientdata[c("diabetes", "status")]

# Agora queremos só os dados de uma coluna específica
patientdata$age

# Agora queremos outras colunas
patientdata[2:3, 1:2]

# Diferentes formas de fazer a média de uma coluna
mean(patientdata[["age"]])
mean(patientdata$age)

# Lists

g <- "My first list"
h <- c(25, 26, 18, 39)
j <- matrix(1:10, nrow=5)
k <- c("one", "two", "three")
mylist <- list(title = g, ages = h, j, k)

names(mylist)
mylist[[2]]

# Da coluna "ages" eu quero o primeiro item
mylist[["ages"]][[1]]

# Abaixo eu adicionei 10 a cada item da lista
mylist$ages + 10

# Vamos pegar o DF antigo para mostrar uns exemplos

sample_df <- data.frame(id=c(1001, 1002, 1003, 1004), name=c("steve", "pam", "jim", "dwight"), age=c(26, 65, 15, 7), race=c("white", "black", "white", "hispanic"))
sample_df$name <- as.character(sample_df$name)
sample_df

length(sample_df)

sample_df$name[1]

nchar(sample_df$name[1])

# Dimensão do DF; Mostra que o DF é de 4 por 4
dim(sample_df)

# Mostra o número de colunas do DF
ncol(sample_df)

# Mostra a estrutura do DF
str(sample_df)

# Mostra coisas gerais do DF
summary(sample_df)

# Deleta o dataframe
rm(sample_df)

