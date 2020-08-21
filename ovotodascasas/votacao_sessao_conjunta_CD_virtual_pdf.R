library(tidyverse)
library(foreign)
library(rvest)
library(data.table)
library(abjutils)

deputados_id <- fread("~/Downloads/plenario2019_CD-politicos.csv")

url <- fread("~/Downloads/reajuste-cd.csv")

resultado_url_split <- url %>%
  separate(nome, into = c("nome", "info"), sep = "\\(") %>%
  separate(info, into = c("partido", "uf"), sep = "-") %>%
  mutate(uf = str_remove_all(uf, " *\\)")) %>%
  mutate(nome = str_trim(nome),
         voto = str_trim(voto),
         voto = str_remove_all(voto, "votou"),
         voto = str_replace_na(voto, "ausente"),
         voto = str_replace_all(voto, "Sim", "sim"),
         voto = str_replace_all(voto, "Não", "nao"),
         voto = str_replace_all(voto, "Abstenção", "abstencao"),
         voto = str_replace_all(voto, "Obstrução", "obstrucao"),
         voto = str_replace_all(voto, "Presidente", "naovotou"))

resultado_votacao <- resultado_url_split

#5. padronizar nomes
resultado_votacao <- resultado_url_split %>%
  mutate(nome = str_replace_all(nome,
                                "Alencar S. Braga", "Alencar Santana Braga"), 
         nome = str_replace_all(nome,
                                "AlexandreSerfiotis", "Alexandre Serfiotis"),
         nome = str_replace_all(nome,
                                "Arthur O. Maia", "Arthur Oliveira Maia"),
         nome = str_replace_all(nome,
                                "Cap. Alberto Neto", "Capitão Alberto Neto"),
         nome = str_replace_all(nome,
                                "Carlos Gaguim", "Carlos Henrique Gaguim"),
         nome = str_replace_all(nome,
                                "Cezinha Madureira", "Cezinha de Madureira"),
         nome = str_replace_all(nome,
                                "Charlles Evangelis", "Charlles Evangelista"),
         nome = str_replace_all(nome,
                                "Chico D´Angelo", "Chico D'Angelo"),
         nome = str_replace_all(nome,
                                "Christiane Yared", "Christiane de Souza Yared"),
         nome = str_replace_all(nome,
                                "CoronelChrisóstom", "Coronel Chrisóstomo"),
         nome = str_replace_all(nome,
                                "Daniela Waguinho", "Daniela do Waguinho"),
         nome = str_replace_all(nome,
                                "Danrlei", "Danrlei de Deus Hinterholz"),
         nome = str_replace_all(nome,
                                "DelAntônioFurtado", "Delegado Antônio Furtado"),
         nome = str_replace_all(nome,
                                "Deleg. Éder Mauro", "Delegado Éder Mauro"),
         nome = str_replace_all(nome,
                                "Delegado Marcelo", "Delegado Marcelo Freitas"),
         nome = str_replace_all(nome,
                                "Dr Zacharias Calil", "Dr. Zacharias Calil"),
         nome = str_replace_all(nome,
                                "Dr. Sinval", "Dr. Sinval Malheiros"),
         nome = str_replace_all(nome,
                                "Dr.Luiz Antonio Jr", "Dr. Luiz Antonio Teixeira Jr."),
         nome = str_replace_all(nome,
                                "Dra.Soraya Manato", "Dra. Soraya Manato"),
         nome = str_replace_all(nome,
                                "EdmilsonRodrigues", "Edmilson Rodrigues"),
         nome = str_replace_all(nome,
                                "EduardoBolsonaro", "Eduardo Bolsonaro"),
         nome = str_replace_all(nome,
                                "Emanuel Pinheiro N", "Emanuel Pinheiro Neto"),
         nome = str_replace_all(nome,
                                "EuclydesPettersen", "Euclydes Pettersen"),
         nome = str_replace_all(nome,
                                "Evair de Melo", "Evair Vieira de Melo"),
         nome = str_replace_all(nome,
                                "FelipeFrancischini", "Felipe Francischini"),
         nome = str_replace_all(nome,
                                "Félix Mendonça Jr", "Félix Mendonça Júnior"),
         nome = str_replace_all(nome,
                                "FernandaMelchionna", "Fernanda Melchionna"),
         nome = str_replace_all(nome,
                                "Fernando Coelho", "Fernando Coelho Filho"),
         nome = str_replace_all(nome,
                                "FernandoMonteiro", "Fernando Monteiro"),
         nome = str_replace_all(nome,
                                "FernandoRodolfo", "Fernando Rodolfo"),
         nome = str_replace_all(nome,
                                "Frei Anastacio", "Frei Anastacio Ribeiro"),
         nome = str_replace_all(nome,
                                "GilbertoNasciment", "Gilberto Nascimento"),
         nome = str_replace_all(nome,
                                "Gildenemyr", "Pastor Gildenemyr"),
         nome = str_replace_all(nome,
                                "Hercílio Diniz", "Hercílio Coelho Diniz"),
         nome = str_replace_all(nome,
                                "HermesParcianello", "Hermes Parcianello"),
         nome = str_replace_all(nome,
                                "Isnaldo Bulhões Jr", "Isnaldo Bulhões Jr."),
         nome = str_replace_all(nome,
                                "Israel Batista", "Professor Israel Batista"),
         nome = str_replace_all(nome,
                                "João C. Bacelar", "João Carlos Bacelar"),
         nome = str_replace_all(nome,
                                "João Marcelo S.", "João Marcelo Souza"),
         nome = str_replace_all(nome,
                                "JoaquimPassarinho", "Joaquim Passarinho"),
         nome = str_replace_all(nome,
                                "José Airton", "José Airton Cirilo"),
         nome = str_replace_all(nome,
                                "Jose Mario Schrein", "Jose Mario Schreiner"),
         nome = str_replace_all(nome,
                                "Julio Cesar Ribeir", "Julio Cesar Ribeiro"),
         nome = str_replace_all(nome,
                                "Junio Amaral", "Cabo Junio Amaral"),
         nome = str_replace_all(nome,
                                "Lafayette Andrada", "Lafayette de Andrada"),
         nome = str_replace_all(nome,
                                "Leur Lomanto Jr.", "Leur Lomanto Júnior"),     
         nome = str_replace_all(nome,
                                "Luiz P. O.Bragança", "Luiz Philippe de Orleans e Bragança"),
         nome = str_replace_all(nome,
                                "LuizAntônioCorrêa", "Luiz Antônio Corrêa"),
         nome = str_replace_all(nome,
                                "Marcos A. Sampaio", "Marcos Aurélio Sampaio"),
         nome = str_replace_all(nome,
                                "MargaridaSalomão", "Margarida Salomão"),
         nome = str_replace_all(nome,
                                "MárioNegromonte Jr", "Mário Negromonte Jr."),
         nome = str_replace_all(nome,
                                "Maurício Dziedrick", "Maurício Dziedricki"),
         nome = str_replace_all(nome,
                                "Mauro Benevides Fº", "Mauro Benevides Filho"),
         nome = str_replace_all(nome,
                                "Nivaldo Albuquerq", "Nivaldo Albuquerque"),
         nome = str_replace_all(nome,
                                "Ottaci Nascimento", "Otaci Nascimento"),
         nome = str_replace_all(nome,
                                "Otto Alencar", "Otto Alencar Filho"),
         nome = str_replace_all(nome,
                                "Pastor Isidório", "Pastor Sargento Isidório"),
         nome = str_replace_all(nome,
                                "Paulo Martins", "Paulo Eduardo Martins"),
         nome = str_replace_all(nome,
                                "Paulo Pereira", "Paulo Pereira da Silva"),
         nome = str_replace_all(nome,
                                "Pedro A Bezerra", "Pedro Augusto Bezerra"),
         nome = str_replace_all(nome,
                                "Pedro Lucas Fernan", "Pedro Lucas Fernandes"),
         nome = str_replace_all(nome,
                                "Policial Sastre", "Policial Katia Sastre"),
         nome = str_replace_all(nome,
                                "Pr Marco Feliciano", "Pr. Marco Feliciano"),
         nome = str_replace_all(nome,
                                "Prof Marcivania", "Professora Marcivania"),
         nome = str_replace_all(nome,
                                "Profª Dorinha", "Professora Dorinha Seabra Rezende"),
         nome = str_replace_all(nome,
                                "Profª Rosa Neide", "Professora Rosa Neide"),
         nome = str_replace_all(nome,
                                "Professora Dayane", "Professora Dayane Pimentel"),
         nome = str_replace_all(nome,
                                "Rogério Peninha", "Rogério Peninha Mendonça"),
         nome = str_replace_all(nome,
                                "Roman", "Evandro Roman"),
         nome = str_replace_all(nome,
                                "SóstenesCavalcante", "Sóstenes Cavalcante"),
         nome = str_replace_all(nome,
                                "Stephanes Junior", "Reinhold Stephanes Junior"),
         nome = str_replace_all(nome,
                                "SubtenenteGonzaga", "Subtenente Gonzaga"),
         nome = str_replace_all(nome,
                                "ToninhoWandscheer", "Toninho Wandscheer"),
         nome = str_replace_all(nome,
                                "Vitor Hugo", "Major Vitor Hugo"),
         nome = str_replace_all(nome,
                                "Wellington", "Wellington Roberto"),
         nome = str_replace_all(nome,
                                "WladimirGarotinho", "Wladimir Garotinho"),
         nome = str_replace_all(nome,
                                "Cap. Fábio Abreu", "Capitão Fábio Abreu"),
         nome = str_replace_all(nome,
                                "JosimarMaranhãozi", "Josimar Maranhãozinho"),
         nome = str_replace_all(nome,
                                "Bozzella", "Júnior Bozzella"),
         nome = str_replace_all(nome,
                                "Tadeu  Filippelli", "Tadeu Filippelli"),
         nome = str_replace_all(nome,
                                "Glaustin da Fokus", "Glaustin Fokus"),
         nome = str_replace_all(nome,
                                "Pastor Gil", "Pastor Gildenemyr"))

