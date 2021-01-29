library(httr)
library(xml2)
library(XML)
library(magrittr)

###### coleta de IDs
id <- NULL
i <- 1

while(i < 11) {
  tryCatch({
    videos_list <- paste0(
      "https://www.xvideos.com/new/",
      i)
    id <- videos_list %>%
      read_html() %>%
      xml_find_all("//div[@class='thumb']") %>%
      xml_find_all("//a/img") %>%
      xml_attr("data-videoid") %>%
      cbind() %>%
      rbind(id)
  }, error = function(e) return(NULL)
  )
  i <- i + 1
}

id <- as.data.frame(id)


###### download de HTML

#length(id)
i <- 1

while(i < 2) {
  tryCatch({
    url <- paste0(
      "https://de.xvideos.com/threads/video-comments/get-posts/top/",
      id[i,1],
      "/0/0")
    json_web <- url %>%
      GET() %>%
      read_html() %>%
      write_html(paste0("arquivo", i, ".html"), format = "as_html")
  }, error = function(e) return(NULL)
  )
  i <- i + 1
}

###### get json

get_json <- paste0("arquivo", i, ".html") %>%
        read_html() %>%
        html_node("form") %>%
        html_nodes("button") %>%
        nth(2) %>%
        html_text() %>%
        str_trim()

  
    
    
    
    


