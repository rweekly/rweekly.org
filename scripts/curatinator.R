OUTPUT_FILE <- "curatinator_latest.md"

## scrape RSS feeds for new posts in the last 10 days

source("scripts/get_rss.R")
f <- read.csv("rss_feeds.csv")
f <- f[f$ENABLE == 1, , drop = FALSE]
x <- get_rss_posts(f$URL, since_days_ago = 6)

cat("# RSS POSTS: ##\n\n", file = OUTPUT_FILE) # start of overwriting

cat(x, file = OUTPUT_FILE, sep = "\n", append = TRUE)

## scrape CRANberries for new/updated packages in the last 7 days

library(tidyRSS)
library(pkgsearch)
library(dplyr)
library(lubridate)

# create utility functions
tidy_package_name <- function(item_link) {
  pkg_tmp <- strsplit(item_link, "#")[[1]][2]
  res <- strsplit(pkg_tmp, "_")[[1]][1]
  return(res)
}

create_text <- function(package_version, package_name, package_title, feed_type = "new", add_diffify = TRUE, add_update_titles = FALSE) {
  if (feed_type == "new") {
    placeholder <- "+ [{|package_name|} |package_version|](https://cran.r-project.org/package=|package_name|): |package_title|"
  } else if (feed_type == "updated") {
    placeholder <- "+ [{|package_name|} |package_version|](https://cran.r-project.org/package=|package_name|)"
    if (add_update_titles == TRUE){
      placeholder <- stringr::str_c(placeholder, ": |package_title|")
    }
    if (add_diffify == TRUE){
      placeholder <- stringr::str_c(placeholder, " - [diffify](https://diffify.com/R/|package_name|)")
    }
  } else {
    stop("supplied type not recognized!", call. = FALSE)
  }
  x <- glue::glue(placeholder, .open = "|", .close = "|")
  return(x)
}

search_cran_package_insistently <- purrr::insistently(
  pkgsearch::cran_package,
  rate = purrr::rate_backoff(pause_base = 1, pause_cap = 5, max_times = 3),
  quiet = TRUE
)

process_cranberries <- function(feed_type, start_date, end_date = as.Date(lubridate::now())) {
  # form the URL based on type (either "new" or "updated")
  cb_url <- glue::glue("https://dirk.eddelbuettel.com/cranberries/cran/{feed_type}/index.rss")
  ftype <- feed_type

  # process the new packages feed
  cb_tidy <- tidyRSS::tidyfeed(cb_url) %>%
    mutate(feed_type = ftype) %>%
    mutate(item_pub_date = as_date(item_pub_date)) %>%
    select(item_title, item_link, item_description, item_pub_date, feed_type) %>%
    distinct() %>%
    mutate(package_name = purrr::map_chr(item_link, ~tidy_package_name(.x))) %>%

    # leverage the awesome pkgsearch package to get metadata
    mutate(package_meta = purrr::map(package_name, ~search_cran_package_insistently(.x)),
           package_version = purrr::map_chr(package_meta, "Version"),
           package_title = purrr::map_chr(package_meta, "Title"),
           package_date = purrr::map_chr(package_meta, "Date/Publication")) %>%

    filter(item_pub_date >= as.Date(start_date) & item_pub_date <= as.Date(now())) %>%
    select(one_of(c("package_version", "package_name", "package_title", "feed_type",  "package_date"))) %>%
    mutate(markdown_string = purrr::pmap_chr(select(., -package_date), create_text, add_update_titles = TRUE))

  return(cb_tidy)
}


# obtain updated packages
cb_updated_df <- process_cranberries(feed_type = "updated", start_date = as.Date(Sys.Date() - 6))

cat("\n# CRANberries UPDATED: ##\n", file = OUTPUT_FILE, sep = "\n", append = TRUE)

# print out the markdown text
cat(cb_updated_df$markdown_string, file = OUTPUT_FILE, sep = "\n", append = TRUE)

# obtain new packages
cb_new_df <- process_cranberries(feed_type = "new", start_date = as.Date(Sys.Date() - 6))

cat("\n\n# CRANberries NEW: ##\n\n", file = OUTPUT_FILE, sep = "\n", append = TRUE)

# print out the markdown text
cat(cb_new_df$markdown_string, file = OUTPUT_FILE, sep = "\n", append = TRUE)

cat("\n\n", file = OUTPUT_FILE, append = TRUE)

## De-duplicate

collected <- readLines(file(OUTPUT_FILE))

cat(unique(collected), file = OUTPUT_FILE, sep = "\n") # overwrite with de-dup


