library(tidyverse)
library(rvest)
library(xml2)
library(janitor)
library(zoo)

# coleta de links de portarias

url <- "http://www.in.gov.br/consulta?q=%22CONCEDER%20a%20nacionalidade%20brasileira%22&publishFrom=2019-01-01&publishTo=2019-07-31"

urls_portaria <- url %>%
  read_html() %>%
  html_nodes("a") %>%
  html_attr("href") %>%
  as.data.frame() %>%
  `colnames<-`("links") %>%
  filter(str_detect(links, "http://www.in.gov.br/web/dou/")) %>%
  ungroup()

# coleta de conteúdo das portarias

portaria <- as.character(urls_portaria$links[1])

data_conteudo <- read_html(portaria) %>%
  html_nodes("p.identifica") %>%
  html_text() %>%
  str_trim()

conteudo <- read_html(portaria) %>%
  html_nodes("p.dou-paragraph") %>%
  html_text() %>%
  str_trim() %>%
  as.data.frame(stringsAsFactors = FALSE) %>%
  `colnames<-`("conteudo") %>%
  filter(!conteudo == "",
         !str_detect(conteudo, 
        "A pessoa referida nesta Portaria"),
        !str_detect(conteudo, 
        "As pessoas referidas nesta Portaria"),
         !str_detect(conteudo, 
        "A SECRETÁRIA NACIONAL DE JUSTIÇA, DO MINISTÉRIO DA JUSTIÇA E SEGURANÇA PÚBLICA")) %>%
  mutate(data = data_conteudo) %>%
  mutate(n_portaria = ifelse(str_detect(conteudo, "Nº"), 
                             conteudo, NA)) %>%
  mutate(n_portaria = na.locf(n_portaria)) %>%
  filter(!str_detect(conteudo, "Nº "))
  
# limpeza do conteudo
# separando em colunas
conteudo_tidy <- conteudo %>%
  separate(conteudo, c("nome", "restante"), sep = " - ") %>%
  separate(restante, c("processo", "restante"), sep = ", natural") %>%
  mutate(restante = str_replace_all(restante, "nascida", "nascido")) %>%
  separate(restante, c("pais", "restante"), sep = ", nascido em ") %>%
  mutate(restante = str_replace_all(restante, "filha", "filho")) %>%
  separate(restante, c("data_nascimento", "restante"), sep = ", filho de") %>%
  separate(restante, c("genitores", "restante"), sep = ", residente ") %>%
  separate(restante, c("uf", "processo"), sep = " \\(Processo ") %>%
  separate(n_portaria, c("num_portaria", "texto_portaria"), sep = " - ")

conteudo_tidy_2 <- conteudo_tidy %>%
  mutate(pais = str_remove_all(pais, "de "),
         pais = str_remove_all(pais, "do "),
         pais = str_remove_all(pais, "da "),
         uf = str_remove_all(uf, "no Estado de "),
         uf = str_remove_all(uf, "no Estado do "),
         uf = str_remove_all(uf, "no Estado da "),
         num_portaria = str_remove_all(num_portaria, "Nº"),
         processo = str_remove_all(processo, "\\) e"),
         processo = str_remove_all(processo, "\\)."),
         processo = str_remove_all(processo, "\\);")) %>%
  mutate(genitores = str_replace_all(genitores, " e de ", "; "),
         genitores = str_replace_all(genitores, " e ", "; "),
         data_nascimento = str_replace_all(data_nascimento, " de janeiro de ", "/01/"),
         data_nascimento = str_replace_all(data_nascimento, " de fevereiro de ", "/02/"),
         data_nascimento = str_replace_all(data_nascimento, " de março de ", "/03/"),
         data_nascimento = str_replace_all(data_nascimento, " de abril de ", "/04/"),
         data_nascimento = str_replace_all(data_nascimento, " de maio de ", "/05/"),
         data_nascimento = str_replace_all(data_nascimento, " de junho de ", "/06/"),
         data_nascimento = str_replace_all(data_nascimento, " de julho de ", "/07/"),
         data_nascimento = str_replace_all(data_nascimento, " de agosto de ", "/08/"),
         data_nascimento = str_replace_all(data_nascimento, " de setembro de ", "/09/"),
         data_nascimento = str_replace_all(data_nascimento, " de outubro de ", "/10/"),
         data_nascimento = str_replace_all(data_nascimento, " de novembro de ", "/11/"),
         data_nascimento = str_replace_all(data_nascimento, " de dezembro de ", "/12/"))
  
