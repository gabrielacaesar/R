# manually with Sublime
# 1. deleted CSS code
#-------------------------------------------
# reading libraries
library(rvest)
library(tidyverse)
library(varhandle)

# reading HTML file without CSS
poll_data <- read_html("~/Downloads/Porto Alegre.html", encoding = "UTF-8")

#-------------------------------------------
# type 2 tables

# getting all questions for each type tables
type2_question <- poll_data %>%
  html_nodes(xpath = "//td[table[./thead/tr/th/text() = 'answers']]/preceding-sibling::th") %>%
  html_text() %>%
  as.data.frame() %>%
  rename("question" = ".") %>%
  mutate(poll_id = row_number())

# naming wrong answers for related name type 2 tables
wrong_answer <- poll_data %>%
  html_nodes(xpath = "//table[./thead/tr/th/text() = 'answers']/tbody/tr/td/table/tbody/tr/td[1]") %>%
  html_text() %>%
  as.data.frame() %>%
  rename("answer" = ".") %>%
  mutate(answer = unfactor(answer)) %>%
  unique()

# getting right answers for related name type 2 tables
names_answer <- poll_data %>%
  html_nodes(xpath = "//table[./thead/tr/th/text() = 'answers']/tbody/tr/td[1]") %>%
  html_text() %>%
  as.data.frame() %>%
  rename("answer" = ".") %>%
  filter(!str_detect(answer, paste(wrong_answer$answer, collapse = "|"))) %>%
  mutate(answer = unfactor(answer))

# counting number of each type tables
count_type2_poll <- poll_data %>%
  html_nodes(xpath = "//table[./thead/tr/th/text() = 'answers']/tbody") %>%
  length()

# getting answer for type 2 tables
get_type2_poll_answer <- function(x){
  poll_data %>%
    html_nodes(xpath = "//table[./thead/tr/th/text() = 'answers']/tbody") %>%
    .[x] %>%
    html_nodes("tr > td") %>%
    html_text() %>%
    as.data.frame() %>%
    rename("answer" = ".") %>%
    mutate(answer = unfactor(answer)) %>%
    filter(!str_detect(str_trim(answer), "stdev")) %>%
    mutate(related_name = ifelse(str_detect(str_trim(answer), 
                                            paste(names_answer$answer, collapse = "|")),
                                 answer, NA)) %>%
    fill(related_name, .direction = "down") %>%
    mutate(value = ifelse(str_detect(answer, "\\."), 
                          answer, NA)) %>%
    fill(value, .direction = "up") %>%
    filter(answer != related_name &
             answer != value) %>%
    mutate(value = round(as.numeric(value), digits = 3),
           poll_id = x) %>%
    select(poll_id, related_name, answer, value)
}

type2_answer <- map_dfr(1:count_type2_poll, get_type2_poll_answer)

# joining questions and answers for type 2 tables
type2_full_content <- type2_question %>%
  left_join(type2_answer, by = "poll_id") %>%
  select(question, related_name, answer, value, poll_id)

# creating file and setting it as environment
dir.create(paste0("~/Downloads/poll_data_", Sys.Date()))
setwd(paste0("~/Downloads/poll_data_", Sys.Date()))

write.csv(type2_full_content, paste0("type2_full_content", Sys.time(), ".csv"))

#-------------------------------------------
# type 3 tables

# getting all questions for type 3 tables
type3_question <- poll_data %>%
  html_nodes(xpath = "//td[table[./thead/tr/th/text() = 'Reference']]/preceding-sibling::th") %>%
  html_text() %>%
  as.data.frame() %>%
  rename("question" = ".") %>%
  mutate(poll_id = row_number())

# getting related answer for type 3 tables
type3_names_answer <- poll_data %>%
  html_nodes(xpath = "//table[./thead/tr/th/text() = 'Reference']/thead/tr/th") %>%
  html_text() %>%
  as.data.frame() %>%
  rename("related_answer" = ".") %>%
  mutate(related_answer = unfactor(related_answer)) %>%
  group_by(related_answer) %>%
  mutate(poll_id = ifelse(str_detect(str_trim(related_answer), "Reference"), 1:n(), NA)) %>%
  ungroup() %>%
  fill(poll_id, .direction = "down") %>%
  filter(related_answer != "Reference") %>%
  group_by(poll_id) %>%
  mutate(id_cross = row_number()) %>%
  ungroup() %>%
  separate(related_answer, c("category_type", "category_answer"), sep = "\\|")

