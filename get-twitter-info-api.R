# instalando o pacote

# install.packages("twitterR")
install.packages("rtweet")
install.packages("streamR")

#library(twitterR)
library(rtweet)
library(streamR)

app <- "gabriela"
consumer_key <- "PoxHM6Y2A69Gvgdg3E72X7jQj"
consumer_secret <- "a1rekzBnGuqVxOh34jYHJeNkLxNuelllJmFqkmyl1h3irliPC0"
access_token <- "2551415983-mekQ74YqOTRVD77lqtYFZxrILFHshy1o9963060"
access_secret <- "8KNMvmZnunx8dKhB6fgeUrwP85Iq9Z75wXGmGPjZRG4Tm"

# link do tutorial
# https://cfss.uchicago.edu/webdata002_twitter_exercise.html

twitter_token <- create_token(
  app = app,
  consumer_key = consumer_key,
  consumer_secret = consumer_secret,
  access_token = access_token,
  access_secret = access_secret
)


rt <- search_tweets(
  q = "#b17",
  n = 3000,
  include_rts = FALSE
)

rt

## searching users

countvoncount <- get_timeline(user = "jairbolsonaro", n = 8000)
countvoncount
