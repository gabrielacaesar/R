library(tidyverse)
library(rvest)
library(xml2)
library(janitor)
library(zoo)
library(abjutils)

# coleta de links de portarias
# replace number 'start=', update df name and run before rbind()
url <- "http://www.in.gov.br/consulta?q=%22CONCEDER%20a%20nacionalidade%20brasileira%22&publishFrom=2016-01-01&publishTo=2019-08-03&start=1"

urls_portaria1 <- url %>%
  read_html() %>%
  html_nodes("a") %>%
  html_attr("href") %>%
  as.data.frame() %>%
  `colnames<-`("links") %>%
  filter(str_detect(links, "http://www.in.gov.br/web/dou/")) %>%
  ungroup() %>%
  filter(!str_detect(links, "\\?inheritRedirect=true"),
         !str_detect(links, "retifica"),
         !str_detect(links, "resolucao"),
         !str_detect(links, "despachos"))

url_portaria_total <- rbind(urls_portaria1, urls_portaria2, urls_portaria3,
                            urls_portaria4, urls_portaria5, urls_portaria6,
                            urls_portaria7, urls_portaria8, urls_portaria9,
                            urls_portaria10, urls_portaria11, urls_portaria12,
                            urls_portaria13, urls_portaria14, urls_portaria15,
                            urls_portaria16)


# OBS: ANALISAR URLs DE 'RETIFICAO' SEPARADO

# coleta de conteúdo das portarias

conteudo <- NULL
i <- 1

