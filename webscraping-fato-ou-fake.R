################################################################
###                                                          ###
###                       Fato ou Fake                       ###
###                                                          ###
###                      gabriela caesar                     ###
###                                                          ###
################################################################

################################################################
###                 Inclusão de checagem nova                ###
################################################################


library(tidyverse)
library(rvest)
library(xml2)
library(abjutils)

# informar a url

url <- "https://g1.globo.com/fato-ou-fake/noticia/2018/10/05/veja-o-que-e-fato-ou-fake-nas-falas-dos-presidenciaveis-no-debate-da-globo.ghtml"

# titulo da materia

titulo <- url %>%
  read_html() %>%
  html_nodes("h1.content-head__title") %>%
  html_text()

titulo

# data da materia

data <- url %>%
  read_html() %>%
  html_nodes("p.content-publication-data__updated") %>%
  html_text() %>%
  str_split(" ") %>%
  as.data.frame() %>%
  `colnames<-`("data") %>%
  .[3,] %>%
  as.data.frame() %>%
  `colnames<-`("data")

data

# hora da materia

hora <- url %>%
  read_html() %>%
  html_nodes("p.content-publication-data__updated") %>%
  html_text() %>%
  str_split(" ") %>%
  as.data.frame() %>%
  `colnames<-`("hora") %>%
  .[4,] %>%
  as.data.frame() %>%
  `colnames<-`("hora")

hora

# autor das frases

autor <- url %>%
  read_html() %>%
  html_nodes("h2") %>%
  html_text()

autor

# frases

frase <- url %>%
  read_html() %>%
  html_nodes("blockquote.content-blockquote.theme-border-color-primary-before") %>%
  html_text() %>%
  str_remove_all('\"') %>%
  str_remove_all('"')

frase

# rotulos

rotulo <- url %>%
  read_html() %>%
  html_nodes("strong") %>%
  html_text() %>%
  str_remove_all("A declaração é ") %>%
  str_remove_all(". Veja o porquê:") %>%
  str_trim() %>%
  as.data.frame() %>%
  `colnames<-`("rotulo") %>%
  filter(rotulo == "#FATO" |
           rotulo == "#FAKE" |
           rotulo == "#NÃOÉBEMASSIM")

rotulo

# contagem de rotulos

count_rotulo <- rotulo %>%
  group_by(rotulo) %>%
  summarise(int = n()) %>%
  mutate(total = sum(int)) %>%
  mutate(perc_int = round((int / total) * 100, 1))

count_rotulo

# texto da checagem

texto <- url %>%
  read_html() %>%
  html_nodes("p.content-text__container") %>%
  html_text() %>%
  str_trim() %>%
  as.data.frame() %>%
  `colnames<-`("checagem") %>%
  mutate(checagem = toupper(checagem),
         checagem = rm_accent(checagem)) %>%
  mutate(rotulo = case_when(
          str_detect(checagem, "#FATO") ~ "#FATO", 
          str_detect(checagem, "#FAKE") ~ "#FAKE", 
          str_detect(checagem, "#NAOEBEMASSIM") ~ "#NAOEBEMASSIM"))

texto
