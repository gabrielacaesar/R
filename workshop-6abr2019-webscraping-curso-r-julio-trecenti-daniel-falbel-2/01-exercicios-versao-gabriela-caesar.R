library(tidyverse)
library(rvest)

# Exercício 1 ------------------------------------------------------------------

# O site http://example.webscraping.com/ contém uma série de links que 
# possuem informações sobre países. 

# Construa um `data.frame` com as colunas `pais` e `link` dos 
# dez primeiros países que aparecem na primeira página.

library(httr)
library(XML)
library(rvest)
library(magrittr)

######### TABELA
# informamos o link da url
url <- "http://example.webscraping.com/"

# lemos o html da url
html <- read_html(url)

# pegamos o texto dentro da tabela
tab <- html_table(html)

# transformamos em dataframe
df <- as.data.frame(tab)

pais1 <- as.data.frame(df$X1)
pais2 <- as.data.frame(df$X2)

# renomeamos as colunas
colnames(pais1) <- "pais"
colnames(pais2) <- "pais"

# unimos os dataframes
pais_final <- bind_rows(pais1, pais2)

######### LINK
# pegamos a url de cada pais
link <- html %>%
        html_nodes("table") %>%
        html_nodes("tr") %>%
        html_nodes("td") %>%
        html_nodes("div") %>%
        html_nodes("a") %>%
        html_attr("href")

# transformamos em dataframe
link_final <- as.data.frame(link)

# criamos uma coluna com o inicio do site
link_final$dominio <- "http://example.webscraping.com"

# definimos a ordem das colunas
link_final <- link_final %>%
  select(dominio, link) 

# unimos as duas colunas
link_final <- unite(link_final, "url", c("dominio", "link"), sep = "")

##### FINAL

exercicio_1 <- as.data.frame(cbind(pais_final$pais, link_final$url))
colnames(exercicio_1) <- c("pais", "link")

##### GABARITO da HAYDEE

url <- "http://example.webscraping.com/" 
  
nos_paises_1 <- url %>%
  httr::GET() %>%
  xml2::read_html() %>%
  xml2::xml_find_all('//*[@id="results"]/table//a')

links_paises <- xml2::xml_attr()  

tibble::tibble(
  paises = xml2::xml_attr(nos_paises_1, "href")
  links = xml2::xml_text(nos_paises_1)
) %>%
  mutate(url_base)

  
  
# Exercício 2 ------------------------------------------------------------------

# A partir do objeto `paises` gerado no exercício 1 crie uma coluna `img_src` 
# que guarde o atributo `src` das tags `<img>` 
# (ele é local onde a imagem da bandeira está disponível).

imgs <- nos_paises_1 %>%
        xml2::xml_children() %>%
        xml2::xml_attr("src")

paises <- exercicio_1 %>%
  mutate(img = imgs)


# Exercício 3 ------------------------------------------------------------------

# No navegador, inspecione o http://example.webscraping.com/ e identifique 
# uma tabela no corpo do site. 

# Em seguida, utilize a função `html_table()` do pacote `rvest` e 
# compare o resultado com o observado no inspetor. Qual conteúdo a função 
# devolveu: tag, texto ou atributos?

url %>%
  xml2::read_html() %>%
  rvest::html_table()

# Exercício 4 ------------------------------------------------------------------
  
# 1 Faça uma requisição que baixa a página de Andorra.
# 2 Extraia os dados de andorra numa tabela tidy.

library(broom)

httr::GET("http://example.webscraping.com/places/default/view/Andorra-6",
          httr::write_disk("andorra.html"))

url <- xml2::read_html("andorra.html")

img <- url %>%
    xml2::xml_find_first("//img") %>%
    xml2::xml_attr("src")
   

url %>%
  rvest::html_table() %>%
  # magrittr:extract()
  dplyr::first() %>%
  dplyr::mutate(X2 = ifelse(X2 == "", img, X2)) %>%
  tidyr::spread(X1, X2) %>%
  janitor::clean_names() %>%
  tibble::as_tibble()



# Exercício 5 ------------------------------------------------------------------

# Baixe as páginas de todos os países

fs::dir_create("paises")


#link <- xml2::read_html("andorra.html")

parser <- function(id) {
  
  url <- paste0("http://example.webscraping.com/places/default/index/", id)
  
  arquivo <- sprintf("paises/%02d.html", id)
  
  if (!file.exists(arquivo)){
    wd <- httr::write_disk(arquivo, overwrite = TRUE)
    r <- httr::GET(url, wd)
  }
  
  h <- xml2::read_html(arquivo)
  
  acabou <- h %>%
    xml2::xml_find_first("//a[contains(text(), 'Next >')]") %>%
    xml2::xml_attr("href") %>%
    is.na()
  
  nos_paises_1 <- h %>%
    xml2::xml_find_all("//table//a")
  
  paises <- tibble::tibble(
    links = xml2::xml_attr(nos_paises_1, "href"),
    nomes = xml2::xml_text(nos_paises_1)
  ) %>%
    mutate(url_base = "") %>%
    unite(url_total, url_base,
          links, sep = "", remove = F)
    tibble::tibble(paises = list(paises), acabou)
} 

res <- parser(0)
i <- 1

while(!dplyr::last(res$acabou)) {
  message(i)
  Sys.sleep(2)
  res <- dplyr::bind_rows(res, parser(i))
  i <- i + 1
}


# Exercício 6 ------------------------------------------------------------------

# Crie uma conta manualmente e depois construa uma função para se logar.
# Dica: use `abjutils::chrome_to_body()` para copiar o form do 
# Chrome para o computador.


# 1. acessar a pagina de login
# 2. pegar esse codigo

url_login <- "http://example.webscraping.com/places/default/user/login?_next=/places/default/index#"

r_get <- url_login %>%
      httr::GET()

pegar_token <- function(r_get){
    read_html(r_get) %>%
    xml_find_all(xpath = '//*[@id="web2py_user_form"]/form/div/input[2]') %>%
    xml_attr("value")
}

abjutils::chrome_to_body("email: c@g.com
                         password: 123456
                         _next: /places/default/index
                         _formkey: c42b43bf-832f-4ea5-9368-5a5fb1d86e71
                         _formname: login")


form <- list(
  "email" = "c@g.com",
  "password" = "123456",
  "_next" = "/places/default/index",
  "_formkey" = pegar_token(r_get),
  "_formname" = "login")

url_login_post <- url_login
r_post <- httr::POST(url_login_post, body = form)

# devtools::install_github("jtrecenti/scrapr")
library(scrapr)

scrapr::html_view(r_post)
httr::content(r_post)

# Exercício extra --------------------------------------------------------------

# Baixe o Chance de Gol de todos os anos!
