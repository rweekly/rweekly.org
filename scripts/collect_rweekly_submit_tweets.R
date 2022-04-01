## collects tweets from @rweekly_submit
library(rtweet)

# ## authenticate @rweekly_submit
# ## refer to secure storage for tokens
# create_token(
#   app = "rweekly_submit",
#   consumer_key = "xxx",
#   consumer_secret = "xxx",
#   access_token = "xxx",
#   access_secret = "xxx"
# )

token <- readRDS("~/.rweekly_submit_token.rds")

## get @rweekly_submit mentions
mentions <- rtweet::get_mentions(token = token)

## get the tweets they are in reply to
originals <- rtweet::lookup_tweets(mentions$status_in_reply_to_status_id, token = token)

## preview
# twitterwidget::twitterwidget(originals$status_id[1])

## extract links from original for the last 8 or so days
recents <- originals %>%
  dplyr::filter(as.Date(created_at) > Sys.Date() - 8) %>%
  dplyr::select(status_id, screen_name, text) %>%
  # get the t.co link from the tweet
  dplyr::mutate(urls = stringr::str_extract_all(text, "https://t.co.\\w*")) %>%
  tidyr::unnest(urls) %>%
  # expand the url by hitting it
  dplyr::mutate(longurl = longurl::expand_urls(urls, seconds = 3)$expanded_url) %>%
  # probably images, quotes, etc...
  dplyr::filter(!grepl("^https://twitter", longurl))

## process text into rmarkdown entries
format_rmarkdown_rweekly <- function(l) {

  ## cleanup text
  l$text <- stringr::str_remove_all(l$text, "https://t.co.\\w*")
  l$text <- stringr::str_squish(l$text)

  glue::glue_data(l, "+ [{text} (posted by @{screen_name})]({longurl})")
}

rmd <- format_rmarkdown_rweekly(recents)

readr::write_lines(
  rmd,
  paste0("rweekly_submit_", format(Sys.Date(), "%Y%m%d"), ".Rmd")
)

# ghactions ---------------------------------------------------------------

## WIP

# library(ghactions)
# install_deps()
