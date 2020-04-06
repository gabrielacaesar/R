################################################################
###                                                          ###
###                   O voto dos deputados                   ###
###                                                          ###
###                      gabriela caesar                     ###
###                                                          ###
################################################################

################################################################
###                 Inclusão de votação nova                 ###
################################################################

################################################################
###                     Votação virtual                      ###
################################################################

################################################################
###                      Primeira etapa                      ###
################################################################

#1. instalar as bibliotecas
install.packages("tidyverse")
install.packages("foreign")
install.packages("rvest")
install.packages("data.table")
install.packages("abjutils")

#2. ler as bibliotecas
library(tidyverse)
library(foreign)
library(rvest)
library(data.table)
library(abjutils)

#3. importar o arquivo novo de votação
deputados_id <- fread("~/Downloads/plenario2019_CD-politicos-4abr2020-2.csv")

resultado_votacao <- fread("~/Downloads/votacao_final_PEC10-2020-2t.csv")


#3. ou pegar o resultado via HTML
# caso nao importe o resultado via arquivo
url <- "https://www.camara.leg.br/presenca-comissoes/votacao-portal?reuniao=59543&itemVotacao=28632"

resultado_url <- url %>%
  read_html() %>%
  html_nodes(".titulares") %>%
  html_nodes("li") %>%
  html_text() %>%
  as.data.frame() %>%
  `colnames<-`("info")

### e separar por colunas
### no IMPORTHMTL eh a lista 13

#4. padronizar nomes