#6. padronizar partidos
resultado_votacao <- resultado_votacao %>%
  mutate(partido = str_replace_all(partido,
                                   "NOVO", "Novo"),
         partido = str_replace_all(partido,
                                   "CIDADANIA", "Cidadania"),
         partido = str_replace_all(partido,
                                   "REDE", "Rede"),     
         partido = str_replace_all(partido,
                                   "SOLIDARIEDADE", "SD"),
         partido = str_replace_all(partido,
                                   "PODEMOS", "PODE"),
         partido = str_replace_all(partido,
                                   "PATRIOTA", "Patriota"),
         partido = str_replace_all(partido,
                                   "AVANTE", "Avante"),
         partido = str_replace_all(partido,
                                   "REPUBLICANOS", "Republicanos"))

#7. tirar acentos e colocar caixa alta
resultado_votacao <- resultado_votacao %>%
  mutate(nome_upper = toupper(rm_accent(nome)))


#8. cruzar planilhas
joined_data <- resultado_votacao %>%
  left_join(deputados_id, by = "nome_upper") %>%
  arrange(desc(id))

#9. checar PARTIDO
# verificar se houve mudança de partido
check_partido <- joined_data %>%
  mutate(check = ifelse(`partido.x` == `partido.y`, "match", "not_match")) %>%
  filter(check == "not_match") %>%
  select(nome_upper, `partido.x`, `partido.y`, `uf.y`, `uf.x`, check)

#10. selecionar as colunas que queremos no nosso arquivo
# é necessário informar abaixo: ID_PROPOSICAO, PROPOSICAO, PERMALINK
votacao_final <- joined_data %>%
  rename("nome_politico" = nome.y,
         "partido" = partido.y,
         "uf" = uf.y,
         "id_politico" = id) %>%
  mutate(id_proposicao = "62",
         proposicao = "VET17-2020",
         permalink = "reajuste-a-servidores-publicos") %>%
  select("id_proposicao", "proposicao", "partido", "id_politico", 
         "nome_upper", "nome_politico", "uf", "voto", "permalink") %>% 
  arrange(nome_upper)

#11. fazer o download
write.csv(votacao_final, "votacao_final_VET17-2020.csv")

