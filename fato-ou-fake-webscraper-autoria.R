library(data.table)
library(rvest)

links <- fread("~/Downloads/Boatos - FOF - 2020-boatos.csv")

checagem <- NULL
i <- 1

while(i < 400) {
  tryCatch({
autor <- as.character(links$LINK[i]) %>%
      read_html() %>%
      html_node("p.content-publication-data__from") %>%
      html_text() %>%
      str_trim()

titulo <- as.character(links$LINK[i]) %>%
      read_html() %>%
      html_nodes("h1.content-head__title") %>%
      html_text() %>%
      str_trim()
    
data <- as.character(links$LINK[i]) %>%
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
      cbind(titulo, data, links$LINK[i]) %>%
      rbind(checagem)
  }, error = function(e) return(NULL)
  )
  i <- i + 1
}


write.csv(checagem, paste0("autoria_checagem_", Sys.time(), ".csv"))
