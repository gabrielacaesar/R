1 + 4
2 - 1
5 - 1
10 + 2
10 ** 2
10 / 2
10 %% 3

#exemplo de comentário no R

pi

#funcao de soma
sum(1,10)
sum(2,3,4)

soma_da_gabr <- sum(27,8,1992)
soma_da_gabr

resultado_da_soma <- sum(5,6,7)
resultado_da_soma

#a variavel nao pode ter hifen no nome
#porque o R entende como subtracao

x <- 2
y <- 3
z <- 4

x+y+z

#para remover as var, use "rm"
#por exemplo, rm(x,y,z)

x <- 2.1
x+y+z

#eu alterei o valor da var

rm(soma_da_gabr)
#removi a var acima

class(TRUE)
class("1")
class(1)
class(1.1)
class(x)
class("gabr")

var1 <- 1
w <- as.integer(var1)
class(w)
#acima o numero de ser numeric
#e foi considerado inteiro

install.packages("data.table")
#acima eh o equivalente a pip install

library(data.table)
#acima eh o equivalente a import

idh <- fread(file = "idh.csv")
idh

setwd("Z:/alunos")
#mudando o caminho para achar o arquivo

getwd()
#descobrimos qual a pasta em que estamos

idh <- fread(file = "idh.csv")
View(idh)

library(readxl)
fifa2018 <- read_excel("fifa2018.xlsx", col_types = c("text", 
                                                      "text", "text", "text", "text", "text", 
                                                      "text", "text", "numeric", "numeric", 
                                                      "numeric", "text"))
View(fifa2018)
#o codigo acima foi tirado
#de file > import dataset > from excel

install.packages("dplyr")

#quando estiver instalando o pacote,
# e tiver aquele simbolo vermelho
#escrito stop, no canto direito
#do console, é porque ele ainda está baixando

library(dplyr)

glimpse(fifa2018)
#o comando acima dá uma visao
#geral do arquivo


fifa2018_1 <- fifa2018 %>%
  mutate(esporte = "futebol")

glimpse(fifa2018_1)
#criamos uma nova coluna de nome "esporte"
#cujos valores sao "futebol"
# %>% significa "entao"
#ou seja, o que vem depois se refere
#àquela linha citada

fifa2018_2 <- fifa2018 %>%
  mutate(media_gols = goals/caps)

glimpse(fifa2018_2)
#criamos uma nova coluna chamada "media_gols"
#cujo valor eh resultado de uma operacao


round(4.567899765 , 1) #uma casa decimal
round(4.567899765 , 3) #três casas decimais

fifa2018_2 <- fifa2018 %>%
  mutate(media_gols = round(goals/caps, 1))

glimpse(fifa2018_2)
#nao se esquecer do 'round' para arrendondar
# a media de gols




# Exemplo

vetor_texto <- c("22", "23", "24")        #criando o vetor
class(vetor_texto)                        #verificando a classe do vetor 

# Transformando em numeric:
vetor_texto <- as.numeric(vetor_texto)    
class(vetor_texto)

# Transformando outra vez em character:
vetor_texto <- as.character(vetor_texto)
class(vetor_texto)

####################

fifa2018_1 <- fifa2018 %>%
  mutate(goals = as.character(goals))

glimpse(fifa2018_1)

# Viram? e agora outra vez:

fifa2018_1 <- fifa2018_1 %>%
  mutate(goals = as.numeric(goals))

glimpse(fifa2018_1)

############
#modificando as datas

#"10.02.1986" -> "%d.%m.%Y"
# ano com 4 digitos eh Y maiusculo
# ano com 2 digitos eh y minusculo

fifa2018_2 <- fifa2018 %>%
  mutate(day_of_birth = as.Date(day_of_birth, format="%d.%m.%Y"))

glimpse(fifa2018_2)

###
#abaixo nos justamos todas as modificacoes
#no dataset original
fifa2018_1 <- fifa2018 %>%     
  mutate(esporte = "futebol") %>%                # Esporte = Futebol
  mutate(media_gols = round(goals/caps, 1)) %>%  # Coluna de média de gols por jogos com 1 casa decimal
  mutate(height = (height/100)) %>%              # Altura dos jogadores em metros
  mutate(day_of_birth = as.Date(day_of_birth, format="%d.%m.%Y"))  # Convertendo dia do nascimento em data.

glimpse(fifa2018_1)

#agora de uma forma que nao repita tantas vezes
#o mutate; veja abaixo que o resultado eh o mesmo

fifa2018_1 <- fifa2018 %>%  
  mutate(esporte = "futebol",
         media_gols = round(goals/caps , 1),
         height = (height/100),
         day_of_birth = as.Date(day_of_birth, format="%d.%m.%Y"))

glimpse(fifa2018_1)

##

fifa2018_1 <- fifa2018 %>%
  rename(jogos_com_a_selecao = caps) #sem acento e sem espaço

glimpse(fifa2018_1)
#acima mudamos o nome de uma coluna
#entre parentesis: o que eh novo e depois o que eh velho

####################
unique(fifa2018_1$team)
# me devolve valores unicos da coluna team

#dplyr:filter

# Brasil:
brasil <- fifa2018_1 %>%
  filter(team == "Brazil")

glimpse(brasil)

