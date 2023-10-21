source("scripts/get_rss.R")
f <- read.csv("rss_feeds.csv")
f <- f[f$ENABLE == 1, , drop = FALSE]
x <- get_rss_posts(f$URL)

cat(x, file = "curatinator_latest.md", sep = "/n")

