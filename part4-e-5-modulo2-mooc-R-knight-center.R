# módulo 2
# parte 4 e 5, com dplyr
# knight center


source("import_murders.R")

View(murders)

dc_annual_murders1 <- filter(murders, State == "District of Columbia")
dc_annual_murders2 <- group_by(dc_annual_murders1, Year)
dc_annual_murders3 <- summarize(dc_annual_murders2, total=n())
dc_annual_murders4 <- arrange(dc_annual_murders3, desc(total))


#são duas opções iguais:
# 1
filter(murders, OffAge == 2)
# 2
murders %>% filter(OffAge == 2)


murders %>% filter(State == "District of Columbia") %>%
  group_by(Year) %>%
  summarize(total = n()) %>%
  arrange(desc(total))

#para fazer o pipe com atalho
#digite: ctrl + shift + m

#abaixo, criamos uma nova coluna
#chamada "previous_year" em que 
#o valor é o valor da coluna total
#da linha superior

murders %>% filter(State == "District of Columbia") %>%
  group_by(Year) %>%
  summarize(total = n()) %>%
  mutate(previous_year=lag(total))

#agora queremos criar outra coluna
#cujo valor é resultado de uma subtração
#de valores de outras colunas

murders %>% filter(State == "District of Columbia") %>%
  group_by(Year) %>%
  summarize(total = n()) %>%
  mutate(previous_year=lag(total))%>%
  mutate(change = previous_year - total)

#vamos continuar complicando a operação
#tudo vai para a var "years"
#e depois a gente ainda faz novo mutate

years <- murders %>% filter(State == "District of Columbia") %>%
  group_by(Year) %>%
  summarize(total = n()) %>%
  mutate(previous_year=lag(total))%>%
  mutate(change = previous_year - total)

years %>% mutate(all_murders=sum(total))

#group by
#agrupamos as vítimas por gênero
#e depois contamos as ocorrências

murders %>% 
  group_by(VicSex_label) %>% 
  summarize(total=n())

#se quiséssemos fazer essa mesma
#operação, mas considerando o estado

murders %>% 
  group_by(State, VicSex_label) %>% 
  summarize(total=n())

##
#percentualmente, quanto dos homicídios
#foram de H ou de M por estado

percent_murders <- murders %>% 
  group_by(State, VicSex_label) %>% 
  summarize(total=n()) %>% 
  mutate(percent=total/sum(total)*100)
percent_murders

#

percent_murders_women <- murders %>% 
  group_by(State, VicSex_label) %>% 
  summarize(total=n()) %>% 
  mutate(percent=total/sum(total)*100) %>% 
  filter(VicSex_label == "Female") %>% 
  arrange(desc(percent))
  #ou arrange(-percent)
percent_murders_women

#############################
####### part 5 ##############
#############################

murders %>% 
  group_by(State, Year) %>% 
  summarize(cases=n(), solved=sum(Solved_value))

glimpse(murders)

murders %>% 
  group_by(VicRace_label) %>% 
  count()

install.packages("DT")
library(DT)

unsolved <- murders %>% 
  group_by(MSA_label, Solved_label) %>% 
  filter(Year > 2008) %>% 
  summarize(cases = n())

# mostra uma tabela interativa com busca
datatable(unsolved)

# agora com mais uma coluna
murders %>% 
  group_by(MSA_label, Solved_label) %>% 
  filter(Year > 2008) %>% 
  summarize(cases = n()) %>% 
  mutate(percent=cases/sum(cases)*100) %>% 
  datatable()


# agora com dois filtros
# e com o select
murders %>% 
  group_by(MSA_label, Solved_label) %>% 
  filter(Year > 2008) %>% 
  summarize(cases = n()) %>% 
  filter(cases>10) %>% 
  mutate(percent=cases/sum(cases)*100) %>% 
  filter(Solved_label=="No") %>% 
  select(Metro=MSA_label, cases_unsolved=cases, percent_unsolved=percent) %>% 
  datatable()


murders %>% 
  group_by(MSA_label, VicRace_label, Solved_label) %>% 
  filter(Year > 2008) %>% 
  summarize(cases = n()) %>% 
  mutate(percent=cases/sum(cases)*100) %>% 
  datatable()



race <- murders %>% 
  group_by(MSA_label, VicRace_label, Solved_label) %>% 
  filter(Year > 2008) %>% 
  summarize(cases = n()) %>% 
  mutate(percent=cases/sum(cases)*100) %>% 
  filter(Solved_label == "No") %>% 
  select(Metro=MSA_label, cases_unsolved=cases, percent_unsolved=percent) %>% 
  arrange(desc(percent_unsolved)) %>% 
  datatable()

####### spread()
install.packages("tidyr")
library(tidyr)

race %>% 
  select(-cases_unsolved) %>% 
  spread(VicRace_label, percent_unsolved) %>% 
  datatable()


race_percent <- race %>% 
  select(-cases_unsolved) %>% 
  spread(VicRace_label, percent_unsolved)

##### gather()


race_percent %>% 
  gather("Race", "Percent_Unsolved", 2:6) %>% 
  datatable()


race_percent %>% 
  gather("Race", "Percent_Unsolved", 'Asian or Pacific Islander':White) %>% 
  datatable()


#### acabou a parte 5 do módulo 2
## no próximo vídeo a gente aprenderá o 'join'


