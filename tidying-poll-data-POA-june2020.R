# manually with Sublime
# 1. deleted CSS code
#-------------------------------------------
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
library(rpivotTable)

# reading HTML file without CSS
poll_data <- read_html("~/Downloads/Porto Alegre.html", encoding = "UTF-8")

#-------------------------------------------
# type 2 tables

# getting all questions for each type tables
# https://stackoverflow.com/questions/62390373/how-to-get-html-element-that-is-before-a-certain-class
type2_question <- poll_data %>%
  html_nodes(xpath = "//td[table[./thead/tr/th/text() = 'answers']]/preceding-sibling::th") %>%
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
    mutate(value = round(as.numeric(value), digits = 3),
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
  html_nodes(xpath = "//td[table[./thead/tr/th/text() = 'Reference']]/preceding-sibling::th") %>%
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

write.csv(type3_full_content, "type3_full_content.csv")

# creating pivot table for cross_col questions
# generating JPEG of these tables

#### 1
library(knitr)
library(kableExtra)
dt <- type3_pivot %>%
  group_by(Resposta) %>%
  spread(`Opções da categoria`, value_perc)


g <- dt %>%
        kable() %>%
        kable_styling()
g

#### 2
library(expss)

my_table <- type3_pivot %>%
  tab_cells(Resposta) %>%
  tab_weight(value_perc) %>% 
  tab_cols(Opcoes_da_categoria, Categoria) %>%
  tab_stat_cpct(total_label = NULL) %>%
  tab_pivot()
  
my_table

library(gridExtra)
png("my_table.png", height = 50*nrow(my_table), width = 200*ncol(my_table))
grid.table(my_table)
dev.off()


teste <- type3_pivot %>%
  calc_cro_cpct(
    cell_vars = list(Resposta),
    col_vars = list(Categoria, `Opções da categoria`)) %>% 
  set_caption("Table 1")


#### 3
type3_pivot <- type3_full_content %>%
  filter(poll_id == 1) %>%
  arrange(category_type) %>%
  mutate(value_perc = round(value * 100)) %>%
  rename("Categoria" = "category_type",
         "Opções da categoria" = "category_answer",
         "Resposta" = "answer") %>%
  select(Categoria, `Opções da categoria`, Resposta, value_perc)

type3_pivot$Categoria[type3_pivot$Categoria == "educational_level"] <- "Nível educacional"
type3_pivot$Categoria[type3_pivot$Categoria == "gender"] <- "Gênero"
type3_pivot$Categoria[type3_pivot$Categoria == "region"] <- "IDH"
type3_pivot$Categoria[type3_pivot$Categoria == "religion"] <- "Religião"
type3_pivot$Categoria[type3_pivot$Categoria == "vote_2018_second_round"] <- "Voto 2018 - 2º turno"

# defining categories for table
type3_pivot_1 <- type3_pivot %>%
  filter(Categoria == "Gênero" 
         | Categoria == "Religião")

type3_pivot_2 <- type3_pivot %>%
  filter(Categoria == "IDH" 
         | Categoria == "Nível educacional" 
         | Categoria == "Voto 2018 - 2º turno")

# plotting tables
rpivotTable(type3_pivot_1,rows="Resposta", 
            cols=c("Categoria","Opções da categoria"),
            vals = "value_perc", 
            aggregatorName = "Sum",
            width="100%", 
            height="400px")

rpivotTable(type3_pivot_2,rows="Resposta", 
            cols=c("Categoria","Opções da categoria"),
            vals = "value_perc", 
            aggregatorName = "Sum",
            width="100%", 
            height="400px")

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
    mutate(value = round(as.numeric(value), digits = 3),
           poll_id = x)
}

type1_answer <- map_dfr(1:count_type1_poll, get_type1_poll_answer)

# joining questions and answers for type 1 tables
type1_full_content <- type1_question %>%
  left_join(type1_answer, by = "poll_id") %>%
  select(question, answer, value, poll_id)

write.csv(type1_full_content, "type1_full_content.csv")