# getting possible answer for type 3 tables
type3_possible_answer <- poll_data %>%
  html_nodes(xpath = "//table[./thead/tr/th/text() = 'Reference']/tbody/tr/td[1]") %>%
  html_text() %>%
  as.data.frame() %>%
  rename("answer" = ".") %>%
  mutate(answer = unfactor(answer)) %>%
  unique()

# counting number of type 3 tables
count_type3_poll <- poll_data %>%
  html_nodes(xpath = "//table[./thead/tr/th/text() = 'Reference']") %>%
  length()

# getting answer for type 3 tables
get_type3_poll_answer <- function(x){
  poll_data %>%
    html_nodes(xpath = "//table[./thead/tr/th/text() = 'Reference']") %>%
    .[x] %>%
    html_nodes("tr > td") %>%
    html_text() %>%
    as.data.frame() %>%
    rename("value" = ".") %>%
    mutate(value = unfactor(value)) %>%
    mutate(answer = ifelse(str_detect(value, 
                                      paste(type3_possible_answer$answer, collapse = "|")), 
                           value, NA)) %>%
    fill(answer, .direction = "down") %>%
    filter(value != answer) %>%
    mutate(value = round(as.numeric(value), digits = 3)) %>%
    replace(is.na(.), 0) %>%
    group_by(answer) %>%
    mutate(id_cross = row_number(),
           poll_id = x)
}

type3_answer <- map_dfr(1:count_type3_poll, get_type3_poll_answer)

# joining questions and answers for type 3 tables
type3_full_content <- type3_answer %>%
  left_join(type3_question, by = "poll_id") %>%
  left_join(type3_names_answer, by = c("poll_id", "id_cross")) %>%
  select(question, category_type, category_answer, answer, value, poll_id, id_cross)

write.csv(type3_full_content, paste0("type3_full_content", Sys.time(), ".csv"))

#-------------------------------------------
# type 1 tables

# getting all questions for each type tables
type1_question <- poll_data %>%
  html_nodes(xpath = "//td[table[./thead/tr/th/text() = 'stdev']]/preceding-sibling::th") %>%
  html_text() %>%
  as.data.frame() %>%
  rename("question" = ".") %>%
  mutate(question = unfactor(question)) %>%
  mutate(poll_id = row_number())

# counting number of type 1 tables
count_type1_poll <- poll_data %>%
  html_nodes(xpath = "//td[table[./thead/tr/th/text() = 'stdev']]/preceding-sibling::th/following-sibling::td/table/tbody") %>%
  length()

# getting answer for type 1 tables
get_type1_poll_answer <- function(x){
  poll_data %>%
    html_nodes(xpath = "//td[table[./thead/tr/th/text() = 'stdev']]/preceding-sibling::th/following-sibling::td/table/tbody") %>%
    .[x] %>%
    html_nodes("tr > td") %>%
    html_text() %>%
    as.data.frame() %>%
    rename("answer" = ".") %>%
    mutate(answer = unfactor(answer),
           value = ifelse(str_detect(answer, "\\."), 
                          answer, NA)) %>%
    fill(value, .direction = "up") %>%
    filter(answer != value) %>%
    mutate(value = round(as.numeric(value), digits = 3),
           poll_id = x)
}

type1_answer <- map_dfr(1:count_type1_poll, get_type1_poll_answer)

# joining questions and answers for type 1 tables
type1_full_content <- type1_question %>%
  left_join(type1_answer, by = "poll_id") %>%
  select(question, answer, value, poll_id)

write.csv(type1_full_content, paste0("type1_full_content", Sys.time(), ".csv"))

#-------------------------------------------
# cross_col tables - generating PNG of these tables
# reading libraries
library(knitr)
library(kableExtra)

# creating copy of daframe
type3_pivot <- type3_full_content

# translating categories to portuguese and spanish
# portugues - pt-br
type3_pivot$category_type[type3_pivot$category_type == "educational_level"] <- "Nível educacional"
type3_pivot$category_type[type3_pivot$category_type == "gender"] <- "Gênero"
type3_pivot$category_type[type3_pivot$category_type == "region"] <- "IDH"
type3_pivot$category_type[type3_pivot$category_type == "religion"] <- "Religião"
type3_pivot$category_type[type3_pivot$category_type == "vote_2018_second_round"] <- "Voto 2018 - 2º turno"
type3_pivot$category_type[type3_pivot$category_type == "family_income"] <- "Faixa de renda"
type3_pivot$category_type[type3_pivot$category_type == "age"] <- "Faixa etária"

