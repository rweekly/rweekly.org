# usage:
# f <- read.csv("rss_feeds.csv")
# f <- f[f$ENABLE == 1, , drop = FALSE]
# x <- get_rss_posts(f$URL)

get_rss_posts <- function(feeds = NULL, since_days_ago = 10) {
  stopifnot("feeds can not be missing" = !is.null(feeds))
  res <- unlist(purrr::map(
    feeds,
    ~ .get_rss_post(.x, since_days_ago = since_days_ago)
  ))
  cat(res, sep = "\n")
  invisible(res)
}

.get_rss_post <- function(feed, since_days_ago = 10) {
  message("Checking: ", feed)
  all_posts <- try(tidyRSS::tidyfeed(feed), silent = TRUE)
  if (inherits(all_posts, "try-error")) {
    message("⛔️ ", "Feed reading failed for ", feed, "\n")
    return(invisible(NULL))
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
  missing_date <- all_posts[is.na(all_posts[[date_col]]), , drop = FALSE]
  if (nrow(missing_date)) {
    message(
      "ℹ️ ",
      "Not including the following posts with unknown date"
    )
    for (i in seq_len(nrow(missing_date))) {
      message("❌ ", missing_date[i, url_col])
    }
    message("\n")
  }
  all_posts <- all_posts[!is.na(all_posts[[date_col]]), , drop = FALSE]
  if (nrow(all_posts) == 0) return(invisible(NULL))

  recent <- as.POSIXct(all_posts[[date_col]]) >=
    as.POSIXct(Sys.Date() - since_days_ago)
  if (sum(recent, na.rm = TRUE) < nrow(all_posts)) {
    # old_posts <- all_posts[!recent, , drop = FALSE]
    message(
      "ℹ️ ",
      "Not including ",
      nrow(all_posts) - sum(recent, na.rm = TRUE),
      " posts older than ",
      since_days_ago,
      " days\n"
    )
    # for (i in seq_len(nrow(old_posts))) {
    #   message("❌ ", old_posts[i, url_col])
    # }
    # message("\n")
  }
  new_posts <- all_posts[recent, , drop = FALSE]
  if (nrow(new_posts) == 0) return(invisible(NULL))

  if (any(is.na(new_posts[[url_col]]))) {
    message("ℹ️ ", "Not including the following posts missing a URL")
    missing_urls <- new_posts[is.na(new_posts[[url_col]]), , drop = FALSE]
    for (i in seq_len(nrow(missing_urls))) {
      message("❌ ", missing_urls[i, title_col])
    }
    message("\n")
  }
  new_posts <- new_posts[!is.na(new_posts[[url_col]]), , drop = FALSE]
  if (nrow(new_posts) == 0) return(invisible(NULL))

  # process atom slugs
  if (
    all(startsWith(new_posts[[url_col]], "/")) &&
      utils::hasName(new_posts, "item_guid")
  ) {
    new_posts[[url_col]] <- paste0(urltools::domain(feed), new_posts[[url_col]])
  }

  can_reach <- sapply(new_posts[[url_col]], RCurl::url.exists)
  if (any(!can_reach)) {
    unreach <- new_posts[!can_reach, , drop = FALSE]
    message("ℹ️ ", "Not including the following unreachable URLs")
    for (i in seq_len(nrow(unreach))) {
      message("❌ ", new_posts[i, url_col])
    }
    message("\n")
  }
  new_posts <- new_posts[can_reach, , drop = FALSE]
  if (nrow(new_posts) == 0) return(invisible(NULL))

  message("✅ ", nrow(new_posts), " posts detected!")
  for (i in seq_len(nrow(new_posts))) {
    message("   ⭐️ ", new_posts[i, url_col])
  }
  message("\n")

  glue::glue("+ [{new_posts[[title_col]]}]({new_posts[[url_col]]})")
}
