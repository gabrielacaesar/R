library(tidyverse)
library(data.table)
library(rvest)

lista <- fread("lista-plenario-22jul2019.csv", encoding = "UTF-8")

# sessoes plenarias 
lista_sessao <- lista %>%
  `colnames<-`(c("n_votacao", "data", "descricao", "link")) %>%
  filter(descricao %like% "SESSÃO") %>%
  mutate(tipo = "sessao") %>%
  mutate(codigo = case_when(n_votacao < 10 ~ "CD19000",
                            n_votacao >= 100 ~ "CD190",
                            n_votacao < 100 | n_votacao > 10 ~ "CD1900")) %>%
  unite(df, c("codigo", "n_votacao"), sep = "", remove = F)

# votacoes no plenario
lista_votacao <- lista %>%
  `colnames<-`(c("n_votacao", "data", "descricao", "link")) %>%
  filter(!descricao %like% "SESSÃO") %>%
  mutate(tipo = "votacao") %>%
  mutate(codigo = case_when(n_votacao < 10 ~ "CD19000",
                            n_votacao >= 100 ~ "CD190",
                            n_votacao < 100 | n_votacao > 10 ~ "CD1900")) %>%
  unite(df, c("codigo", "n_votacao"), sep = "", remove = F)

lista_n <- rbind(lista_sessao, lista_votacao)

###########################
##   deputados votantes  ##
###########################
j <- 1

while(j < 231) {
  tryCatch({
  url <- lista_votacao$link[j]
  table_voto <- read_html(url) %>%
          html_nodes("table") %>%
          html_table(fill = TRUE, header = T) %>%
         .[[3]]
  table1_df <- data.frame(table_voto) %>%
    `colnames<-`(c("nome", "uf", "voto")) %>%
    mutate(new_column = NA) %>%
    mutate(id = lista_votacao$df[j]) %>%
    rbind(table1_df)
  }, error = function(e) return(NULL)
  )
  j <- j + 1
}

# delete unnecessary rows
idx <- grep("Total.*: \\d+", table1_df$nome)

for (i in seq_along(idx)){
  n <- as.numeric(sub("^.*: ", "", table1_df$nome[idx[i]]))
  partido <- sub("Total ", "", table1_df$nome[idx[i]])
  partido <- sub(": .*", "", partido)
  table1_df$new_column[(idx[i] - n):(idx[i] - 1)] <- partido
}

table1_df <- table1_df[-grep("Total .*:.*", table1_df$nome), ]
table1_df <- table1_df[-which(table1_df$nome == table1_df$uf), ]
colnames(table1_df)[4] <- "partido"

write.csv(table1_df, "votos_deputados.csv")

###########################
## orientacao partidaria ##
###########################
j <- 1

while(j < 231) {
  tryCatch({
    url <- lista_votacao$link[j]
    table_voto_orientacao <- read_html(url) %>%
      html_nodes("table") %>%
      html_table(fill = TRUE, header = F) %>%
      .[[2]]
    table1_df_orientacao <- data.frame(table_voto_orientacao) %>%
      `colnames<-`(c("partido", "orientacao")) %>%
      mutate(id = lista_votacao$df[j]) %>%
      bind_rows(table1_df_orientacao)
    
  }, error = function(e) return(NULL)
  )
  j <- j + 1
}

write.csv(table1_df_orientacao, "orientacao_partidos.csv")