# spanish - es-arg
#type3_pivot$category_type[type3_pivot$category_type == "family_income"] <- "Rendimiento"
#type3_pivot$category_type[type3_pivot$category_type == "gender"] <- "Sexo"
#type3_pivot$category_type[type3_pivot$category_type == "vote_last_election"] <- "Voto 2019"
#type3_pivot$category_type[type3_pivot$category_type == "age"] <- "Edad"
#type3_pivot$category_type[type3_pivot$category_type == "macroregion"] <- "Región"

# creating list of data considering poll_id
type3_pivot_id <- split(type3_pivot, type3_pivot$poll_id)

#counting number of items in list
count_type3_pivot <- type3_pivot_id %>% length()

# informing which poll we want
### ONLY PLACE TO DEFINE THE CROSS_COL
i <- 1 # could be 2, 3, 4...

# getting cross_col - poll name
poll_name <- as.character(unique(type3_pivot_id[[i]]$question))

# defining cross_col we pick - gender + religion
n1_type3_pivot <- type3_pivot_id[[i]] %>%
  group_by(category_type) %>%
  filter(category_type == "Gênero" | 
           category_type == "Religião") %>%
  mutate(value_perc = round(value * 100)) %>%
  select(category_type, category_answer,
         answer, value_perc) %>%
  pivot_wider(names_from = c(category_type, category_answer), 
              values_from = value_perc, names_sep = "_") %>%
  rename(" " = answer)

# defining cross_col we pick - region + educational level + vote second round
n2_type3_pivot <- type3_pivot_id[[i]] %>%
  group_by(category_type) %>%
  filter(category_type == "IDH" | 
           category_type == "Nível educacional" |
           category_type == "Voto 2018 - 2º turno") %>%
  mutate(value_perc = round(value * 100)) %>%
  select(category_type, category_answer,
         answer, value_perc) %>%
  pivot_wider(names_from = c(category_type, category_answer), 
              values_from = value_perc, names_sep = "_") %>%
  rename(" " = answer)

n_type3_pivot <- list(n1_type3_pivot, n2_type3_pivot)

## SMALL TABLE
# defining number of list
cols_1 <- sub("(.*?)_(.*)", "\\2", names(n_type3_pivot[[1]])) # grab everything after the _
grps_1 <- sub("(.*?)_(.*)", "\\1", names(n_type3_pivot[[1]])) # grab everything before the _

# generating small table
n_type3_pivot[[1]] %>%
  kable(col.names = cols_1, align = "c") %>%
  kable_styling(full_width = F, font_size = 11) %>%
  add_header_above(table(grps_1)[unique(grps_1)], color = "black", 
                   bold = F, 
                   font_size = 13, 
                   line = F,
                   extra_css = "border-bottom:1px solid black;
                   border-right:1px solid black;
                   border-top:1px solid black;
                   border-left:1px solid black;") %>%
  column_spec(1:ncol(n_type3_pivot[[1]]), color = "black", width = "4em", include_thead = T,
              extra_css = "border-bottom:1px solid black; border-top:1px solid black;
              border-right:1px solid black; vertical-align: middle;") %>%
  column_spec(1, bold = T, width = "7em", include_thead = F, 
              extra_css = "border-left:1px solid black;") %>%
  save_kable(paste0("table_",
                    poll_name,
                    Sys.time(),
                    ".png"), zoom = 4)

## LARGE TABLE
# defining number of list
cols_2 <- sub("(.*?)_(.*)", "\\2", names(n_type3_pivot[[2]])) # grab everything after the _
grps_2 <- sub("(.*?)_(.*)", "\\1", names(n_type3_pivot[[2]])) # grab everything before the _

# generating large table
n_type3_pivot[[2]] %>%
  kable(col.names = cols_2, align = "c") %>%
  kable_styling(full_width = F, font_size = 11) %>%
  add_header_above(table(grps_2)[unique(grps_2)], color = "black", 
                   bold = F, 
                   font_size = 13, 
                   line = F,
                   extra_css = "border-bottom:1px solid black;
                   border-right:1px solid black;
                   border-top:1px solid black;
                   border-left:1px solid black;") %>%
  column_spec(1:ncol(n_type3_pivot[[2]]), color = "black", width = "10em", include_thead = T,
              extra_css = "border-bottom:1px solid black; border-top:1px solid black;
              border-right:1px solid black; vertical-align: middle;") %>%
  column_spec(1, bold = T, width = "7em", include_thead = F, 
              extra_css = "border-left:1px solid black;") %>%
  save_kable(paste0("table_",
                    poll_name,
                    Sys.time(),
                    ".png"), zoom = 4)
