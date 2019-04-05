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

library(dplyr)
library(data.table)
library(xlsx)
library(tidyr)
library(plyr)

# create token and save it as an environment variable
twitter_token <- create_token(
  app = "",
  consumer_key = "",
  consumer_secret = "",
  access_token = "",
  access_secret = ""
)

identical(twitter_token, get_token())

bolsonaro_tweets <- get_timeline(user = "jairbolsonaro", n = 15000)
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


my_data <- fread("gabriela_bolsonaro.csv", header = T, sep = "\t", encoding = "UTF-8")

my_data$id <- NULL
my_data$created_at <- NULL
my_data$timezone <- NULL
my_data$user_id <- NULL
my_data$name <- NULL
my_data$place <- NULL
my_data$location <- NULL
my_data$retweet <- NULL


list <- strsplit(my_data$date, "-")
date <- ldply(list)
colnames(date) <- c("ano", "mes", "dia")

my_data_new <- cbind(my_data, date)

summary(my_data_new)

#### Número de tweets por ano
tweets_por_ano <- my_data_new %>%
  dplyr::group_by(ano) %>%
  summarise(total_tweets = count(ano))



## Número de tweets por mês, definindo o ano
tweets_por_mes_2019 <- my_data_new %>%
  filter(ano == 2019) %>%
  dplyr::group_by(mes) %>%
  summarise(total_tweets = count(mes)) %>%
  mutate(ano = 2019) %>%
  ungroup()

write.csv(tweets_por_mes_2019, "tweets_por_mes_2019.csv", row.names = T, quote = F)

tweets_por_mes_2018 <- my_data_new %>%
  filter(ano == 2018) %>%
  dplyr::group_by(mes) %>%
  summarise(total_tweets = count(mes)) %>%
  mutate(ano = 2018)

write.csv(tweets_por_mes_2018, "tweets_por_mes_2018.csv", row.names = T, quote = F)


tweets_por_mes_2017 <- my_data_new %>%
  filter(ano == 2017) %>%
  dplyr::group_by(mes) %>%
  summarise(total_tweets = count(mes)) %>%
  mutate(ano = 2017)

write.csv(tweets_por_mes_2017, "tweets_por_mes_2017.csv", row.names = T, quote = F)


tweets_por_mes_2016 <- my_data_new %>%
  filter(ano == 2016) %>%
  dplyr::group_by(mes) %>%
  summarise(total_tweets = count(mes)) %>%
  mutate(ano = 2016)

write.csv(tweets_por_mes_2016, "tweets_por_mes_2016.csv", row.names = T, quote = F)


tweets_por_mes_2015 <- my_data_new %>%
  filter(ano == 2015) %>%
  dplyr::group_by(mes) %>%
  summarise(total_tweets = count(mes)) %>%
  mutate(ano = 2015)

write.csv(tweets_por_mes_2015, "tweets_por_mes_2015.csv", row.names = T, quote = F)


tweets_por_mes_2014 <- my_data_new %>%
  filter(ano == 2014) %>%
  dplyr::group_by(mes) %>%
  summarise(total_tweets = count(mes)) %>%
  mutate(ano = 2014)

write.csv(tweets_por_mes_2014, "tweets_por_mes_2014.csv", row.names = T, quote = F)


tweets_por_mes_2013 <- my_data_new %>%
  filter(ano == 2013) %>%
  dplyr::group_by(mes) %>%
  summarise(total_tweets = count(mes)) %>%
  mutate(ano = 2013)

write.csv(tweets_por_mes_2013, "tweets_por_mes_2013.csv", row.names = T, quote = F)


tweets_por_mes_2012 <- my_data_new %>%
  filter(ano == 2012) %>%
  dplyr::group_by(mes) %>%
  summarise(total_tweets = count(mes)) %>%
  mutate(ano = 2012)

write.csv(tweets_por_mes_2012, "tweets_por_mes_2012.csv", row.names = T, quote = F)


tweets_por_mes_2011 <- my_data_new %>%
  filter(ano == 2011) %>%
  dplyr::group_by(mes) %>%
  summarise(total_tweets = count(mes)) %>%
  mutate(ano = 2011)

