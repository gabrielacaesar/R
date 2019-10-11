
################################################################
###           Extração de comentários do YouTube            ###
################################################################

library(tuber)

setwd("~/Downloads/")

app_id <- ""
app_secret <- ""
yt_oauth(app_id, app_secret, token = "")
get_all_comments(video_id = "zVzhy3-clXI")
comments <- get_all_comments(video_id = "zVzhy3-clXI")
COMMENTS1 <- get_all_comments(video_id = "zVzhy3-clXI")
write.csv(COMMENTS1, file = "youtubecomments.csv")



