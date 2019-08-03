library(tidyverse)
library(rvest)
library(xml2)
library(janitor)
library(zoo)

# coleta de links de portarias
# replace number 'start=', update df name and run before rbind()
url <- "http://www.in.gov.br/consulta?q=%22CONCEDER%20a%20nacionalidade%20brasileira%22&publishFrom=2019-01-01&publishTo=2019-07-31&start=1"

urls_portaria1 <- url %>%
  read_html() %>%
  html_nodes("a") %>%
  html_attr("href") %>%
  as.data.frame() %>%
  `colnames<-`("links") %>%
  filter(str_detect(links, "http://www.in.gov.br/web/dou/")) %>%
  ungroup() %>%
  filter(!str_detect(links, "\\?inheritRedirect=true"),
         !str_detect(links, "retifica"))

url_portaria_total <- rbind(urls_portaria1, urls_portaria2, urls_portaria3,
                            urls_portaria4, urls_portaria5)

# OBS: ANALISAR URLs DE 'RETIFICAO' SEPARADO

# coleta de conteúdo das portarias

conteudo <- NULL
i <- 1

while(i < 100) {
  tryCatch({
  portaria <- as.character(url_portaria_total$links[i])
  conteudo <- read_html(portaria) %>%
    html_nodes("p.dou-paragraph") %>%
    html_text() %>%
    str_trim() %>%
    as.data.frame(stringsAsFactors = FALSE) %>%
    `colnames<-`("txt_portaria") %>%
    mutate(txt_portaria = toupper(txt_portaria)) %>%
    filter(str_detect(txt_portaria, "CONCEDER") |
           str_detect(txt_portaria, "NATURAL")) %>%
    mutate(n_portaria = ifelse(str_detect(txt_portaria, "CONCEDER A NACIONALIDADE"), 
                               txt_portaria, NA)) %>%
    mutate(n_portaria = na.locf(n_portaria)) %>%
    filter(!str_detect(txt_portaria, "CONCEDER A NACIONALIDADE"),
           !str_detect(txt_portaria, "TORNAR"),
           !str_detect(txt_portaria, "DECLARA")) %>%
    mutate(url_portaria = portaria) %>%
    rbind(conteudo)
  }, error = function(e) return(NULL)
  )
  i <- i + 1
}
  
# limpeza do conteudo - 1
# separando em colunas
conteudo_tidy <- conteudo %>%
  mutate(txt_portaria = str_replace_all(txt_portaria, "NATURAL DA ", "NATURAL DE"),
         txt_portaria = str_replace_all(txt_portaria, "NATURAL DO ", "NATURAL DE"),
         txt_portaria = str_replace_all(txt_portaria, "NATURAL DOS", "NATURAL DE"),
         txt_portaria = str_replace_all(txt_portaria, "NATURAL D ", "NATURAL DE"),
         txt_portaria = str_replace_all(txt_portaria, "NATURAL A ", "NATURAL DE"),
         txt_portaria = str_replace_all(txt_portaria, "NATURAL NA ", "NATURAL DE"),
         txt_portaria = str_replace_all(txt_portaria, "NATURAL EM ", "NATURAL DE")) %>%
  separate(txt_portaria, c("nome", "restante"), sep = "NATURAL DE") %>%
  mutate(restante = str_replace_all(restante, "NASCIDA", "NASCIDO")) %>%
  separate(restante, c("pais", "restante"), sep = "NASCIDO") 
  
  
  # correção de nome e número do processo
  mutate(conteudo = str_replace_all(conteudo, "CESAR AUGUSTO SANCHEZ ALARCON, ", 
                                    "CESAR AUGUSTO SANCHEZ ALARCON - sem numero de processo, "),
         conteudo = str_replace_all(conteudo, "CAMILA ANTONIA DANZER ARMOA, ",
                                    "CAMILA ANTONIA DANZER ARMOA - sem numero de processo, "),
         conteudo = str_replace_all(conteudo, "ALAN DOUGLAS BORGES DE CARVALHO, ",
                                    "ALAN DOUGLAS BORGES DE CARVALHO - sem numero de processo, "),
         conteudo = str_replace_all(conteudo, "ALOISIO DOS SANTOS GONÇALVES, ",
                                    "ALOISIO DOS SANTOS GONÇALVES - sem numero de processo, "),
         conteudo = str_replace_all(conteudo, "CLAUDIA DAMIANE DOS SANTOS SILVA, ",
                                    "CLAUDIA DAMIANE DOS SANTOS SILVA - sem numero de processo, "),
         conteudo = str_replace_all(conteudo, "ELKESON DE OLIVEIRA CARDOSO, ",
                                    "ELKESON DE OLIVEIRA CARDOSO - sem numero de processo, "),
         conteudo = str_replace_all(conteudo, "RICARDO GOULART PEREIRA, ",
                                    "RICARDO GOULART PEREIRA - sem numero de processo, "),
         conteudo = str_replace_all(conteudo, "VINICIUS SANTOS REIS SÉRGIO, ",
                                    "VINICIUS SANTOS REIS SÉRGIO - sem numero de processo, "),
         conteudo = str_replace_all(conteudo, "LINA ADNAN DAOU, ",
                                    "LINA ADNAN DAOU - sem numero de processo, "),
         conteudo = str_replace_all(conteudo, " -", " - ")) %>%
  separate(conteudo, c("nome", "restante"), sep = " - ") %>%
  separate(restante, c("processo", "restante"), sep = ", natural") %>%
  
  separate(restante, c("pais", "restante"), sep = ", nascido em ") %>%
  mutate(restante = str_replace_all(restante, "filha", "filho")) %>%
  separate(restante, c("data_nascimento", "restante"), sep = ", filho de") %>%
  separate(restante, c("genitores", "restante"), sep = ", residente ") %>%
  mutate(restante = str_replace_all(restante, "do Pará", "do Pará "),
         restante = str_replace_all(restante, " Processo", "Processo")) %>%
  separate(restante, c("uf", "processo"), sep = "\\(Processo ") %>%
  mutate(n_portaria = str_replace_all(n_portaria, "96 CONCEDER", "96 - CONCEDER"),
         n_portaria = str_replace_all(n_portaria, "95 CONCEDER", "95 - CONCEDER")) %>%
  separate(n_portaria, c("num_portaria", "texto_portaria"), sep = " - ")



# limpeza do conteudo - 2
# fazendo ajustes e corrigindo erros
conteudo_tidy_2 <- conteudo_tidy %>%
  mutate(pais = str_remove_all(pais, "de "),
         pais = str_remove_all(pais, "do "),
         pais = str_remove_all(pais, "da "),
         pais = str_remove_all(pais, "dos "),
         pais = str_trim(pais),
         pais = str_replace_all(pais, "Guiné Bissau", "Guiné-Bissau"),
         uf = str_remove_all(uf, "no Estado de "),
         uf = str_remove_all(uf, "no Estado do "),
         uf = str_remove_all(uf, "no Estado da "),
         num_portaria = str_remove_all(num_portaria, "Nº"),
         processo = str_remove_all(processo, "\\) e"),
         processo = str_remove_all(processo, "\\)."),
         processo = str_remove_all(processo, "\\);")) %>%
  mutate(genitores = str_replace_all(genitores, " e de ", "; "),
         genitores = str_replace_all(genitores, " e ", "; "),
         pais = str_replace_all(pais, "EmiraÁrabes", "Emirados Árabes"),
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