while(i < 300) {
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
  separate(restante, c("pais", "restante"), sep = "NASCIDO") %>%
  mutate(restante = str_replace_all(restante, "FILHA DE", "FILHO DE"),
         restante = str_replace_all(restante, "FILHO EM", "FILHO DE")) %>%
  separate(restante, c("data_nascimento", "restante"), sep = "FILHO DE") %>%
  mutate(restante = str_replace_all(restante, "RESIDETE", "RESIDENTE"),
         restante = str_replace_all(restante, "RESDIDENTE", "RESIDENTE")) %>%
  separate(restante, c("genitores", "restante"), sep = "RESIDENTE") %>%
  mutate(restante = str_replace_all(restante, "ROCSSO", "ROCESSO")) %>%
  separate(restante, c("uf", "processo"), sep = "\\(P")
  
  

# limpeza do conteudo - 2
# fazendo ajustes e corrigindo erros
conteudo_tidy_2 <- conteudo_tidy %>%
  # limpeza na coluna do país
  mutate(pais = str_remove_all(pais, "DE "),
         pais = str_remove_all(pais, "DO "),
         pais = str_remove_all(pais, "DA "),
         pais = str_remove_all(pais, "DOS "),
         pais = str_remove_all(pais, ","),
         pais = str_trim(pais),
         pais = abjutils::rm_accent(pais)) %>%
  # limpeza na coluna de data de nascimento
  mutate(data_nascimento = str_remove_all(data_nascimento, "EM"),
         data_nascimento = str_remove_all(data_nascimento, ","),
         data_nascimento = str_replace_all(data_nascimento, " DE JANEIRO DE ", "/01/"),
         data_nascimento = str_replace_all(data_nascimento, " DE FEVEREIRO DE ", "/02/"),
         data_nascimento = str_replace_all(data_nascimento, " DE MARÇO DE ", "/03/"),
         data_nascimento = str_replace_all(data_nascimento, " DE MAÇO DE ", "/03/"),
         data_nascimento = str_replace_all(data_nascimento, " DE ABRIL DE ", "/04/"),
         data_nascimento = str_replace_all(data_nascimento, " DE MAIO DE ", "/05/"),
         data_nascimento = str_replace_all(data_nascimento, " DE JUNHO DE ", "/06/"),
         data_nascimento = str_replace_all(data_nascimento, " DE JULHO DE ", "/07/"),
         data_nascimento = str_replace_all(data_nascimento, " DE AGOSTO DE ", "/08/"),
         data_nascimento = str_replace_all(data_nascimento, " E AGOSTO DE ", "/08/"),
         data_nascimento = str_replace_all(data_nascimento, " DE SETEMBRO DE ", "/09/"),
         data_nascimento = str_replace_all(data_nascimento, " DE SETBRO DE ", "/09/"),
         data_nascimento = str_replace_all(data_nascimento, " DER SETBRO DE ", "/09/"),
         data_nascimento = str_replace_all(data_nascimento, " DE OUTUBRO DE ", "/10/"),
         data_nascimento = str_replace_all(data_nascimento, " DE NOVEMBRO DE ", "/11/"),
         data_nascimento = str_replace_all(data_nascimento, " DE NOVBRO DE ", "/11/"),
         data_nascimento = str_replace_all(data_nascimento, " NOVBRO DE ", "/11/"),
         data_nascimento = str_replace_all(data_nascimento, " DE DEZEMBRO DE ", "/12/"),
         data_nascimento = str_replace_all(data_nascimento, " DE DEZBRO DE ", "/12/"),
         data_nascimento = str_replace_all(data_nascimento, " DE DEZBRO ", "/12/")) %>%
  # limpeza na coluna de genitores
  mutate(genitores = str_replace_all(genitores, " E DE ", "; "),
         genitores = str_remove_all(genitores, ",")) %>%
  # limpeza na coluna de uf
  mutate(uf = str_remove_all(uf, "NO ESTADO DE "),
         uf = str_remove_all(uf, "NO ESTADO DO "),
         uf = str_remove_all(uf, "NO ESTADO DA "),
         uf = str_remove_all(uf, "MO ESTADO DE "),
         uf = str_remove_all(uf, "NO "),
         uf = str_remove_all(uf, "O ESTADO DE "),
         uf = str_remove_all(uf, "ESTADO "),
         uf = str_remove_all(uf, "\\."),
         uf = str_remove_all(uf, "\\|"),
         uf = abjutils::rm_accent(uf),
         uf = str_trim(uf)) %>%
  # limpeza na coluna processo
  mutate(processo = str_remove_all(processo, "ROCESSO N°"),
         processo = str_remove_all(processo, "ROCESSO Nº"),
         processo = str_remove_all(processo, "E"),
         processo = str_remove_all(processo, "\\."),
         processo = str_remove_all(processo, "\\)"),
         processo = str_remove_all(processo, ";"))


# limpeza do conteudo - 3
# limpeza na coluna nome
# para identificar linhas duplicadas
# o DOU publicou portarias publicadas, que inflam os dados

conteudo_tidy_3 <- conteudo_tidy_2 %>%
  mutate(nome = str_replace_all(nome, " -", " - "),
         nome = str_replace_all(nome, "- ", " - "),
         codigo = ifelse(str_detect(nome, " - "), nome, "sem-codigo")) %>%
  separate(codigo, c("nome_n", "codigo"), " - ") %>%
  mutate(codigo = str_remove_all(codigo, ","),
         codigo = str_trim(codigo),
         codigo = str_replace_all(codigo, "", "sem-codigo"))


################################################################
###               novo loop para pegar portarias             ###
################################################################

# identificar quais portarias nao estao em 'conteudo'

# conteudo$url_portaria
# url_portaria_total$links

teste <- url_portaria_total %>%
  `colnames<-`("url_portaria") 

teste <- as.character(teste$url_portaria)
teste <- as.data.frame(teste, stringsAsFactors = FALSE)

teste <- teste %>%
  `colnames<-`("url_portaria") 

teste2 <- unique(conteudo$url_portaria)
teste2 <- as.data.frame(teste2)

teste2 <- teste2 %>%
  `colnames<-`("url_portaria") %>%
  mutate(port = "teste2")

length(unique(teste$url_portaria))
length(unique(teste2$url_portaria))

portarias_faltantes <- teste %>%
  left_join(teste2, by = "url_portaria") %>%
  filter(is.na(port))


# novo loop para pegar dados de portarias faltantes
# HTML do site do DOU foi alterado
# p.corpo.pdf-JUSTIFY
# descobrir intervalo em que HTML está diferente

i <- 1

while(i < 300) {
  tryCatch({
    portaria <- as.character(url_portaria_total$links[i])
    conteudo2 <- read_html(portaria) %>%
      html_nodes("p.corpo.pdf-JUSTIFY") %>%
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
      rbind(conteudo2)
  }, error = function(e) return(NULL)
  )
  i <- i + 1
}

# checar quais portarias estao faltando

teste4 <- unique(conteudo2$url_portaria)
teste4 <- as.data.frame(teste4)

teste4 <- teste4 %>%
  `colnames<-`("url_portaria") %>%
  mutate(port = "teste4") 

teste4 <- rbind(teste4, teste2)

portarias_faltantes_2 <- teste %>%
  left_join(teste4, by = "url_portaria") %>%
  filter(is.na(port))

###  checar se ha pessoas duplicadas
###  por conta de portarias erradas
##   e checar retificacoes

