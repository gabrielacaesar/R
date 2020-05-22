# manually with Sublime
# 1. deleted CSS code
#-------------------------------------------
# 2. added class for type 1 tables:
##### before #####
#<table>
# <thead>
#  <tr>
#  <th class="string">name</th>
#    <th class="string">mean</th>
#      <th class="string">stdev</th>
#        </tr>
#        </thead>
#        <tbody>
#        <tr>
##### after #####  
# <table>
#  <thead>
#  <tr>
#  <th class="string">name</th>
#    <th class="string">mean</th>
#      <th class="string">stdev</th>
#        </tr>
#        </thead>
#        <tbody class="type1">
#          <tr>
#-------------------------------------------
# 3. added class for type 2 tables:
##### before #####
#<table>
#  <thead>
#  <tr>
#  <th class="string">name</th>
#    <th class="array">answers</th>
#      </tr>
#      </thead>
#      <tbody>
#      <tr>
##### after ##### 
#<table>
#  <thead>
#  <tr>
#  <th class="string type2">name</th>
#    <th class="array type2">answers</th>
#      </tr>
#      </thead>
#      <tbody class="type2">
#-------------------------------------------
# 4. added class for type 3 tables:
##### before #####
#<table>
#  <thead>
#  <tr>
#  <th class="string">Reference</th>
##### after ##### 
#<table class="type3">
#  <thead>
#  <tr class="type3">
#    <th class="string type3">Reference</th>


###### code for tidying data ######

# reading libraries
library(rvest)
library(tidyverse)
library(varhandle)

# reading HTML file without CSS
poll_data <- read_html("~/Downloads/poll-argentina/Pesquisa Argentina.html", encoding = "UTF-8")

############################################################
####################### type 2 tables ######################
############################################################

# getting question for type 2 tables
get_type2_poll_question <- c("image_about_following_politicians",
                             "evaluate_leaders_position_on_coronavirus_crisis",
                             "evaluate_foreign_leaders_position_on_coronavirus_crisis",
                             "argentina_economy_evaluation",
                             "argentina_economy_expectation_6m",
                             "CROSSING_macroregion_VS_image_about_following_politicians_JSON",
                             "CROSSING_gender_VS_image_about_following_politicians_JSON",
                             "CROSSING_age_VS_image_about_following_politicians_JSON",
                             "CROSSING_family_income_VS_image_about_following_politicians_JSON",
                             "CROSSING_vote_last_election_VS_image_about_following_politicians_JSON",
                             "CROSSING_macroregion_VS_evaluate_leaders_position_on_coronavirus_crisis_JSON",
                             "CROSSING_gender_VS_evaluate_leaders_position_on_coronavirus_crisis_JSON",
                             "CROSSING_age_VS_evaluate_leaders_position_on_coronavirus_crisis_JSON",
                             "CROSSING_family_income_VS_evaluate_leaders_position_on_coronavirus_crisis_JSON",
                             "CROSSING_vote_last_election_VS_evaluate_leaders_position_on_coronavirus_crisis_JSON",
                             "CROSSING_macroregion_VS_argentina_economy_evaluation_JSON",
                             "CROSSING_gender_VS_argentina_economy_evaluation_JSON",
                             "CROSSING_age_VS_argentina_economy_evaluation_JSON",
                             "CROSSING_family_income_VS_argentina_economy_evaluation_JSON",
                             "CROSSING_vote_last_election_VS_argentina_economy_evaluation_JSON",
                             "CROSSING_macroregion_VS_argentina_economy_expectation_6m_JSON",
                             "CROSSING_gender_VS_argentina_economy_expectation_6m_JSON",
                             "CROSSING_age_VS_argentina_economy_expectation_6m_JSON",
                             "CROSSING_family_income_VS_argentina_economy_expectation_6m_JSON",
                             "CROSSING_vote_last_election_VS_argentina_economy_expectation_6m_JSON")

type2_question <- get_type2_poll_question %>%
  as.data.frame() %>%
  rename("question" = ".") %>%
  mutate(poll_id = row_number())

# defining names for categories for type 2 tables
names_answer <- c("Alberto Fernández",
                  "Mauricio Macri",
                  "Axel Kicillof",
                  "Cristina Fernández de Kirchner",
                  "Horacio Rodríguez Larreta",
                  "María Eugenia Vidal",
                  "Martín Lousteau",
                  "Xi Jinping",
                  "Donald Trump",
                  "Angela Merkel",
                  "Emmanuel Macron",
                  "Pedro Sanchez",
                  "Boris Johnson",
                  "Jair Bolsonaro",
                  "Andres Manuel Lopez Obrador",
                  "Economía de Argentina",
                  "Mercado de trabajo",
                  "Situación de mi familia")

# counting number of type 2 tables
count_type2_poll <- poll_data %>%
  html_nodes("tbody.type2") %>%
  length()

# getting answer for type 2 tables
get_type2_poll_answer <- function(x) {
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
                              paste(names_answer, collapse = "|")),
                               answer, NA)) %>%
    fill(related_name, .direction = "down") %>%
    mutate(value = ifelse(str_detect(answer, "\\."), 
                 answer, NA)) %>%
    fill(value, .direction = "up") %>%
    filter(answer != related_name,
           answer != value) %>%
    mutate(value = as.numeric(value) * 100,
           poll_id = x) %>%
    select(poll_id, related_name, answer, value)
}

