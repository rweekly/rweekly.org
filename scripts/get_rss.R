# usage:
# f <- read.csv("rss_feeds.csv")
# f <- f[f$ENABLE == 1, , drop = FALSE]
# x <- get_rss_posts(f$URL)

get_rss_posts <- function(feeds = NULL, since_days_ago = 10) {
  stopifnot("feeds can not be missing" = !is.null(feeds))
  res <- unlist(purrr::map(feeds, ~.get_rss_post(.x, since_days_ago = since_days_ago)))
  cat(res, sep = "\n")
  invisible(res)
}

.get_rss_post <- function(feed, since_days_ago = 10) {
  message("parsing ", feed)
  all_posts <- try(tidyRSS::tidyfeed(feed), silent = TRUE)
  if (inherits(all_posts, "try-error")) {
    warning("feed reading failed for ", feed)
    return(NULL)
  }
  title_col <- if (utils::hasName(all_posts, "item_title")) {
    "item_title"
  } else if (utils::hasName(all_posts, "entry_title")) {
    "entry_title"
  }
  url_col <- if (utils::hasName(all_posts, "item_link")) {
    "item_link"
  } else if (utils::hasName(all_posts, "entry_link")) {
    "entry_link"
  }
  date_col <- if (utils::hasName(all_posts, "item_pub_date")) {
    "item_pub_date"
  } else if (utils::hasName(all_posts, "entry_published")) {
    "entry_published"
  } else {
    all_posts$inferred_date <- as.POSIXct(
      stringr::str_extract(all_posts[[url_col]], "20[0-9]{2}/[0-9]{2}/[0-9]{2}")
    )
    # if no date can be inferred, this would just return everything, so return nothing
    if (all(is.na(all_posts$inferred_date))) return(NULL)
    "inferred_date"
  }
  recent <- as.POSIXct(all_posts[[date_col]]) >= as.POSIXct(Sys.Date() - since_days_ago)
  new_posts <- all_posts[recent, , drop = FALSE]
  new_posts <- new_posts[!is.na(new_posts[[url_col]]), , drop = FALSE]
  if (nrow(new_posts) == 0) return(NULL)
  # process atom slugs
  if (all(startsWith(new_posts[[url_col]], "/")) && utils::hasName(new_posts, "item_guid")) {
    new_posts[[url_col]] <- paste0(urltools::domain(feed), new_posts[[url_col]])
  }
  message("*** ", nrow(new_posts), " posts detected!")
  glue::glue("+ [{new_posts[[title_col]]}]({new_posts[[url_col]]})")
}