write.csv(tweets_por_mes_2011, "tweets_por_mes_2011.csv", row.names = T, quote = F)


tweets_por_mes_2010 <- my_data_new %>%
  filter(ano == 2010) %>%
  dplyr::group_by(mes) %>%
  summarise(total_tweets = count(mes)) %>%
  mutate(ano = 2010)

write.csv(tweets_por_mes_2010, "tweets_por_mes_2010.csv", row.names = T, quote = F)



# tweets_por_mes_ano <- cbind(tweets_por_mes_2019, tweets_por_mes_2018,
#                                tweets_por_mes_2017, tweets_por_mes_2016, 
#                                tweets_por_mes_2015, tweets_por_mes_2014, 
#                                tweets_por_mes_2013, tweets_por_mes_2012,
#                                tweets_por_mes_2011, tweets_por_mes_2010)


#################################################
#### Número de likes (ou replies, ou RTs) por ano

likes_por_ano <- my_data_new %>%
  dplyr::group_by(ano) %>%
  dplyr::summarise(total_likes = sum(likes_count)) 

## Número de likes por mês, definido o ano

likes_por_mes_2019 <- my_data_new %>%
  filter(ano == 2019) %>%
  dplyr::group_by(mes) %>%
  dplyr::summarise(total_likes = sum(likes_count)) %>%
  mutate(ano = 2019)

likes_por_mes_2018 <- my_data_new %>%
  filter(ano == 2018) %>%
  dplyr::group_by(mes) %>%
  dplyr::summarise(total_likes = sum(likes_count)) %>%
  mutate(ano = 2018)


#### Número de replies por ano

replies_por_ano <- my_data_new %>%
  dplyr::group_by(ano) %>%
  dplyr::summarise(total_replies = sum(replies_count)) 

## Número de replies por mês, definido o ano

replies_por_mes_2019 <- my_data_new %>%
  filter(ano == 2019) %>%
  dplyr::group_by(mes) %>%
  dplyr::summarise(total_replies = sum(replies_count)) %>%
  mutate(ano = 2019)

replies_por_mes_2018 <- my_data_new %>%
  filter(ano == 2018) %>%
  dplyr::group_by(mes) %>%
  dplyr::summarise(total_replies = sum(replies_count)) %>%
  mutate(ano = 2018)

#### Número de RTs recebidos por ano

retweets_por_ano <- my_data_new %>%
  dplyr::group_by(ano) %>%
  summarise(total_retweets = sum(retweets_count)) 

## Número de RTs recebidos por mês, definido o ano

retweets_por_mes_2019 <- my_data_new %>%
  filter(ano == 2019) %>%
  dplyr::group_by(mes) %>%
  dplyr::summarise(total_retweets = sum(retweets_count)) %>%
  mutate(ano = 2019)

retweets_por_mes_2018 <- my_data_new %>%
  filter(ano == 2018) %>%
  dplyr::group_by(mes) %>%
  dplyr::summarise(total_retweets = sum(retweets_count)) %>%
  mutate(ano = 2018)

########################################################

#### Encontrar determinada palavra
palavra_tweet <- my_data_new[grep("Previdência", my_data_new$tweet),]


## Encontrar mais de uma determinada palavra
palavra_tweet_2 <- my_data_new[grep("fakenews | fake news", my_data_new$tweet),]


## Encontrar determinada palavra, considerando o ano
palavra_tweet_ano <- palavra_tweet %>%
  dplyr::group_by(ano) %>%
  dplyr::summarise(total_tweets = count(ano))


#### Tweets com mais likes
order_likes <- my_data_new[order(my_data_new$likes_count, decreasing = TRUE),]


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
# não temos RTs no DF raspado

## Usuários mais retuitados em 2019
# não temos RTs no DF raspado


#### Usuários mais citados (@mentions)

# ok

## Usuários mais citados (@mentions) em 2019

# ok


#### Palavras mais usadas



## Palavras mais usadas em 2019


