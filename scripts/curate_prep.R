# Prepares the /curate digest from curatinator_latest.md. Run from the repo root:
#   Rscript scripts/curate_prep.R
# Writes /tmp/curate_digest.md with: a staleness check, the RSS posts not yet in
# draft.md or the last 20 issues (each with a text excerpt of the page), and the
# top CRAN packages by last-week downloads, as ready-to-paste lines.

OUT <- "/tmp/curate_digest.md"
N_NEW <- 40
N_UPDATED <- 25
EXCERPT_CHARS <- 1500
options(timeout = 20)

source("scripts/find_duplicates.R") # get_links()

lines <- readLines("curatinator_latest.md", warn = FALSE)
# descriptions wrapped onto a continuation line: join them back
wrapped <- !grepl("^(\\+ |#|$)", lines)
for (i in rev(which(wrapped))) lines[i - 1] <- paste(lines[i - 1], lines[i])
lines <- lines[!wrapped]

headers <- grep("^# ", lines)
section_lines <- function(pattern) {
  h <- grep(pattern, lines[headers])
  if (!length(h)) return(character())
  end <- if (h < length(headers)) headers[h + 1] else length(lines)
  grep("^\\+ ", lines[headers[h]:end], value = TRUE)
}
link_url <- function(x) sub("^\\+ \\[.*?\\]\\((.*?)\\).*", "\\1", x, perl = TRUE)

rss <- section_lines("^# RSS POSTS")
new <- section_lines("^# CRANberries NEW")
updated <- section_lines("^# CRANberries UPDATED")

posts <- tail(fs::dir_ls("_posts"), 20)
known <- c(get_links("draft.md"), unlist(lapply(posts, get_links)))
latest <- get_links(tail(posts, 1))
shared <- sum(latest %in% link_url(c(rss, new, updated)))
failed <- grep("FAILED", lines[headers], value = TRUE)

excerpt <- function(url) {
  message("Fetching: ", url)
  doc <- try(xml2::read_html(url), silent = TRUE)
  if (inherits(doc, "try-error")) return("(fetch failed: inspect the page by hand)")
  xml2::xml_remove(xml2::xml_find_all(doc, "//script|//style|//nav|//header|//footer"))
  txt <- xml2::xml_text(xml2::xml_find_all(doc, "//p|//h1|//h2|//h3|//pre|//li"))
  substr(gsub("\\s+", " ", paste(txt, collapse = " ")), 1, EXCERPT_CHARS)
}

rank_pkgs <- function(x, n) {
  x <- x[!link_url(x) %in% known]
  if (!length(x)) return(x)
  pkg <- sub("^\\+ \\[\\{([^}]+)\\}.*", "\\1", x, perl = TRUE)
  dl <- do.call(rbind, lapply(split(pkg, ceiling(seq_along(pkg) / 100)), function(chunk) {
    jsonlite::fromJSON(paste0(
      "https://cranlogs.r-pkg.org/downloads/total/last-week/",
      paste(chunk, collapse = ",")
    ))
  }))
  head(x[order(-dl$downloads[match(pkg, dl$package)])], n)
}

rss_new <- rss[!link_url(rss) %in% known]
rss_skipped <- setdiff(rss, rss_new)
top_new <- rank_pkgs(new, N_NEW)
top_updated <- rank_pkgs(updated, N_UPDATED)

writeLines(c(
  paste0("# Curate digest (", Sys.Date(), ")"),
  "",
  sprintf(
    "Staleness: %d of %d links of %s are in curatinator_latest.md -> %s",
    shared, length(latest), basename(tail(posts, 1)),
    if (shared > 0.3 * length(latest)) "STALE, re-run scripts/curatinator.R" else "fresh"
  ),
  if (length(failed)) paste0("WARNING: ", failed, " -> re-run scripts/curatinator.R"),
  "",
  sprintf("## RSS posts to classify (%d)", length(rss_new)),
  "",
  unlist(lapply(rss_new, function(l) c(l, "", paste0("> ", excerpt(link_url(l))), ""))),
  sprintf("## RSS posts skipped, already in draft.md or the last 20 issues (%d)", length(rss_skipped)),
  "",
  rss_skipped,
  "",
  sprintf("## New Packages: top %d of %d by last-week downloads", length(top_new), length(new)),
  "",
  top_new,
  "",
  sprintf("## Updated Packages: top %d of %d by last-week downloads", length(top_updated), length(updated)),
  "",
  top_updated
), OUT)
cat("Digest written to", OUT, "\n")