resultado_votacao$nome[resultado_votacao$nome == "Alencar S. Braga"] <- "Alencar Santana Braga"
resultado_votacao$nome[resultado_votacao$nome == "AlexandreSerfiotis"] <- "Alexandre Serfiotis"
resultado_votacao$nome[resultado_votacao$nome == "Arthur O. Maia"] <- "Arthur Oliveira Maia"
resultado_votacao$nome[resultado_votacao$nome == "Cap. Alberto Neto"] <- "Capitão Alberto Neto"
resultado_votacao$nome[resultado_votacao$nome == "Carlos Gaguim"] <- "Carlos Henrique Gaguim"
resultado_votacao$nome[resultado_votacao$nome == "Cezinha Madureira"] <- "Cezinha de Madureira"
resultado_votacao$nome[resultado_votacao$nome == "Charlles Evangelis"] <- "Charlles Evangelista"
resultado_votacao$nome[resultado_votacao$nome == "Chico D´Angelo"] <- "Chico D'Angelo"
resultado_votacao$nome[resultado_votacao$nome == "Christiane Yared"] <- "Christiane de Souza Yared"
resultado_votacao$nome[resultado_votacao$nome == "CoronelChrisóstom"] <- "Coronel Chrisóstomo"
resultado_votacao$nome[resultado_votacao$nome == "Daniela Waguinho"] <- "Daniela do Waguinho"
resultado_votacao$nome[resultado_votacao$nome == "Danrlei"] <- "Danrlei de Deus Hinterholz"
resultado_votacao$nome[resultado_votacao$nome == "DelAntônioFurtado"] <- "Delegado Antônio Furtado"
resultado_votacao$nome[resultado_votacao$nome == "Deleg. Éder Mauro"] <- "Delegado Éder Mauro"
resultado_votacao$nome[resultado_votacao$nome == "Delegado Marcelo"] <- "Delegado Marcelo Freitas"
resultado_votacao$nome[resultado_votacao$nome == "Dr Zacharias Calil"] <- "Dr. Zacharias Calil"
resultado_votacao$nome[resultado_votacao$nome == "Dr. Sinval"] <- "Dr. Sinval Malheiros"
resultado_votacao$nome[resultado_votacao$nome == "Dr.Luiz Antonio Jr"] <- "Dr. Luiz Antonio Teixeira Jr."
resultado_votacao$nome[resultado_votacao$nome == "Dra.Soraya Manato"] <- "Dra. Soraya Manato"
resultado_votacao$nome[resultado_votacao$nome == "EdmilsonRodrigues"] <- "Edmilson Rodrigues"
resultado_votacao$nome[resultado_votacao$nome == "EduardoBolsonaro"] <- "Eduardo Bolsonaro"
resultado_votacao$nome[resultado_votacao$nome == "Emanuel Pinheiro N"] <- "Emanuel Pinheiro Neto"
resultado_votacao$nome[resultado_votacao$nome == "EuclydesPettersen"] <- "Euclydes Pettersen"
resultado_votacao$nome[resultado_votacao$nome == "Evair de Melo"] <- "Evair Vieira de Melo"
resultado_votacao$nome[resultado_votacao$nome == "FelipeFrancischini"] <- "Felipe Francischini"
resultado_votacao$nome[resultado_votacao$nome == "Félix Mendonça Jr"] <- "Félix Mendonça Júnior"
resultado_votacao$nome[resultado_votacao$nome == "FernandaMelchionna"] <- "Fernanda Melchionna"
resultado_votacao$nome[resultado_votacao$nome == "Fernando Coelho"] <- "Fernando Coelho Filho"
resultado_votacao$nome[resultado_votacao$nome == "FernandoMonteiro"] <- "Fernando Monteiro"
resultado_votacao$nome[resultado_votacao$nome == "FernandoRodolfo"] <- "Fernando Rodolfo"
resultado_votacao$nome[resultado_votacao$nome == "Frei Anastacio"] <- "Frei Anastacio Ribeiro"
resultado_votacao$nome[resultado_votacao$nome == "GilbertoNasciment"] <- "Gilberto Nascimento"
resultado_votacao$nome[resultado_votacao$nome == "Gildenemyr"] <- "Pastor Gildenemyr"
resultado_votacao$nome[resultado_votacao$nome == "Hercílio Diniz"] <- "Hercílio Coelho Diniz"
resultado_votacao$nome[resultado_votacao$nome == "HermesParcianello"] <- "Hermes Parcianello"
resultado_votacao$nome[resultado_votacao$nome == "Isnaldo Bulhões Jr"] <- "Isnaldo Bulhões Jr."
resultado_votacao$nome[resultado_votacao$nome == "Israel Batista"] <- "Professor Israel Batista"
resultado_votacao$nome[resultado_votacao$nome == "João C. Bacelar"] <- "João Carlos Bacelar"
resultado_votacao$nome[resultado_votacao$nome == "João Marcelo S."] <- "João Marcelo Souza"
resultado_votacao$nome[resultado_votacao$nome == "JoaquimPassarinho"] <- "Joaquim Passarinho"
resultado_votacao$nome[resultado_votacao$nome == "José Airton"] <- "José Airton Cirilo"
resultado_votacao$nome[resultado_votacao$nome == "Jose Mario Schrein"] <- "Jose Mario Schreiner"
resultado_votacao$nome[resultado_votacao$nome == "Julio Cesar Ribeir"] <- "Julio Cesar Ribeiro"
resultado_votacao$nome[resultado_votacao$nome == "Junio Amaral"] <- "Cabo Junio Amaral"
resultado_votacao$nome[resultado_votacao$nome == "Lafayette Andrada"] <- "Lafayette de Andrada"
resultado_votacao$nome[resultado_votacao$nome == "Leur Lomanto Jr."] <- "Leur Lomanto Júnior"
resultado_votacao$nome[resultado_votacao$nome == "Luiz P. O.Bragança"] <- "Luiz Philippe de Orleans e Bragança"
resultado_votacao$nome[resultado_votacao$nome == "LuizAntônioCorrêa"] <- "Luiz Antônio Corrêa"
resultado_votacao$nome[resultado_votacao$nome == "Marcos A. Sampaio"] <- "Marcos Aurélio Sampaio"
resultado_votacao$nome[resultado_votacao$nome == "MargaridaSalomão"] <- "Margarida Salomão"
resultado_votacao$nome[resultado_votacao$nome == "MárioNegromonte Jr"] <- "Mário Negromonte Jr."
resultado_votacao$nome[resultado_votacao$nome == "Maurício Dziedrick"] <- "Maurício Dziedricki"
resultado_votacao$nome[resultado_votacao$nome == "Mauro Benevides Fº"] <- "Mauro Benevides Filho"
resultado_votacao$nome[resultado_votacao$nome == "Nivaldo Albuquerq"] <- "Nivaldo Albuquerque"
resultado_votacao$nome[resultado_votacao$nome == "Ottaci Nascimento"] <- "Otaci Nascimento"
resultado_votacao$nome[resultado_votacao$nome == "Otto Alencar"] <- "Otto Alencar Filho"
resultado_votacao$nome[resultado_votacao$nome == "Pastor Isidório"] <- "Pastor Sargento Isidório"
resultado_votacao$nome[resultado_votacao$nome == "Paulo Martins"] <- "Paulo Eduardo Martins"
resultado_votacao$nome[resultado_votacao$nome == "Paulo Pereira"] <- "Paulo Pereira da Silva"
resultado_votacao$nome[resultado_votacao$nome == "Pedro A Bezerra"] <- "Pedro Augusto Bezerra"
resultado_votacao$nome[resultado_votacao$nome == "Pedro Lucas Fernan"] <- "Pedro Lucas Fernandes"
resultado_votacao$nome[resultado_votacao$nome == "Policial Sastre"] <- "Policial Katia Sastre"
resultado_votacao$nome[resultado_votacao$nome == "Pr Marco Feliciano"] <- "Pr. Marco Feliciano"
resultado_votacao$nome[resultado_votacao$nome == "Prof Marcivania"] <- "Professora Marcivania"
resultado_votacao$nome[resultado_votacao$nome == "Profª Dorinha"] <- "Professora Dorinha Seabra Rezende"
resultado_votacao$nome[resultado_votacao$nome == "Profª Rosa Neide"] <- "Professora Rosa Neide"
resultado_votacao$nome[resultado_votacao$nome == "Professora Dayane"] <- "Professora Dayane Pimentel"
resultado_votacao$nome[resultado_votacao$nome == "Rogério Peninha"] <- "Rogério Peninha Mendonça"
resultado_votacao$nome[resultado_votacao$nome == "Roman"] <- "Evandro Roman"
resultado_votacao$nome[resultado_votacao$nome == "SóstenesCavalcante"] <- "Sóstenes Cavalcante"
resultado_votacao$nome[resultado_votacao$nome == "Stephanes Junior"] <- "Reinhold Stephanes Junior"
resultado_votacao$nome[resultado_votacao$nome == "SubtenenteGonzaga"] <- "Subtenente Gonzaga"
resultado_votacao$nome[resultado_votacao$nome == "ToninhoWandscheer"] <- "Toninho Wandscheer"
resultado_votacao$nome[resultado_votacao$nome == "Vitor Hugo"] <- "Major Vitor Hugo"
resultado_votacao$nome[resultado_votacao$nome == "Wellington"] <- "Wellington Roberto"
resultado_votacao$nome[resultado_votacao$nome == "WladimirGarotinho"] <- "Wladimir Garotinho"

