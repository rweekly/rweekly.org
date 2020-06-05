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

create_text <- function(package_version, package_name, package_title, feed_type = "new") {
    if (feed_type == "new") {
        placeholder <- "+ [{|package_name|} |package_version|](https://cran.r-project.org/package=|package_name|): |package_title|"
    } else if (feed_type == "updated") {
        placeholder <- "+ [{|package_name|} |package_version|](https://cran.r-project.org/package=|package_name|)"
    } else {
        stop("supplied type not recognized!", call. = FALSE)
    }

    x <- glue::glue(placeholder, .open = "|", .close = "|")
    return(x)
}

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
      mutate(package_meta = purrr::map(package_name, ~pkgsearch::cran_package(.x)),
             package_version = purrr::map_chr(package_meta, "Version"),
             package_title = purrr::map_chr(package_meta, "Title"),
             package_date = purrr::map_chr(package_meta, "Date/Publication")) %>%

      filter(item_pub_date >= as.Date(start_date) & item_pub_date <= as.Date(now())) %>%
      select(one_of(c("package_version", "package_name", "package_title", "feed_type",  "package_date"))) %>%
      mutate(markdown_string = purrr::pmap_chr(select(., -package_date), create_text))

    return(cb_tidy)
}

# obtain new packages
cb_new_df <- process_cranberries(feed_type = "new", start_date = "2020-05-25")

# print out the markdown text
cat(cb_new_df$markdown_string, sep = "\n")

# obtain updated packages
cb_updated_df <- process_cranberries(feed_type = "updated", start_date = "2020-05-25")

# print out the markdown text
cat(cb_updated_df$markdown_string, sep = "\n")

# Previous version by Jonathan Carroll

cb_new <- c(
"New package newscatcheR with initial version 0.0.1
Package: newscatcheR
Title: Programmatically Collect Normalized News from (Almost) Any Website
Version: 0.0.1",
"New package genius with initial version 2.2.2
Package: genius
Title: Easily Access Song Lyrics from Genius.com
Version: 2.2.2",
"New package almanac with initial version 0.1.0
Package: almanac
Title: Tools for Working with Recurrence Rules
Version: 0.1.0",
"New package tidylo with initial version 0.1.0
Type: Package
Package: tidylo
Title: Weighted Tidy Log Odds Ratio
Version: 0.1.0",
"New package nombre with initial version 0.1.0
Package: nombre
Title: Number Names
Version: 0.1.0",
"New package nhlapi with initial version 0.1.2
Package: nhlapi
Type: Package
Title: A Minimum-Dependency 'R' Interface to the 'NHL' API
Version: 0.1.2",
"New package applicable with initial version 0.0.1
Package: applicable
Title: A Compilation of Applicability Domain Methods
Version: 0.0.1",
"New package upsetjs with initial version 1.0.2
Package: upsetjs
Type: Package
Title: 'HTMLWidget' Wrapper of 'UpSet.s' for Exploring Large Set Intersections
Description: 'UpSet.js' is a re-implementation of 'UpSetR' to create interactive set visualizations for more than three sets. This is a 'htmlwidget' wrapper around the 'JavaScript' library 'UpSet.js'.
Version: 1.0.2",
"New package sketcher with initial version 0.1.3
Package: sketcher
Title: Pencil Sketch Effect
Version: 0.1.3",
"New package BOJ with initial version 0.2.2
Package: BOJ
Title: Interface to Bank of Japan Statistics
Version: 0.2.2",
"New package ROpenCVLite with initial version 0.4.430
Package: ROpenCVLite
Type: Package
Title: Install 'OpenCV'
Version: 0.4.430"
)

process_new_cranberries <- function(t) {
  text <- stringr::str_split_fixed(t, "\n", Inf)
  version <- stringr::str_remove(text[1, which(grepl("^Version", text))], "Version: ")
  name <- stringr::str_remove(text[1, which(grepl("^Package", text))], "Package: ")
  desc <- stringr::str_remove(text[1, which(grepl("^Title", text))], "Title: ")
  glue::glue("+ [{|name|} |version|](https://cran.r-project.org/package=|name|): |desc|", .open = "|", .close = "|")
}
cat(purrr::map_chr(cb_new, process_new_cranberries), sep = "\n")

