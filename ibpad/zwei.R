library(tidyverse)

################ REVISAO

- Quem eu sou; meus posts no IBPAD
- O potencial do R
- Dados abertos, dados publicos, governo aberto
- R x RStudio 
- O basico do RStudio
- Abrir o nosso projeto
- Comandos iniciais / calculadora e criar variavel
- Consultar a documentacao
- Observar sempre o erro no console

fazer operacoes com: ==; >; >=; <; !=
e tambem: + - / * ^

# round(1.33333333333)
# round(1.3456789012345, digits = 4)
# ceiling(1.3333)
# floor(1.2222)

################ COMANDOS GERAIS
# funcoes gerais 
# que podem ajudar
# a definir o caminho

list.files()
getwd()
dir.create()
setwd()
Sys.Date()
Sys.time()

################ OUTROS IMPORTANTES

- o que eh a flecha // atalho Option+-
- como fazer comentarios
- o que eh o pipe %>% // atalho Cmd+Shift+M
- o que sao pacotes?
- como instalar os pacotes?
- por que sempre ler os pacotes antes?
- todos rodam codigo para carregar pacotes

################ IMPORTACAO

# ler CSV // agenda do ministro 
# download: https://www.gov.br/mcom/pt-br/agenda-de-autoridades/gabinete-do-ministro/ministro/2021-02-24
agenda <- readr::read_csv("dados/agendas_ministerio_comunicacoes/Agenda Ministro - 16-06-2020 a 18-02-2021.csv")

# ler XLSX ou XLS // estimativa da pop / ibge
# download: https://www.ibge.gov.br/estatisticas/sociais/populacao/9103-estimativas-de-populacao.html?=&t=downloads
library(readxl)
pop <- readxl::read_excel("dados/ibge/estimativa_dou_2020.xls",
                          skip = 1,
                          sheet = "Municípios")

deputados <- read_xls("dados/camara_dos_deputados/deputado.xls")
# read_excel() >>>> adivinha se eh xls ou xlsx
# read_xls() >>>> voce aponta que eh xls; oposto eh read_xlsx()


# ler com outro delimitador
readr::read_delim()

# ler a URL // arquivo 
# link: https://raw.githubusercontent.com/betafcc/Municipios-Brasileiros-TSE/master/municipios_brasileiros_tse.csv

municipios <- readr::read_csv("https://raw.githubusercontent.com/betafcc/Municipios-Brasileiros-TSE/master/municipios_brasileiros_tse.csv")

# ler com fread() // microdados - educacao basica / escolas
columns_selected <- c("IN_AGUA_POTAVEL", "IN_AGUA_REDE_PUBLICA", "IN_AGUA_POCO_ARTESIANO", "IN_AGUA_CACIMBA", "IN_AGUA_FONTE_RIO", "IN_AGUA_INEXISTENTE")

escolas <- fread("dados/microdados_educacao_basica_2020/DADOS/escolas.CSV",
                 nrows = 100,
                 select = columns_selected)

# ler com fread() // resolver problema com encoding
auxilio <- fread("dados/portal_da_transparencia/202008_AuxilioEmergencial.csv",
             nrows = 1000,
             encoding = "Latin-1")

# mostrar tambem como importar usando o mouse
# Import Dataset > From text (base)

########### CONHECENDO O DF

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
janitor::clean_names()

cifrao e [] para acessar dados
# vetor_idade_mun[4] <- 50

##### criar vetores
## criar DFs

# nome <- c('João', 'José', 'Maria', 'Joana')
# idade <- c(45, 12, 28)
# adulto <- c(TRUE, FALSE, TRUE, TRUE)
# uf <- c('DF', 'SP', 'RJ', 'MG')
# cor <- c("Branca", "Negra", "Branca", NA)

# clientes <- data.frame(nome, idade, adulto, uf, cor)

# regiao <- "Nordeste"
# uf <- c("MA", "PI", "CE", "RN", "PE", "PB", "SE", "AL", "BA")
# nordeste <- data.frame(regiao, uf)

paste()
paste0()
i <- 1:16 # número de páginas com atletas
urls <- paste0("http://www.cob.org.br/pt/cob/time-brasil/atletas?&page=", i)

is.na()
which()

# x1 <- c(10, NA, 20, NA, 30, 50, NA, NA, NA, 100)
# is.na(x1)
# which(is.na(x1))

mean()
median()
max()
min()

as.character()
as.integer()

ifelse()
# ifelse(100 > 1, "Certo/True", "Errado/False")
# ifelse(x3 < 500, x3 / 3, x3 * 9)


loops: if / map

# x3 = 1000
# if(x3 < 500){
#  print("Valor é menor que 500")
#  x4 = x3 + 100
#} else{
#  print("Valor é maior ou igual a 500")
#  x4 = x3 - 100
#  stop("Valor é maior. Pare aqui")
#}


##### MÁGICA DO MAP

path_2012 <- "dados/consulta_cand_2012/"
cand_2012 <- map_df(paste0(path_2012, list.files(path_2012, pattern = "*txt")), fread, 
                    encoding = "Latin-1")


