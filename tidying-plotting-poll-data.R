# reading libraries
library(magrittr)
library(rvest)
library(ggplot2)
library(purrr)

# reading HTML file without CSS
poll_data <- read_html("~/Downloads/ecuador prelim.html", encoding = "UTF-8")

poll_count <- poll_data %>%
  html_nodes("tbody") %>%
  length()

# getting answers of each question and tidying data
poll_answer <- function(x){
  poll_data %>%
  html_nodes("tbody") %>%
  .[x] %>%
  html_nodes("td") %>%
  html_text() %>%
  as.data.frame() %>%
  `colnames<-`("answer") %>%
  mutate(answer = str_remove_all(answer, "0.00000")) %>%
  filter(answer != "") %>%
  mutate(value = ifelse(str_detect(answer, "\\."), 
                        answer, NA)) %>%
  fill(value, .direction = "up") %>%
  filter(answer != value) %>%
  mutate(value = as.numeric(value) * 100,
         poll_id = x)
} 

answer <- map(1:poll_count, poll_answer)

# getting name of each question and tidying data
poll_name <- function(x){
  poll_data %>%
  html_nodes("th") %>%
  html_text() %>%
  as.data.frame() %>%
  `colnames<-`("name") %>%
  mutate(name = str_remove_all(name, "name"),
         name = str_remove_all(name, "mean"),
         name = str_remove_all(name, "stdev")) %>%
  filter(name != "") %>%
  .[x,1]
}

names <- map(1:poll_count, poll_name) %>%
  as.data.frame() %>%
  gather(name) %>%
  select(value) %>%
  mutate(poll_id = 1:poll_count)

# merging answers and questions 
all_answers <- do.call(rbind.data.frame, answer)
all_questions <- names

full_content <- all_questions %>%
  left_join(all_answers, by = "poll_id") %>%
  rename("name" = `value.x`,
         "value" = `value.y`)
  
# plotting charts
poll_chart <- function(x){
  full_content %>%
  filter(poll_id == x) %>%
  ggplot(aes(x = reorder(answer, value), y = value)) + 
  geom_bar(stat = "identity",
           fill = "#5081BD") +
  coord_flip() +
  geom_text(aes(label = value, color = "#DC405B"), 
            size = 3.2,  vjust = 0.35, hjust = 1.2, 
            show.legend = FALSE) +
  theme(axis.text = element_text(size = 8, colour = "black"),
        axis.title.y=element_blank(),
        axis.ticks.y = element_blank(),
        axis.title.x=element_blank(),
        axis.ticks.x = element_blank(),
        panel.background = element_blank()) +
  scale_y_continuous(labels = function(x) paste0(x, "%")) +
    ggtitle(paste0(full_content$name[x])) +
  ggsave(paste0("chart-",
                full_content$name[x],
                "-id",
                full_content$poll_id[x],
                "-",
                Sys.Date(),
                ".jpg"))
}

map(1:poll_count, poll_chart)
