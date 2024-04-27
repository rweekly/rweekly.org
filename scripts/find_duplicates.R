library("magrittr")

acceptable_dups <- function() {
  c(
    "http://developer.r-project.org/blosxom.cgi/R-devel/NEWS",
    "https://github.com/rweekly/rweekly.org#how-to-have-my-content-shared-by-r-weekly",
    "https://r-universe.dev/search/",
    "https://rweekly.fireside.fm/",
    "https://serve.podhome.fm/r-weekly-highlights"
  )
}


get_links <- function(path){
  path %>%
    readLines(warn = FALSE) %>%
    .[1:which(grepl("Upcoming Events", .))] %>%
    commonmark::markdown_xml() %>%
    xml2::read_xml() %>%
    xml2::xml_ns_strip() %>%
    xml2::xml_find_all(xpath = './/link') %>%
    xml2::xml_attr("destination")
}

get_dups <- function(rweekly_path = getwd()){
  old_posts <- fs::dir_ls(file.path(
    rweekly_path,"_posts"))
  
  old_posts <- old_posts[(length(old_posts) - 20):length(old_posts)]
  
  
  old_links <- unlist(purrr::map(old_posts, get_links))
  
  thisweek <- get_links(file.path(rweekly_path,
                                  "draft.md"))
  current_dups <- thisweek[duplicated(thisweek)]
  if (length(current_dups)) {
    message("Duplicates found in current week:")
    cat(paste0(current_dups, collapse = "\n"))
    cat("\n")
  }
  
  dups <- thisweek[thisweek %in% old_links]
  dups <- setdiff(dups, acceptable_dups())

  if (length(dups) == 0) {
    message("No duplicate links, well done! :-)")
  } else {
    return(dups)
  }
  
}
