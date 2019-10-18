library(rvest)
library(tidyverse)
library(jsonlite)

# to run the code you need to get and replace your {API_KEY} 

# videos of channel
url_channel <- "https://www.googleapis.com/youtube/v3/search?key={API_KEY}&channelId=UCY-8xcFwlVuy6jmUD1DG1Rg&part=snippet,id&order=date&maxResults=50"

video_list <- fromJSON(url_channel) %>%
  as.data.frame()

video_list 

#setwd("~/Downloads")
#write.csv(video_list, "video_list.csv")

# comments of video
url_comment <- "https://www.googleapis.com/youtube/v3/commentThreads?part=snippet,replies&videoId=tBdcmN3lOIw&key={API_KEY}&maxResults=100"

comment_list <- fromJSON(url_comment) %>%
  as.data.frame()

comment_list

# stats of channel

url_channel_stats <- "https://www.googleapis.com/youtube/v3/channels?part=statistics&id=UCY-8xcFwlVuy6jmUD1DG1Rg&key={API_KEY}"

stats_channel_list <- fromJSON(url_channel_stats) %>%
  as.data.frame()

stats_channel_list

# stats of video

url_video_stats <- "https://www.googleapis.com/youtube/v3/videos?part=statistics&id=tBdcmN3lOIw&key={API_KEY}"

stats_video_list <- fromJSON(url_video_stats) %>%
  as.data.frame()
  
stats_video_list

# teste

n <- "https://www.googleapis.com/youtube/v3/commentThreads?part=snippet,replies&videoId=tBdcmN3lOIw&key={API_KEY}&maxResults=100&nextPageToken=2"

comment_list_n <- fromJSON(n) %>%
  as.data.frame()

comment_list_n
