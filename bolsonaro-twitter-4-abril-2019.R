############# 
#### collection data of jair bolsonaro's twitter
#############

# installing libraries

install.packages("rtweet")
install.packages("broom")
install.packages("plyr")
install.packages("readxl")

# loading libraries

library(readxl)
library(rtweet)
library(tidyverse)
library(lubridate)
library(broom)
library(xlsx)
library(data.table)
library(plyr)
library(ggplot2)

# create token and save it as an environment variable
twitter_token <- create_token(
  app = "",
  consumer_key = "",
  consumer_secret = "",
  access_token = "",
  access_secret = ""
)

identical(twitter_token, get_token())

bolsonaro_tweets <- get_timeline(user = "jairbolsonaro", n = 5000)
bolsonaro_tweets <- data.frame(lapply(bolsonaro_tweets, as.character), stringsAsFactors=FALSE)

write.xlsx(as_tibble(bolsonaro_tweets), 
           file="bolsonaro_tweets_3_abril_2019.xlsx")

##
# importing file with tweets
setwd("~/Downloads/")
tweets <- fread("bolsonaro_tweets_csv_3_abril_2019_g1.csv", encoding = "Latin-1")


list <- strsplit(tweets$created_at, " ")
data_hora <- ldply(list)
colnames(data_hora) <- c("data", "hora")

tweets_df <- cbind(tweets, data_hora)

tweets_df$profile_image_url <- NULL
tweets_df$profile_background_url <- NULL
tweets_df$profile_banner_url <- NULL
tweets_df$account_lg <- NULL
tweets_df$profile_expanded_url <- NULL
tweets_df$profile_url <- NULL
tweets_df$verified <- NULL
tweets_df$account_created_at <- NULL
tweets_df$favorites_count <- NULL
tweets_df$statuses_count <- NULL
tweets_df$listed_count <- NULL
tweets_df$friends_count <- NULL
tweets_df$followers_count <- NULL
tweets_df$protected <- NULL
tweets_df$url <- NULL
tweets_df$description <- NULL
tweets_df$location <- NULL
tweets_df$name <- NULL

tweets_df$geo_coords <- NULL
tweets_df$coords_coords <- NULL
tweets_df$country_code <- NULL
tweets_df$country <- NULL
tweets_df$place_type <- NULL
tweets_df$place_full_name <- NULL
tweets_df$place_url <- NULL
tweets_df$bbox_coords <- NULL

tweets_df$lang <- NULL
tweets_df$account_lang <- NULL
tweets_df$user_id <- NULL
tweets_df$V1 <- NULL
tweets_df$status_id <- NULL
tweets_df$created_at <- NULL

tweets_df$urls_url <- NULL
tweets_df$urls_t.co <- NULL
tweets_df$urls_expanded_url <- NULL
tweets_df$media_url <- NULL
tweets_df$media_t.co <- NULL
tweets_df$media_expanded_url <- NULL
tweets_df$media_type <- NULL
tweets_df$ext_media_url <- NULL
tweets_df$ext_media_t.co <- NULL
tweets_df$ext_media_expanded_url <- NULL
tweets_df$ext_media_type <- NULL
tweets_df$favourites_count <- NULL

tweets_df$retweet_user_id <- NULL
tweets_df$retweet_description <- NULL
tweets_df$retweet_location <- NULL
tweets_df$retweet_name <- NULL
tweets_df$place_name <- NULL
tweets_df$quoted_location <- NULL
tweets_df$quoted_friends_count <- NULL
tweets_df$quoted_name <- NULL
tweets_df$quoted_user_id <- NULL
tweets_df$symbols <- NULL
tweets_df$hashtags <- NULL

tweets_df$retweet_followers_count <- NULL
tweets_df$retweet_friends_count <- NULL
tweets_df$retweet_statuses_count <- NULL
tweets_df$retweet_status_id <- NULL
tweets_df$retweet_source <- NULL
tweets_df$mentions_user_id <- NULL

tweets_df$quoted_source <- NULL
tweets_df$quoted_followers_count <- NULL
tweets_df$quoted_statuses_count <- NULL

################################################
# QUANDO FOR TWEET PRÓPRIO:
# favorite_count <- likes em tweet do Bolsonaro
# retweet_count <- RT em tweet do Bolsonaro
#
# QUANDO FOR RETWEET:
# retweet_favorite_count <- likes no tweet original
# retweet_retweet_count <- RT no tweet original
#
# QUANDO FOR QUOTED:
# quoted_favorite_count
# quoted_retweet_count
#
###############################################


#tweets_scraped <- fread("bolso-15h25.csv", encoding = "Latin-1", sep = "|", header = FALSE)

var <- read.table("bolso-16h15.csv", sep=";")

my_data <- read_excel("bolso-16h15.xlsx", col_names = FALSE)

#my_data2 <- read.xlsx("bolso-16h15.xlsx", sheetIndex = 1, header = F, encoding = "Latin-1")

colnames(my_data) <- c("id", "date", "join_date", "join_time", "time", "timezone", "username", "tweet", "hashtag", "url", "replies", "retweets", "likes", "link", "is_retweet", "user_rt", "mentions", "media", "private", "verified", "avatar")


my_data$join_date <- NULL
my_data$join_time <- NULL

## need to solve problem with encoding


list <- strsplit(my_data$date, "-")
date <- ldply(list)
colnames(date) <- c("ano", "mes", "dia")

my_data_new <- cbind(my_data, date)

my_data_new[20] <- NULL


#### Número de tweets por ano
tweets_por_ano <- my_data_new %>%
  group_by(ano) %>%
  summarise(total_tweets = count(ano))


## Número de tweets por mês, definindo o ano
tweets_por_mes_2019 <- my_data_new %>%
  filter(ano == 2019) %>%
  group_by(mes) %>%
  summarise(total_tweets = count(mes)) %>%
  mutate(ano = 2019)

tweets_por_mes_2018 <- my_data_new %>%
  filter(ano == 2018) %>%
  group_by(mes) %>%
  summarise(total_tweets = count(mes)) %>%
  mutate(ano = 2018)

#### Número de likes (ou replies, ou RTs) por ano

## FAZEEEEEEEEEEEEEEEER

## Número de likes por mês, definido o ano


#### Encontrar determinada palavra
palavra_tweet <- my_data_new[grep("PrevidÃªncia", my_data_new$tweet),]


## Encontrar mais de uma determinada palavra
palavra_tweet_2 <- my_data_new[grep("fakenews | fake news", my_data_new$tweet),]


## Encontrar determinada palavra, considerando o ano
palavra_tweet_ano <- palavra_tweet %>%
  group_by(ano) %>%
  summarise(total_tweets = count(ano))


#### Tweets com mais likes
order_likes <- my_data_new[order(my_data_new$likes, decreasing = TRUE),]


## Tweets com mais likes em 2019
order_likes_2019 <- order_likes %>%
  filter(ano == 2019)


#### Tweets com mais replies
order_replies <- my_data_new[order(my_data_new$replies, decreasing = TRUE),]


## Tweets com mais replies em 2019
order_replies_2019 <- order_replies %>%
  filter(ano == 2019)


#### Tweets com mais RTs
order_rts <- my_data_new[order(my_data_new$retweets, decreasing = TRUE),]


## Tweets com mais RTs em 2019
order_rts_2019 <- order_rts %>%
  filter(ano == 2019)

#### Usuários mais retuitados


## Usuários mais retuitados em 2019


#### Usuários mais citados


## Usuários mais citados em 2019


#### Palavras mais usadas


## Palavras mais usadas em 2019


#### Dia da semana do tweet


## Hora do tweet






