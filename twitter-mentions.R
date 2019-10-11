# install.packages("twitteR")
library(twitteR)
library(tidyverse)

api_key <- ""
api_secret <- ""
access_token <- ""
access_token_secret <- ""

setup_twitter_oauth(api_key, api_secret, access_token, access_token_secret)

tweets <- searchTwitter("@jairbolsonaro", n = 10000, lang = "pt")
tweetsDF <- twListToDF(tweets)

teste <- tweetsDF %>%
  group_by(screenName) %>%
  summarise(int = n())

## trend
trend <- availableTrendLocations()
head(trend)
trend

world <- getTrends(1)
world

delhi <- getTrends(20070458)
head(delhi)

## timeline
t <- getUser("jairbolsonaro")
t
userTimeline(t, n = 10)
