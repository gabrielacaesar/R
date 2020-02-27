library(httr)  # will be use to make HTML GET and POST requests
library(rvest) # will be used to parse HTML
library(tidyr) #will be used to remove NA
library(tidyverse)

# html com relatórios de 01/01/2019 a 31/03/2019

# SERVIDOR - 01/02 - 30/04
url_servidor_1 <- "https://www.camara.leg.br/missao-oficial/missao-pesquisa?deputado=0&nome-deputado=&nome-servidor=&dati=01%2F02%2F2019&datf=30%2F04%2F2019&nome-evento="
# SERVIDOR - 01/05 - 30/07
url_servidor_2 <- "https://www.camara.leg.br/missao-oficial/missao-pesquisa?deputado=0&nome-deputado=&nome-servidor=&dati=01%2F05%2F2019&datf=30%2F07%2F2019&nome-evento="
# SERVIDOR - 31/07 - 29/10
url_servidor_3 <- "https://www.camara.leg.br/missao-oficial/missao-pesquisa?deputado=0&nome-deputado=&nome-servidor=&dati=31%2F07%2F2019&datf=29%2F10%2F2019&nome-evento="
# SERVIDOR - 30/10 - 31/12
url_servidor_4 <- "https://www.camara.leg.br/missao-oficial/missao-pesquisa?deputado=0&nome-deputado=&nome-servidor=&dati=30%2F10%2F2019&datf=31%2F12%2F2019&nome-evento="
# SERVIDOR - 01/01 - 31/01
url_servidor_5 <- "https://www.camara.leg.br/missao-oficial/missao-pesquisa?deputado=0&nome-deputado=&nome-servidor=&dati=01%2F01%2F2020&datf=31%2F01%2F2020&nome-evento="
# empilhando

url_servidor <- url_servidor_1 %>%
  rbind(url_servidor_2, url_servidor_3,
        url_servidor_4, url_servidor_5) %>%
  as.data.frame() %>%
  `colnames<-`("urls")

url_servidor <- as.character(url_servidor$urls[1])
  
# DEPUTADO - 01/02 - 30/04
url_deputado_1 <- "https://www.camara.leg.br/missao-oficial/missao-pesquisa?deputado=1&nome-deputado=&nome-servidor=&dati=01%2F02%2F2019&datf=30%2F04%2F2019&nome-evento="
# DEPUTADO - 01/05 - 30/07
url_deputado_2 <- "https://www.camara.leg.br/missao-oficial/missao-pesquisa?deputado=1&nome-deputado=&nome-servidor=&dati=01%2F05%2F2019&datf=30%2F07%2F2019&nome-evento="
# DEPUTADO - 31/07 - 29/10
url_deputado_3 <- "https://www.camara.leg.br/missao-oficial/missao-pesquisa?deputado=1&nome-deputado=&nome-servidor=&dati=31%2F07%2F2019&datf=29%2F10%2F2019&nome-evento="
# DEPUTADO - 30/10 - 31/12
url_deputado_4 <- "https://www.camara.leg.br/missao-oficial/missao-pesquisa?deputado=1&nome-deputado=&nome-servidor=&dati=30%2F10%2F2019&datf=31%2F12%2F2019&nome-evento="
# DEPUTADO - 01/01 - 31/01
url_deputado_5 <- "https://www.camara.leg.br/missao-oficial/missao-pesquisa?deputado=1&nome-deputado=&nome-servidor=&dati=01%2F01%2F2020&datf=31%2F01%2F2020&nome-evento="
# empilhando


## LOOP SERVIDOR

site_2 <- NULL
i <- 1

while(i < 6) {
  tryCatch({
    url_servidor <- url_servidor_1 %>%
      rbind(url_servidor_2, url_servidor_3,
            url_servidor_4, url_servidor_5) %>%
      as.data.frame() %>%
      `colnames<-`("urls")
    
    url_servidor <- as.character(url_servidor$urls[1])
    
    # coleta de links de "detalhes"
    site_2 <- url_servidor %>%
      read_html() %>%
      html_nodes("a") %>%
      html_attr("href") %>%
      as.data.frame() %>%
      `colnames<-`("urls") %>%
      filter(str_detect(urls, "missao-relatorio")) %>%
      separate(urls, c("url1", "url2"), sep = "&") %>%
      separate(url2, c("url3", "url4"), sep = "ponto") %>%
      rbind(site_2)
  }, error = function(e) return(NULL)
  )
  i <- i + 1
}
  
site_1_tidy_servidor <- site_2 %>%
  mutate(domain = "https://www.camara.leg.br",
         url2 = "&ponto") %>%
  select(domain, url1, url2, url4) %>%
  unite(links, c("domain", "url1", "url2", "url4"), sep = "") %>%
  mutate(tipo_cargo = "servidor")


## LOOP DEPUTADO

site_1 <- NULL
i <- 1

while(i < 6) {
  tryCatch({
    url_deputado <- url_deputado_1 %>%
      rbind(url_deputado_2, url_deputado_3, 
            url_deputado_4, url_deputado_5) %>%
      as.data.frame() %>%
      `colnames<-`("urls")
    
   url_deputado <- as.character(url_deputado$urls[i])
  
# coleta de links de "detalhes"
site_1 <- url_deputado %>%
  read_html() %>%
  html_nodes("a") %>%
  html_attr("href") %>%
  as.data.frame() %>%
  `colnames<-`("urls") %>%
  filter(str_detect(urls, "missao-relatorio")) %>%
  separate(urls, c("url1", "url2"), sep = "&") %>%
  separate(url2, c("url3", "url4"), sep = "ponto") %>%
  rbind(site_1)
  }, error = function(e) return(NULL)
  )
  i <- i + 1
}


# padronização de links de "detalhes
site_1_tidy_deputado <- site_1 %>%
  mutate(domain = "https://www.camara.leg.br",
         url2 = "&ponto") %>%
  select(domain, url1, url2, url4) %>%
  unite(links, c("domain", "url1", "url2", "url4"), sep = "") %>%
  mutate(tipo_cargo = "deputado")


site_1_tidy_deputado_servidor <- rbind(site_1_tidy_deputado,
                                       site_1_tidy_servidor)



# coleta de texto sobre "relatórios" dentro de "detalhes"
get_relatorio_text <- NULL
i <- 1

while(i < 1720) {
  tryCatch({
  links_chr <- as.character(site_1_tidy_deputado_servidor$links[i])
  tipo_cargo <- as.character(site_1_tidy_deputado_servidor$tipo_cargo[i])
  
  get_relatorio_text <- links_chr %>%
    read_html() %>%
    html_nodes(xpath = '//*[@id="content"]/div/div/div/div/div[4]') %>%
    html_text() %>%
    as.data.frame() %>%
    `colnames<-`("status_relatorio") %>%
    mutate(links = links_chr) %>%
    mutate(tipo_cargo = tipo_cargo) %>%
    rbind(get_relatorio_text) 
  }, error = function(e) return(NULL)
  )
  i <- i + 1
}

write.csv(get_relatorio_text, "get_relatorio_text.csv")


####
# EXTRA
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
  