cb_updated <- c(
  "Package timetk updated to version 2.0.0 with previous version 1.0.0 dated 2020-04-19",
  "Package rmarkdown updated to version 2.2 with previous version 2.1 dated 2020-01-20",
  "Package ukpolice updated to version 0.2.1 with previous version 0.2.0 dated 2020-05-24",
  "Package gratia updated to version 0.4.1 with previous version 0.3.1 dated 2020-03-29",
  "Package ggstatsplot updated to version 0.5.0 with previous version 0.4.0 dated 2020-04-15",
  "Package jsonify updated to version 1.2.0 with previous version 1.1.1 dated 2020-03-14",
  "Package exiftoolr updated to version 0.1.3 with previous version 0.1.2 dated 2019-06-07",
  "Package drat updated to version 0.1.6 with previous version 0.1.5 dated 2019-03-28",
  "Package chk updated to version 0.5.0 with previous version 0.4.0 dated 2020-03-04",
  "Package tidytable updated to version 0.5.1 with previous version 0.5.0 dated 2020-05-23",
  "Package dplyr updated to version 1.0.0 with previous version 0.8.5 dated 2020-03-07",
  "Package texreg updated to version 1.37.1 with previous version 1.36.23 dated 2017-03-03",
  "Package copula updated to version 1.0-0 with previous version 0.999-20 dated 2020-02-06",
  "Package pkgload updated to version 1.1.0 with previous version 1.0.2 dated 2018-10-29",
  "Package ggplot2 updated to version 3.3.1 with previous version 3.3.0 dated 2020-03-05",
  "Package pins updated to version 0.4.1 with previous version 0.4.0 dated 2020-04-07",
  "Package slider updated to version 0.1.4 with previous version 0.1.3 dated 2020-05-14",
  "Package StanHeaders updated to version 2.21.0-3 with previous version 2.19.2 dated 2020-02-11",
  "Package tidyjson updated to version 0.3.0 with previous version 0.2.4 dated 2019-12-02",
  "Package trelliscopejs updated to version 0.2.5 with previous version 0.2.4 dated 2020-02-10",
  "Package survminer updated to version 0.4.7 with previous version 0.4.6 dated 2019-09-03",
  "Package rgdal updated to version 1.5-8 with previous version 1.4-8 dated 2019-11-27",
  "Package reactable updated to version 0.2.0 with previous version 0.1.0.1 dated 2020-02-29",
  "Package reticulate updated to version 1.16 with previous version 1.15 dated 2020-04-02",
  "Package dbplyr updated to version 1.4.4 with previous version 1.4.3 dated 2020-04-19",
  "Package brms updated to version 2.13.0 with previous version 2.12.0 dated 2020-02-23",
  "Package tibbletime updated to version 0.1.4 with previous version 0.1.3 dated 2019-09-20",
  "Package rbokeh updated to version 0.5.1 with previous version 0.5.0 dated 2016-10-11",
  "Package httpuv updated to version 1.5.3.1 with previous version 1.5.2 dated 2019-09-11",
  "Package modelsummary updated to version 0.3.0 with previous version 0.2.1 dated 2020-04-30",
  "Package tables updated to version 0.9.3 with previous version 0.8.8 dated 2019-05-13",
  "Package geofacet updated to version 0.2.0 with previous version 0.1.10 dated 2019-03-13",
  "Package biglm updated to version 0.9-2 with previous version 0.9-1 dated 2013-05-15"
)

process_updated_cranberries <- function(t) {
  t <- stringr::str_remove(t, "Package ")
  name <- stringr::str_extract(t, "^\\S*")
  t <- stringr::str_remove(t, "^.*updated to version ")
  version <- stringr::str_extract(t, "^\\S*")
  glue::glue("+ [{|name|} |version|](https://cran.r-project.org/package=|name|)", .open = "|", .close = "|")
}
cat(purrr::map_chr(cb_updated, process_updated_cranberries), sep = "\n")
