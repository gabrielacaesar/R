library(httr)  # will be use to make HTML GET and POST requests
library(rvest) # will be used to parse HTML
library(tidyr) #will be used to remove NA
library(tidyverse)

# html com relatórios de 01/01/2019 a 31/03/2019

url <- "https://www.camara.leg.br/missao-oficial/missao-pesquisa?deputado=0&nome-deputado=&nome-servidor=&dati=01%2F01%2F2019&datf=31%2F03%2F2019&nome-evento="

# coleta de links de "detalhes"
site_1 <- url %>%
  read_html() %>%
  html_nodes("a") %>%
  html_attr("href") %>%
  as.data.frame() %>%
  `colnames<-`("urls") %>%
  filter(str_detect(urls, "missao-relatorio")) %>%
  separate(urls, c("url1", "url2"), sep = "&") %>%
  separate(url2, c("url3", "url4"), sep = "ponto")

# padronização de links de "detalhes
site_1_tidy <- site_1 %>%
  mutate(domain = "https://www.camara.leg.br",
         url2 = "&ponto") %>%
  select(domain, url1, url2, url4) %>%
  unite(links, c("domain", "url1", "url2", "url4"), sep = "")

links_chr<- as.character(site_1_tidy$links[1])

# coleta de links de "relatórios" dentro de "detalhes"

get_relatorio <- links_chr %>%
  read_html() %>%
  html_nodes(xpath = '//*[@id="content"]/div/div/div/div/div[4]/li') %>%
  html_nodes("a") %>%
  html_attr("href") %>%
  as.data.frame() %>%
  `colnames<-`("urls")
  
# padronização de links de "relatórios"
get_relatorio_tidy <- get_relatorio %>%
  mutate(domain = "https://www.camara.leg.br/missao-oficial") %>%
  select(domain, urls) %>%
  unite(links, c("domain", "urls"), sep = "/")
  