type2_answer <- map_dfr(1:count_type2_poll, get_type2_poll_answer)

# merging question and answer for type 2 tables
type2_full_content <- type2_question %>%
  left_join(type2_answer, by = "poll_id")

# downloading type 2 tables CSV
write.csv(type2_full_content, "type2_full_content.csv")

############################################################
####################### type 3 tables ######################
############################################################
# getting question for type 3 tables
get_type3_poll_question <- c("CROSSCOL_government_evaluation",
                             "CROSSCOL_impact_of_coronavirus_in_your_income",
                             "CROSSCOL_agree_measures_to_stop_coronavirus",
                             "CROSSCOL_coronavirus_situation_getting_better_worse",
                             "CROSSCOL_afraid_of_leaving_home",
                             "CROSSCOL_think_the_press_exaggerates_coronavirus_crisis",
                             "CROSSCOL_afraid_of_losing_friend_of_relative_by_coronavirus",
                             "CROSSCOL_country_will_enter_recession",
                             "CROSSCOL_intention_to_buy_goods_next_vs_previous_3m",
                             "CROSSCOL_family_income_in_6_months_bigger_smaller",
                             "CROSSCOL_corruption_is_increasing_or_decreasing",
                             "CROSSCOL_violence_is_increasing_or_decreasing",
                             "CROSSCOL_more_concerned_with_economy_or_losing_relatives",
                             "CROSSCOL_social_isolation_should_be_relaxed",
                             "CROSSCOL_left_home_yesterday")

type3_question <- get_type3_poll_question %>%
  as.data.frame() %>%
  rename("question" = ".") %>%
  mutate(poll_id = row_number())

# counting number of type 3 tables
count_type3_poll <- poll_data %>%
    html_nodes("table.type3") %>%
    length()

# getting question for type 3 tables
get_type3_poll_header <- function(x){
  poll_data %>%
  html_nodes("table.type3") %>%
  .[x] %>%
  html_nodes("tr > th") %>%
  html_text() %>%
  as.data.frame() %>%
  rename("answer" = ".") %>%
  filter(answer != "Reference") %>%
  mutate(id_cross = row_number(),
         poll_id = x)
}

type3_header <- map_dfr(1:count_type3_poll, get_type3_poll_header)

# defining possible answer for type 3 tables
possible_answer_type3_answer <- c(
                      "Apruebo",
                      "Desapruebo",
                      "No sé",
                      "Estoy de acuerdo",
                      "No estoy de acuerdo",
                      "Mejorando",
                      "Empeorando",
                      "Sí, temo enfermarme",
                      "Sí, temo por mi vida",
                      "No",
                      "Sí",
                      "Ni más, ni menos",
                      "Menos compras",
                      "Más compras",
                      "Menor",
                      "Igual",
                      "Mayor",
                      "Aumentando",
                      "Disminuyendo",
                      "Personas que puedan morir",
                      "Coste económico de la crisis",
                      "Flexibilizadas",
                      "Deben permanecer como hasta ahora",
                      "Ampliadas")

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
                        paste(possible_answer_type3_answer, collapse = "|")), 
                        value, NA)) %>%
  fill(answer, .direction = "down") %>%
  filter(value != answer) %>%
  mutate(value = as.numeric(value) * 100) %>%
  group_by(answer) %>%
  mutate(id_cross = row_number(),
         poll_id = x)
}

type3_answer <- map_dfr(1:count_type3_poll, get_type3_poll_answer)
# merging question, header and answer for type 3 tables

type3_full_content <- type3_header %>%
  left_join(type3_answer, by = c("poll_id", "id_cross")) %>%
  left_join(type3_question, by = "poll_id") %>%
  rename("category" = "answer.x",
         "answer" = "answer.y") %>%
  separate(category, c("category_type", "category_answer"), sep = "\\|") %>%
  select(question, category_type, category_answer, answer, value, poll_id, id_cross)

# downloading type 3 tables CSV
write.csv(type3_full_content, "type3_full_content.csv")

############################################################
####################### type 1 tables ######################
############################################################

# the following code must run after type 2 and 3 tables
# because it considers their questions below

# getting question for type 1 tables
type1_question <- poll_data %>%
  html_nodes("table > tr > th") %>%
  html_text() %>%
  as.data.frame() %>%
  rename("question" = ".") %>%
  mutate(repeated_2 = ifelse(str_detect(question, 
                                  paste(type2_question$question, collapse = "|")), 
                       "repeated_question", NA)) %>%
  mutate(repeated_3 = ifelse(str_detect(question, 
                                      paste(type3_question$question, collapse = "|")), 
                           "repeated_question", NA)) %>%
  filter(is.na(repeated_2),
         is.na(repeated_3)) %>%
  select(question) %>%
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

# merging question and answer for type 1 tables

type1_full_content <- type1_question %>%
  left_join(type1_answer, by = "poll_id")

# downloading type 1 tables CSV
write.csv(type1_full_content, "type1_full_content.csv")
