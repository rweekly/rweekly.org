# Create Nix development configuration file using the rix package.
# note: use the root of your local clone of the repository as the working directory
library(rix)
rix(
  r_ver = "4.5.1",
  r_pkgs = c(
    "curl", 
    "jsonlite",
    "stringr",
    "tidyRSS",
    "pkgsearch",
    "lubridate",
    "magrittr",
    "commonmark",
    "xml2",
    "tibble",
    "purrr",
    "rstudioapi",
    "dplyr", 
    "ggplot2", 
    "bslib", 
    "shiny", 
    "officer", 
    "chromote", 
    "tidyr",
    "glue"
  ),
  system_pkgs = c("quarto", "chromium", "curl", "imagemagick"),
  git_pkgs = list(
    list(
      package_name = "rweekly.tools",
      repo_url = "https://github.com/rweekly/rweekly.tools/",
      branch_name = "master",
      commit = "7a1c7c7802b841ad086083211e48b922b4bfefb3"
    ),
    list(
      package_name = "rweekly.highlights",
      repo_url = "https://github.com/rweekly/rweekly.highlights",
      branch_name = "master",
      commit = "52fac2c934e9597515de0b3f7f6bf139f4af931a"
    )
  ),
  ide = "none",
  project_path = ".",
  overwrite = TRUE
)
