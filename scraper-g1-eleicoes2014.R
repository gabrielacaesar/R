library(rvest)
library(tidyverse)

i <- 1:32
url <- paste0("http://g1.globo.com/politica/eleicoes/2014/blog/eleicao-em-numeros/", i ,".html")

get_data <- function(x){
  url[x] %>%
  read_html() %>%
  html_nodes("header") %>%
  html_nodes("time") %>%
  html_text() %>%
  str_trim() %>%
  as.data.frame() %>%
  rename("data" = ".") %>%
  mutate(id = row_number(),
         url_id = x)
}
all_data <- map_df(1:length(i), get_data)

get_autor <- function(x){
  url[x] %>%
  read_html() %>%
  html_nodes("header") %>%
  html_nodes("span.post-author") %>%
  html_text() %>%
  str_trim() %>%
  as.data.frame() %>%
  rename("autor" = ".") %>%
  mutate(id = row_number(),
         url_id = x,
         autor = str_remove_all(autor, "por "))
}
all_autor <- map_df(1:length(i), get_autor)

get_titulo <- function(x){
  url[x] %>%
  read_html() %>%
  html_nodes("header") %>%
  html_nodes("h1.post-title.gui-text-title") %>%
  html_text() %>%
  str_trim() %>%
  as.data.frame() %>%
  rename("titulo" = ".") %>%
  mutate(id = row_number(),
         url_id = x)
}
all_titulo <- map_df(1:length(i), get_titulo)

get_link <- function(x){
  url[x] %>%
  read_html() %>%
  html_nodes("h1.post-title.gui-text-title > a") %>%
  html_attr("href") %>%
  str_trim() %>%
  as.data.frame() %>%
  rename("link" = ".") %>%
  mutate(id = row_number(),
         url_id = x)
}
all_link <- map_df(1:length(i), get_link)

materias <- all_data %>%
  left_join(all_autor, by = c("url_id", "id")) %>%
  left_join(all_titulo, by = c("url_id", "id")) %>%
  left_join(all_link, by = c("url_id", "id"))

write.csv(materias, "materias_eleicoes2014.csv")
