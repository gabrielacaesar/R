library(data.table)
library(rvest)

links <- fread("~/Downloads/Boatos-FOF-assinaturas-28abr2020.csv")

checagem <- NULL
i <- 1

while(i < 145) {
  tryCatch({
  autor <- as.character(links[i]) %>%
            read_html() %>%
            html_node("p.content-publication-data__from") %>%
            html_text() %>%
            str_trim()
  
  titulo <- as.character(links[i]) %>%
            read_html() %>%
            html_nodes("h1.content-head__title") %>%
            html_text() %>%
            str_trim()
            
  data <- as.character(links[i]) %>%
          read_html() %>%
          html_nodes("p.content-publication-data__updated") %>%
          html_text() %>%
          str_split(" ") %>%
          as.data.frame() %>%
          `colnames<-`("data") %>%
          .[3,] %>%
          as.data.frame() %>%
          `colnames<-`("data")
  
  checagem <- autor %>%
            cbind(titulo, data, links[i]) %>%
            rbind(checagem)
  }, error = function(e) return(NULL)
  )
  i <- i + 1
}

checagem_tidy <- checagem %>%
  setnames(".", "autor") %>%
  mutate(autor = str_remove_all(autor, "Por"))

write.csv(checagem_tidy, "autoria_checagem_fof.csv")
