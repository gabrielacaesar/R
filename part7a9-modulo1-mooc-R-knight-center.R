########
# parte 7 do modulo 1

install.packages("readr")

library(readr)

url <- "https://data.ct.gov/api/views/erbt-mpgb/rows.csv?accessType=DOWNLOAD"

data <- read_csv(url)

data2 <- read.csv(url)

str(data)

str(data2)

# usamos o 'str' acima para ver a diferença
# dos datasets; o tipo de conteúdo do DF

# abaixo vamos importar um csv salvo no PC

setwd("D:/Pessoal/Downloads")

local_file <- "Admissions_to_DMHAS_Addiction_Treatment_by_Town__Year__Month__and_Primary_Drug.csv"

data_local <- read_csv(local_file)

write_csv(data_local, "data_local.csv")

write_csv(data_local, "data_local_na.csv", na="")

########

# part 8 do modulo 1


install.packages("readxl")
library(readxl)

deputados <- read_excel("deputado.xls")

# usar skip depois do nome do arquivo se quiser
# pular as primeiras linhas para considerar header

# se o meu cabeçalho tem espaço
# eu posso usar `xxx `

deputados$`Nome Parlamentar`

# abaixo a gente tira os espaços do header
# e coloca pontos para deixar num padrão mais acessíveis
colnames(deputados) <- make.names(colnames(deputados))
colnames(deputados)

colnames(deputados)[colnames(deputados) == "Correio.Eletrônico"] <- "Email"
colnames(deputados)

# acima mudamos o nome da coluna

library(dplyr)

deputados <- rename(deputados, aniversario=Dia.Aniversário)
colnames(deputados)

deputados <- rename(deputados, dia_aniversario=aniversario)
deputados <- rename(deputados, mes_aniversario=Mês.Aniversário)
colnames(deputados)

deputados <- subset(deputados, !is.na(Telefone))
# acima mostraria os dados diferente de NA
# telefone é uma das colunas do DF que escolhemos

deputados <- filter(deputados, !is.na(Telefone))
# faz a mesma coisa, mas com o dplyr
# telefone é uma das colunas do DF que escolhemos

###########

# parte 9 do modulo 1

df1 <- read.table("https://raw.githubusercontent.com/r-journalism/learn-chapter-2/master/delimited_text/data/Employee_Payroll_Pipe.txt", header=TRUE, sep="|")
df2 <- read.table("https://raw.githubusercontent.com/r-journalism/learn-chapter-2/master/delimited_text/data/Employee_Payroll_Tab.txt", header=TRUE, sep="\t")

# acima o delimitador era tab, então usamos "\t"

library(readr)

df1 <- read_delim("https://raw.githubusercontent.com/r-journalism/learn-chapter-2/master/delimited_text/data/Employee_Payroll_Pipe.txt", delim="|")
df2 <- read_tsv("https://raw.githubusercontent.com/r-journalism/learn-chapter-2/master/delimited_text/data/Employee_Payroll_Tab.txt")

?read_fwf()

data_location <- "https://raw.githubusercontent.com/r-journalism/learn-chapter-2/master/delimited_text/data/fixed_width_example.txt"

fixed_example <- read_fwf(data_location, skip=9,
                          fwf_widths(c(8,2,12,12,29,3,6,9,5,18,20,8),
                          c("entry", "per", "post_date", "gl_account",
                            "description", "source", "cflow", "ref", "post",
                            "debit", "credit", "alloc")))