# América do Sul:
america_do_sul <- fifa2018_1 %>%
  filter(team == "Brazil" | team == "Argentina" | team == "Colombia" | team == "Peru" | team == "Uruguay")

glimpse(america_do_sul)
unique(america_do_sul$team)
# Jogadores do Brasil com 2 ou mais gols:
brasil2 <- fifa2018_1 %>%
  filter(team == "Brazil" & goals >=2)

glimpse(brasil2)

# Jogadores do Irã com mais de 20 anos (nascidos antes de 1998):
ira <- fifa2018_1 %>%
  filter(team == "IR Iran" & day_of_birth < "1998-01-01")

glimpse(ira)

# Apenas os jogadores que fizeram gols:
jog_gols <- fifa2018_1 %>%
  filter(goals != 0)

glimpse(jog_gols)

####

x <- fifa2018_1 %>%
  filter(jogos_com_a_selecao == 0)
glimpse(x)

#acima sao jogadores que nao tinham partida na selecao

top5 <- fifa2018_1 %>%
  arrange(desc(goals)) %>%                # ordenando os gols em ordem decrescente
  slice(1:5) %>%                          # selecionando as 5 primeiras linhas
  select(fifa_display_name, team, goals) #selecionando as colunas

top5

####
gols_time <- fifa2018_1 %>%
  group_by(team) %>%                      # agrupando por "team"
  summarise(gols_feitos = sum(goals))     # somando os valores da coluna "goals"

gols_time

#agrupe pela variavel time
#os valores sao a soma de gols

##############
gols_time <- fifa2018_1 %>%
  group_by(team) %>%                      # agrupando por "team"
  summarise(gols_feitos = sum(goals)) %>%     # somando os valores da coluna "goals"
  arrange(desc(gols_feitos))

gols_time
##acima a gente ainda ordenou por ordem decrescente
############
gols_time <- fifa2018_1 %>%
  group_by(team) %>%                      # agrupando por "team"
  summarise(gols_feitos = sum(goals)) %>%     # somando os valores da coluna "goals"
  arrange(desc(gols_feitos)) %>%
  slice(1:20)

gols_time
##acima a gente ainda pediu os 20 selecoes com mais gols
# e nao o default de mostrar 10 selecoes

##############
# EXERCICIO

#questao 1
top_5_times <- fifa2018_1 %>%
  group_by(team) %>%
  summarise(soma_gols = sum(goals)) %>%
  arrange(desc(soma_gols)) %>%
  slice(1:5)

top_5_times

#questao 2
altura_time <- fifa2018_1 %>%
  group_by(team) %>%
  summarise(altura_media = mean(height)) %>%
  arrange(desc(altura_media))
altura_time

#questao 2.2
x <- altura_time %>%
  filter(team == "Brazil")
glimpse(x)

#questao 3
numero_de_jogadores <- fifa2018_1 %>%
  group_by(team) %>%
  summarise(n_de_jogadores = n())
numero_de_jogadores
## n() contou o numero de linhas, sendo que cada uma é um jogador
# printamos que ha 23 jogadores em cada selecao

#questao 4
jogadores_por_clube <- fifa2018_1 %>%
  group_by(club) %>%
  summarise(n_de_jogadores = n()) %>%
  arrange(desc(n_de_jogadores))
jogadores_por_clube

## a gente agrupou por clube
# e contou o numero de jogadores por clube
# e colocou em ordem decrescente


#agora vamos salvar o arquivo

getwd()
setwd("C:/Users/lab735/Desktop")

fwrite(fifa2018_1, file="fifa2018_1_gabriela_caesar.csv")

library(readxl)
write.xlsx(fifa2018_1, file="fifa2018_1_gabriela_caesar.xlsx")

### agora vamos juntar dois datasets
idh <- fread(file = "idh.csv")

glimpse(idh)


copa_idh <- fifa2018_1 %>%
  left_join(idh, by=c("team" = "country"))

glimpse(copa_idh)
##team e country sao as colunas convergentes e servem para a junção
View(copa_idh)

###
#outra opcao de fazer a mesma coisa
copa_idh <- fifa2018_1 %>%
  rename(country = team) %>% #renomeamos o cabeçalho da coluna
  left_join(idh) #as duas tinham o mesmo nome e nós juntamos

glimpse(copa_idh)

###
a <- fifa2018_1 %>%
  group_by(team) %>%
  summarise(soma_gols = sum(goals)) %>%
  left_join(idh, by=c("team" = "country")) %>%
  select("team", "soma_gols", "hdi_rank_2015") %>%
  arrange(desc(soma_gols))

View(a)

#########
#vamos salvar em xlsx
install.packages("xlsx")
library(xlsx)

write.xlsx(as.data.frame(fifa2018_1),
           file="fifa2018_1_gabriela_caesar.xlsx", sheetName="object",
           col.names=TRUE, row.names=FALSE, append=FALSE, showNA=FALSE)

?write.xlsx
#acima eh para ver a documentação

##################

#se quisermos alterar apenas uma celula
#a gente pode usar o codigo abaixo
#o problema eh que vc nao registra no script
#especificamente o que foi alterado

idh <- fix(idh) #mudei de Russian Federation para Russia
idh %>%
  filter(country == "Russia")


