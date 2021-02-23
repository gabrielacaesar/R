library(tidyverse)

# funcoes gerais 
# que podem ajudar
# a definir o caminho

list.files()
list.dirs() # botao do STOP
getwd()
dir.create()
setwd()
Sys.Date()
Sys.time()

# capitulo 3

# ler CSV
readr::read_csv()

# ler XLSX ou XLS // estimativa da pop / ibge
# download: https://www.ibge.gov.br/estatisticas/sociais/populacao/9103-estimativas-de-populacao.html?=&t=downloads
readxl::read_excel()

# ler com outro delimitador
readr::read_delim()

# ler a URL // arquivo 
# link: https://raw.githubusercontent.com/betafcc/Municipios-Brasileiros-TSE/master/municipios_brasileiros_tse.csv

# ler com fread() // biometria


# ler com fread() // microdados - educacao basica / escolas


# definir encoding / colunas / tipo colunas / novo header 

glimpse()
View()
class()
str()
summary()
head()
tail()
unique()
length()
colnames()
nrow()
sum()
mean()
median()
rename()

fazer operacoes com: ==; >; >=; <; !=
e tambem: + - / * ^

cifrao e [] para acessar dados

is.na()
which()
mean()
median()
max()
min()

as.character()
as.integer()

ifelse()

loops: if / map