#5. padronizar partidos

resultado_votacao$partido[resultado_votacao$partido == "NOVO"] <- "Novo"
resultado_votacao$partido[resultado_votacao$partido == "CIDADANIA"] <- "Cidadania"
resultado_votacao$partido[resultado_votacao$partido == "REDE"] <- "Rede"
resultado_votacao$partido[resultado_votacao$partido == "SOLIDARIEDADE"] <- "SD"
resultado_votacao$partido[resultado_votacao$partido == "PODEMOS"] <- "PODE"
resultado_votacao$partido[resultado_votacao$partido == "PATRIOTA"] <- "Patriota"
resultado_votacao$partido[resultado_votacao$partido == "AVANTE"] <- "Avante"
resultado_votacao$partido[resultado_votacao$partido == "REPUBLICANOS"] <- "Republicanos"



#6. tirar acentos e colocar caixa alta

resultado_votacao <- resultado_votacao %>%
  mutate(nome_upper = toupper(rm_accent(nome)))


#7. cruzar planilhas
joined_data <- resultado_votacao %>%
  left_join(deputados_id, by = "nome_upper") %>%
  arrange(desc(id))

#8. checar PARTIDO
check_partido <- joined_data %>%
  mutate(check = ifelse(`partido.x` == `partido.y`, "match", "not_match")) %>%
  filter(check == "not_match") %>%
  select(nome_upper, `partido.x`, `partido.y`, `uf.y`, `uf.x`, check)

#9. checar UF
check_uf <- joined_data %>%
  mutate(check = ifelse(`uf.x` == `uf.y`, "match", "not_match")) %>%
  filter(check == "not_match") %>%
  select(nome_upper, `partido.x`, `partido.y`, `uf.y`, `uf.x`, check)


#10. selecionar as colunas que queremos no nosso arquivo

votacao_final <- joined_data %>%
  rename("nome_politico" = nome.y,
         "partido" = partido.y,
         "uf" = uf.y,
         "id_politico" = id) %>%
  mutate(id_proposicao = "45",
         proposicao = "PEC10-2020-2t",
         permalink = "pec-do-orcamento-de-guerra-2-turno") %>%
  select("id_proposicao", "proposicao", "partido", "id_politico", 
         "nome_upper", "nome_politico", "uf", "voto", "permalink") %>% 
  arrange(nome_upper)

#11. fazer o download

write.csv(votacao_final, "votacao_final_PEC10-2020-2t-ESTE.csv")

#12. checar exercicio
joined_data <- deputados_id %>%
  left_join(resultado_votacao, by = "nome_upper") %>%
  arrange(desc(id)) %>%
  filter(!is.na(voto),
         exercicio != "sim")

joined_data <- deputados_id %>%
  left_join(resultado_votacao, by = "nome_upper") %>%
  arrange(desc(id)) %>%
  filter(is.na(voto),
         exercicio != "nao")
