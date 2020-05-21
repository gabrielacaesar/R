# reading libraries
library(rvest)
library(tidyverse)
library(varhandle)

# reading HTML file without CSS
poll_data <- read_html("~/Downloads/Pesquisa Argentina.html", encoding = "UTF-8")

poll_count <- poll_data %>%
  html_nodes("tbody") %>%
  length()

# getting name of each question and tidying data

poll_question <- poll_data %>%
  html_nodes("th") %>%
  html_text() %>%
  as.data.frame() %>%
  rename("name" = ".") %>%
  filter(name != "name",
         name != "mean",
         name != "stdev",
         name != "answers",
         name != "Reference") %>%
  filter(!str_detect(name, "\\|"))

# getting answers of each question and tidying data

names_answer <- c("Alberto Fernández",
                  "Mauricio Macri",
                  "Axel Kicillof",
                  "Cristina Fernández de Kirchner",
                  "Horacio Rodríguez Larreta",
                  "María Eugenia Vidal",
                  "Martín Lousteau",
                  "Xi Jinping",
                  "Donald Trump",
                  "Angela Merkel",
                  "Emmanuel Macron",
                  "Pedro Sanchez",
                  "Boris Johnson",
                  "Jair Bolsonaro",
                  "Andres Manuel Lopez Obrador",
                  "Economía de Argentina",
                  "Mercado de trabajo",
                  "Situación de mi familia")

poll_answer <- poll_data %>%
  html_nodes("tbody") %>%
  html_nodes("tr") %>%
  html_nodes("td") %>%
  html_text() %>%
  as.data.frame() %>%
  `colnames<-`("answer") %>%
  filter(!str_detect (answer, "namemeanstdev")) %>%
  mutate(answer = unfactor(answer),
         value = ifelse(str_detect(answer, "\\."), 
                        answer, NA)) %>%
  fill(value, .direction = "up") %>%
  filter(answer != value) %>%
  mutate(value = as.numeric(value) * 100) %>%
  mutate(related_name = ifelse(str_detect(str_trim(answer), 
                               paste(names_answer, collapse = "|")),
                               answer, NA)) 



#%>%
#  fill(related_name, .direction = "down")

#%>%
#  filter(answer != related_name)
