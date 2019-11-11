library(stringr)
library(versions)
library(rstudioapi)

split_text_into_items <- function(text) {
  stringr::str_split(as.character(text), "\\n")  
}

find_cran_links <- function(items) {
  grep("cran.r-project.org/package=", unlist(items), fixed = TRUE, value = TRUE)
}
    
extract_package_names <- function(item) {
  x <- stringr::str_extract(item, "(?<=cran.r-project.org/package=)[^)]*")
  setNames(item, x)
}

append_versions <- function(items, versions) {
  package_names <- names(versions)
  latest_version <- sapply(versions, function(x) x$version[[1]])
  package_text <- items[package_names]
  package_text <- stringr::str_replace_all(package_text, "\\s\\s+", " ")
  new_package_text <- stringr::str_replace(package_text, "\\+ \\[(\\w+)", paste0("+ [{\\1} ", latest_version, ":"))
  sort(new_package_text)
}

## this function is designed to work on 'clean' Rmd 
## links and will extract the canonical CRAN links.
## simply highlight your items in the Rmd and use `process_versions()` in 
## the console. This will return a set of updated items for new and updated 
## CRAN packages
process_versions <- function(text = rstudioapi::getSourceEditorContext()$selection[[1]]$text) {
  
  if (!requireNamespace("versions")) {
    stop("Please install the {versions} package")
  }
 
  items <- split_text_into_items(text)
  cran_items <- find_cran_links(items)
  cran_packages <- extract_package_name(cran_items)
  message("Identifying versions... this make take a while...")
  versions <- versions::available.versions(names(cran_packages))
  is.new <- lapply(versions, nrow) == 1L
  new <- versions[is.new]
  updated <- versions[!is.new]
  
  message("DONE!")
  message("")
  message("New packages:")
  print(append_versions(cran_packages, new))
  message(" ")
  message("Updated packages:")
  print(append_versions(cran_packages, updated))
  
}
