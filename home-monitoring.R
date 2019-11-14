library(rvest)
library(tidyverse)

url <- "https://www.globo.com"

# manchete
manchete_title <- url %>%
  read_html() %>%
  html_nodes("a") %>%
  html_attr("title") %>%
  .[7] %>%
  as.data.frame() %>%
  `colnames<-`("links")

manchete_href <- url %>%
  read_html() %>%
  html_nodes("a") %>%
  html_attr("href") %>%
  .[7] %>%
  as.data.frame() %>%
  `colnames<-`("links") %>%
  mutate(secao = "manchete") %>%
  mutate(hora = Sys.time())

manchete <- cbind(manchete_title,
                  manchete_href)

# grande_abre
titulos_grande_abre_title <- url %>%
  read_html() %>%
  html_nodes("a.hui-premium__link") %>%
  html_attr("title") %>%
  as.data.frame() %>%
  `colnames<-`("links")

titulos_grande_abre_href <- url %>%
  read_html() %>%
  html_nodes("a.hui-premium__link") %>%
  html_attr("href") %>%
  as.data.frame() %>%
  `colnames<-`("links") %>%
  mutate(secao = "titulos_grande_abre") %>%
  mutate(hora = Sys.time())

titulos_grande_abre <- cbind(titulos_grande_abre_title,
                             titulos_grande_abre_href)

# pequeno abre
titulos_pequeno_abre_title <- url %>%
  read_html() %>%
  html_nodes("a.hui-premium__related-title") %>%
  html_attr("title") %>%
  as.data.frame() %>%
  `colnames<-`("links")

titulos_pequeno_abre_href <- url %>%
  read_html() %>%
  html_nodes("a.hui-premium__related-title") %>%
  html_attr("href") %>%
  as.data.frame() %>%
  `colnames<-`("links") %>%
  mutate(secao = "titulos_pequeno_abre") %>%
  mutate(hora = Sys.time())

titulos_pequeno_abre <- cbind(titulos_pequeno_abre_title,
                              titulos_pequeno_abre_href)

# box
titulos_box_title <- url %>%
  read_html() %>%
  html_nodes("a.hui-hover-effect__trigger") %>%
  html_attr("title") %>%
  as.data.frame() %>%
  `colnames<-`("links")

titulos_box_href <- url %>%
  read_html() %>%
  html_nodes("a.hui-hover-effect__trigger") %>%
  html_attr("href") %>%
  as.data.frame() %>%
  `colnames<-`("links") %>%
  mutate(secao = "titulos_box") %>%
  mutate(hora = Sys.time())

titulos_box <- cbind(titulos_box_title,
                     titulos_box_href)

# top globo
top_globo_title <- url %>%
  read_html() %>%
  html_nodes("a.topglobocom__content-title") %>%
  html_attr("title") %>%
  as.data.frame() %>%
  `colnames<-`("links")

top_globo_href <- url %>%
  read_html() %>%
  html_nodes("a.topglobocom__content-title") %>%
  html_attr("href") %>%
  as.data.frame() %>%
  `colnames<-`("links") %>%
  mutate(secao = "top_globo") %>%
  mutate(hora = Sys.time())

top_globo <- cbind(top_globo_title,
                   top_globo_href)

# empilhar
urls_materias <- rbind(titulos_grande_abre,
                       titulos_pequeno_abre,
                       titulos_box,
                       top_globo)

dir.create(file.path("~/Downloads/", format(Sys.time(), "%F %H-%M")))
setwd(file.path("~/Downloads/", format(Sys.time(), "%F %H-%M")))
getwd()

write.csv(urls_materias, "urls_materias.csv")

############################
############################
############################
############################
############################
############################


# jornalismo

g1 <- urls %>%
  filter(str_detect(links, "g1.globo.com")) %>%
  mutate(hora = Sys.time())

oglobo <- urls %>%
  filter(str_detect(links, "oglobo.globo.com")) %>%
  mutate(hora = Sys.time())

valor <- urls %>%
  filter(str_detect(links, "valor.globo.com")) %>%
  mutate(hora = Sys.time())
  
epoca <- urls %>%
  filter(str_detect(links, "epoca.globo.com")) %>%
  mutate(hora = Sys.time())

extra <- urls %>%
  filter(str_detect(links, "extra.globo.com")) %>%
  mutate(hora = Sys.time())

techtudo <- urls %>%
  filter(str_detect(links, "techtudo.com.br")) %>%
  mutate(hora = Sys.time())

# esporte

sportv <- urls %>%
  filter(str_detect(links, "sportv.globo.com")) %>%
  mutate(hora = Sys.time())

globoesporte <- urls %>%
  filter(str_detect(links, "globoesporte.globo.com")) %>%
  mutate(hora = Sys.time())

# entretenimento

globoplay <- urls %>%
  filter(str_detect(links, "globoplay.globo.com")) %>%
  mutate(hora = Sys.time())

revistamarieclaire <- urls %>%
  filter(str_detect(links, "revistamarieclaire.globo.com")) %>%
  mutate(hora = Sys.time())

gshow <- urls %>%
  filter(str_detect(links, "gshow.globo.com")) %>%
  mutate(hora = Sys.time())
  
vogue <- urls %>%
  filter(str_detect(links, "vogue.globo.com")) %>%
  mutate(hora = Sys.time()) 

revistaquem <- urls %>%
  filter(str_detect(links, "revistaquem.globo.com")) %>%
  mutate(hora = Sys.time())  

gq <- urls %>%
  filter(str_detect(links, "gq.globo.com")) %>%
  mutate(hora = Sys.time())  

casavogue <- urls %>%
  filter(str_detect(links, "casavogue.globo.com")) %>%
  mutate(hora = Sys.time())

revistacrescer <- urls %>%
  filter(str_detect(links, "revistacrescer.globo.com")) %>%
  mutate(hora = Sys.time())

globosatplay <- urls %>%
  filter(str_detect(links, "globosatplay.globo.com")) %>%
  mutate(hora = Sys.time())
  


  

  