library(tidyverse)
library(rvest)

i <- 1:22
url <- paste0("https://g1.globo.com/politica/eleicoes/2018/eleicao-em-numeros/index/feed/pagina-", i, ".ghtml")

# url
get_url <- function(x){
  url[x] %>%
    read_html() %>%
    html_nodes("a.feed-post-link.gui-color-primary.gui-color-hover") %>%
    html_attr("href") %>%
    as.data.frame() %>%
    rename("link" = ".") %>%
    ungroup() %>%
    mutate(id = x)
}
all_url <- map_df(1:22, get_url)

# título
get_titulo <- function(x){
  all_url$link[x] %>%
  read_html() %>%
  html_nodes("h1.content-head__title") %>%
  html_text() %>%
  as.data.frame() %>%
  rename("titulo" = ".") %>%
  mutate(url_id = x)
} 
all_titulo <- map_df(1:216, get_titulo)

# data
get_data <- function(x){
    all_url$link[x] %>%
    read_html() %>%
    html_node("time") %>%
    html_text() %>%
    as.data.frame() %>%
    rename("data" = ".") %>%
    mutate(url_id = x)
}
all_data <- map_df(1:216, get_data)

# autor
get_autor <- function(x){
    all_url$link[x] %>%
    read_html() %>%
    html_node("p.content-publication-data__from") %>%
    html_text() %>%
    as.data.frame() %>%
    rename("autor" = ".") %>%
    mutate(url_id = x,
           autor = str_remove_all(autor, "Por "),
           autor = str_remove_all(autor, ", G1 "))
}
all_autor <- map_df(1:216, get_autor)

# joining dfs
all_materia <- all_url %>%
  mutate(url_id = row_number()) %>%
  left_join(all_autor, by = "url_id") %>%
  left_join(all_titulo, by = "url_id") %>%
  left_join(all_data, by = "url_id") %>%
  mutate("eleicao" = "2018") %>%
  select(eleicao, data, autor, titulo, link)

# downloading csv
write.csv(all_materia, "all_materia_eleicoes2018.csv")# 
