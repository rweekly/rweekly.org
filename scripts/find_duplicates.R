old_posts <- fs::dir_ls("_posts")
old_posts <- old_posts[(length(old_posts) - 20):length(old_posts)]

library("magrittr")

get_links <- function(path){
  path %>%
    readLines() %>%
    commonmark::markdown_xml() %>%
    xml2::read_xml() %>%
    xml2::xml_ns_strip() %>%
    xml2::xml_find_all(xpath = './/link') %>%
    xml2::xml_attr("destination")
}

old_links <- unlist(purrr::map(old_posts, get_links))

thisweek <- get_links("draft.md")
thisweek[thisweek %in% old_links]