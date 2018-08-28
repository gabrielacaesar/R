# módulo 2
# parte 1 e 2, com dplyr
# knight center

############## PARTE 1
usethis::use_course("https://github.com/r-journalism/learn-chapter-3/archive/master.zip")

# o que vamos aprender
# filter
# select
# arrange
# mutate
# summarize
# group by

############### PARTE 2

source("import_murders.R")

View(murders)

# informa o número de linhas
# sendo que cada linha é um homicídio
nrow(murders)

# contamos as ocorrências únicas na coluna
# contamos quantas são
how_many <- unique(murders$MSA_label)
length(how_many)

# dá uma lista das variáveis do DF
# mostra as primeiras linhas de cada coluna
glimpse(murders)

# usando o filter
# cite primeiro o DF, que é "murders"

filter(murders, Relationship_label == "Husband", VicAge > 60, Year == 2016)

# colocamos dentro de uma variável
# filtro é por 3 colunas, conforme consta abaixo:

df1 <- filter(murders, Relationship_label == "Husband", VicAge > 60, Year == 2016)
View(df1)

# fazendo a mesma coisa, só que com &
df2 <- filter(murders, Relationship_label == "Husband" & VicAge > 60 & Year == 2016)
View(df2)

# abaixo, a gente está dizendo:
# que o valor da coluna contenha uma das palavras
# husband e boyfriend
df3 <- filter(murders, Relationship_label %in% c("Husband", "Boyfriend"))
View(df3)

# também podemos acrescentar para termos as linhas
# se a linha também tiver a ocorrência de "lovers triange" de outra coluna
df4 <- filter(murders, Relationship_label %in% c("Husband", "Boyfriend") | Circumstance_label == "Lovers triangle")
View(df4)

# != significa diferente
# == significa igual
# isTRUE() se é verdadeiro ou não 
# is.na() significa é NA / not avaliable
# !is.na() significa que não é NA / not avaliable


##### SELECT
# select()

# escolhemos as colunas que queremos
df1_narrow <- select(df1, State, Agency, Solved_label, Year)
View(df1_narrow)

# vamos trazer para o novo DF todas as colunas
# entre as colunas solved_label e incident
df2_narrow <- select(df1, State, Agency, Solved_label:Incident)
View(df2_narrow)

# agora queremos o DF exceto uma das colunas
df3_narrow <- select(df2_narrow, -Incident)
View(df3_narrow)

# agora queremos apenas as colunas que
# têm a palavra "_label" no header

labels_only_columns <- select(murders, contains("_label"))
View(labels_only_columns)

##### ARRANGE
# arrange()

# agora estamos ordenando pela coluna VicAge
# assim, os valores iguais ficam próximos
age_df1 <- arrange(murders, VicAge)
View(age_df1)

# agora ordenamos por duas colunas
# primeiro, é considerada "VicAge"
# e depois a coluna "OffAge"
age_df2 <- arrange(murders, VicAge, OffAge)
View(age_df2)

# se quiser em ordem decrescente, em vez de crescente
# aí usamos desc()
age_df3 <- arrange(murders, VicAge, desc(OffAge))
View(age_df3)

# na tabela abaixo, vimos que há vários "999"
# usaram esse valor para casos não informados
# por isso, poderíamos filtrar para o DF
# não ter casos com esse valor 
table(murders$OffAge)

############## PARTE 3

######## MUTATE
# mutate()

# agora queremos criar uma nova coluna
# que seja o resulta da subtração abaixo
murders_ver2 <- mutate(murders, age_difference = OffAge - VicAge)
View(murders_ver2)

# se quisermos criar duas colunas novas:
murders_ver3 <- mutate(murders, age_difference = OffAge - VicAge, age_difference2 = VicAge - OffAge)
View(murders_ver3)

######## CASE_WHEN()
# agora, além de criarmos a nova coluna,
# a gente ainda cria uma coluna que escreve "white"
# quando o valor de outra for "white";
# e coloca "non-white" quando o valor for diferente de "white"
murders_ver4 <- mutate(murders, age_difference = OffAge - VicAge, 
                       vic_category = case_when(
                         VicRace_label == "White" ~ "White",
                         VicRace_label != "White" ~ "Non-White"
                       ))
View(murders_ver4)

######## RENAME()

# queremos saber o nome das colunas
colnames(df3_narrow)

# agora renomeamos os nomes das colunas
df3_renamed <- rename(df3_narrow,
                      Solved=Solved_label,
                      Month=Month_label)
View(df3_renamed)
colnames(df3_renamed)

# se quisermos manter outro coluna além 
# das que nós acabamos de renomear
# usamos SELECT em vez de rename
df4_renamed <- select(df3_narrow,
                      State,
                      Solved=Solved_label,
                      Month=Month_label)
View(df4_renamed)
colnames(df4_renamed)

########### summarize()

# indicamos qual é a média da coluna VicAge
summarize(murders, average_victim_age = mean(VicAge))

# agora temos as médias de duas colunas
summarize(murders, average_victim_age = mean(VicAge), average_offender_age=mean(OffAge))

# vamos tirar os valores "999" 
# e repetir a operação
murders_filtered = filter(murders, OffAge != 999)
summarize(murders_filtered, average_victim_age = mean(VicAge), average_offender_age=mean(OffAge))

# agora queremos saber:
# o primeiro ano e o último
# MSA_label mostra o número de ocorrências únicas / length(unique(x))
# o número de linhas, ou seja, casos
summarize(murders_filtered, 
          first=min(Year),
          last=max(Year),
          metro_areas=n_distinct(MSA_label),
          cases=n())

########### GROUP_BY()
# é bom para agregar antes de reordenar, por exemplo

# abaixo a gente conta o número de casos, por MSA_label (local)
# o ano de início dos dados e o final também
murders <- group_by(murders, MSA_label)

summarize(murders, 
          first=min(Year),
          last=max(Year),
          cases=n())

############# FIM

### próximo será a parte QUATRO do módulo 2


