# manually with Sublime
# 1. deleted CSS code
#-------------------------------------------
# trying to solve replacement problem: 
# https://stackoverflow.com/questions/62411034/how-to-get-html-element-considering-later-content-of-another-tag-and-not-the-cla
#
# 2. correcting class
#
##### before
# \"array\"
##### after
# "array"
#-------------------------------------------
# 3. added class for type 1 tables:
#
##### before
#<table>
#	<thead>
#		<tr>
#			<th class=\"string\">name</th>
#			<th class=\"string\">mean</th>
#			<th class=\"string\">stdev</th>
#		</tr>
#	</thead>
#	<tbody>
#		<tr>
#
##### after
#<table>
#	<thead>
#		<tr>
#			<th class="string">name</th>
#			<th class="string">mean</th>
#			<th class="string">stdev</th>
#		</tr>
#	</thead>
#	<tbody class="type1">
#		<tr>
#-------------------------------------------
# 4. added class for type 2 tables:
#
##### before
#<table>
#	<thead>
#		<tr>
#			<th class=\"string\">name</th>
#			<th class=\"array\">answers</th>
#		</tr>
#	</thead>
#	<tbody>
#			<tr>
#
##### after
#<table>
#	<thead>
#		<tr>
#			<th class="string type2">name</th>
#			<th class="array type2">answers</th>
#		</tr>
#	</thead>
#	<tbody class="type2">
#			<tr>
#-------------------------------------------
# 5. added class for type 3 tables:
#
##### before
#<table>
#	<thead>
#		<tr>
#			<th class=\"string\">Reference</th>
#
##### after
#<table class="type3">
#  <thead>
#  	<tr class="type3">
#    	<th class="string type3">Reference</th>
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
# https://stackoverflow.com/questions/62390373/how-to-get-html-element-that-is-before-a-certain-class
type2_question <- poll_data %>%
  html_nodes(xpath = "//th[@class = 'string type2']/ancestor::td/preceding-sibling::th") %>%
  html_text() %>%
  as.data.frame() %>%
  rename("question" = ".") %>%
  mutate(poll_id = row_number())

# naming wrong answers for related name type 2 tables
wrong_answer <- poll_data %>%
  html_nodes(xpath = "//tbody[@class = 'type2']//tr//td//table//tbody//tr//td[1]") %>%
  html_text() %>%
  as.data.frame() %>%
  rename("answer" = ".") %>%
  mutate(answer = unfactor(answer)) %>%
  unique()

# getting right answers for related name type 2 tables
names_answer <- poll_data %>%
  html_nodes(xpath = "//tbody[@class = 'type2']//tr//td[1]") %>%
  html_text() %>%
  as.data.frame() %>%
  rename("answer" = ".") %>%
  filter(!str_detect(answer, paste(wrong_answer$answer, collapse = "|"))) %>%
  mutate(answer = unfactor(answer))

# counting number of each type tables
count_type2_poll <- poll_data %>%
  html_nodes("tbody.type2") %>%
  length()

# getting answer for type 2 tables
get_type2_poll_answer <- function(x){
  poll_data %>%
    html_nodes("tbody.type2") %>%
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
    mutate(value = as.numeric(value) * 100,
           poll_id = x) %>%
    select(poll_id, related_name, answer, value)
}

type2_answer <- map_dfr(1:count_type2_poll, get_type2_poll_answer)

# joining questions and answers for type 2 tables
type2_full_content <- type2_question %>%
  left_join(type2_answer, by = "poll_id") %>%
  select(question, related_name, answer, value, poll_id)

write.csv(type2_full_content, "type2_full_content.csv")

#-------------------------------------------
# type 3 tables

# getting all questions for type 3 tables
type3_question <- poll_data %>%
  html_nodes(xpath = "//table[@class = 'type3']/ancestor::td/preceding-sibling::th") %>%
  html_text() %>%
  as.data.frame() %>%
  rename("question" = ".") %>%
  mutate(poll_id = row_number())

# getting related answer for type 3 tables
type3_names_answer <- poll_data %>%
  html_nodes(xpath = "//table[@class = 'type3']//thead//tr[@class = 'type3']//th") %>%
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
  html_nodes(xpath = "//table[@class = 'type3']//tbody//tr//td[1]") %>%
  html_text() %>%
  as.data.frame() %>%
  rename("answer" = ".") %>%
  mutate(answer = unfactor(answer)) %>%
  unique()

# counting number of type 3 tables
count_type3_poll <- poll_data %>%
  html_nodes("table.type3") %>%
  length()

# getting answer for type 3 tables
get_type3_poll_answer <- function(x){
  poll_data %>%
    html_nodes("table.type3") %>%
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
    mutate(value = as.numeric(value) * 100) %>%
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

write.csv(type3_full_content, "type3_full_content.csv")

#-------------------------------------------
# type 1 tables

# getting all questions for each type tables
type1_question <- poll_data %>%
  html_nodes(xpath = "//tbody[@class = 'type1']/ancestor::table/ancestor::td/preceding-sibling::th") %>%
  html_text() %>%
  as.data.frame() %>%
  rename("question" = ".") %>%
  mutate(question = unfactor(question)) %>%
  mutate(poll_id = row_number())

# counting number of type 1 tables
count_type1_poll <- poll_data %>%
  html_nodes("table") %>%
  html_nodes("tbody.type1") %>%
  length()

# getting answer for type 1 tables
get_type1_poll_answer <- function(x){
  poll_data %>%
    html_nodes("table") %>%
    html_nodes("tbody.type1") %>%
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
    mutate(value = as.numeric(value) * 100,
           poll_id = x)
}

type1_answer <- map_dfr(1:count_type1_poll, get_type1_poll_answer)

# joining questions and answers for type 1 tables
type1_full_content <- type1_question %>%
  left_join(type1_answer, by = "poll_id") %>%
  select(question, answer, value, poll_id)

write.csv(type1_full_content, "type1_full_content.csv")
