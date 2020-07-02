# instalação do pacote
install.packages("tidyverse")

# leitura do pacote
library(tidyverse)

i <- 1:16 # número de páginas com atletas
list_url <- paste0("http://www.cob.org.br/pt/cob/time-brasil/atletas?&page=", i)

# função para pegar todos os links de atletas dentro da lista de url
pegar_url <- function(x){
  url[x] %>%
  read_html() %>%
  html_nodes("a") %>%
  html_attr("href") %>%
  as.data.frame() %>%
  rename("link" = ".") %>%
  filter(str_detect(link, "time-brasil/atletas/")) %>%
  mutate(link = str_replace_all(link, "https", "http"))
}

all_url <- map_dfr(1:length(list_url), pegar_url)
  
# função para pegar todas as informações de atletas dentro de cada link
pegar_info <- function(x){
  as.character(all_url$link[x]) %>%
  read_html() %>%
  html_node("div.card-body") %>%
  html_node("p") %>%
  html_text() %>%
  as.data.frame() %>%
  rename("conteudo" = ".") %>%
  mutate(link = all_url$link[x],
        conteudo = str_remove_all(conteudo, "  ")) %>%
  separate(conteudo, c("nome_completo", "data_de_nascimento", "local_de_nascimento"), sep = "\r\n\r\n") %>%
  mutate(nome_completo = str_remove_all(nome_completo, "Nome completo: "),
         data_de_nascimento = str_remove_all(data_de_nascimento, "Data de nascimento: "),
         local_de_nascimento = str_remove_all(local_de_nascimento, "Local de nascimento: "))
}

all_info <- map_dfr(1:length(all_url$link), pegar_info)

# download do csv com as informações de atletas
write.csv(all_info, "dados_dos_atletas_COB.csv")

