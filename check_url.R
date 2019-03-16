install.packages("https://github.com/jeroen/curl/archive/master.tar.gz", repos = NULL)


test.local.urls <- function(path, timeout = 100, total_con = 30, host_con = 6, ...){

  ignore_list = c("blog\\.exploratory\\.io", "www\\.kaggle\\.com", "lionel-\\.github\\.io", "medium\\.swirrl\\.com")
  ignore_pattern = paste0( paste0("(", ignore_list, ")") , collapse = "|" )

  res = vector("list", length(path))

  for( index in seq_along(path) ){

    # normalize a file path
    pathi = normalizePath(path[index])

    if (file.exists(pathi)) {

      # read content
      file_content = readLines(pathi, ...)

      # get urls
      hrefs <- unique(stringr::str_match_all(paste(file_content, collapse = "\n"), '(?:\\[(?:[^]]*)\\] *(?:\\(([^)]*)\\)))')[[1]][,2])
      hrefs = grep(ignore_pattern, hrefs, value = TRUE, invert = TRUE)

      message(paste0("Found ",length(hrefs)," URLs in ", pathi))

      if(length(hrefs) == 0){
        df = data.frame(file = pathi, href = NA, code = NA, stringsAsFactors=FALSE)
        res[[index]] = df
        next
      }

      # init return result
      test.result <- data.frame(file = pathi, href = hrefs, code = NA, stringsAsFactors = FALSE)

      pool = curl::new_pool()
      curl::multi_set(total_con = total_con, host_con = host_con, multiplex = TRUE, pool = pool)

      add_async_url = function(urli){
        force(urli)
        # message(paste0("Getting ", urli))

        h <- curl::new_handle(url = urli)
        curl::handle_setopt(h, .list = list(nobody = TRUE, ssl_verifypeer = FALSE))
        curl::handle_setheaders(h,
                          "Accept" = "text/html,application/xhtml+xml,application/xml;q=0.9,*/*;q=0.8",
                          "Accept-Encoding" = "gzip, deflate, br",
                          "Cache-Control" = "no-cache",
                          "User-Agent" = "Mozilla/5.0 (Macintosh; Intel Mac OS X 10.12; rv:49.0) Gecko/20100101 Firefox/49.0"
        )
        curl::multi_add(h, done = function(res){
          # message(paste0("Done ", res$url, " Status: ", res$status))
          test.result$code[test.result$href == urli] <<- res$status_code
        }, fail = function(err){
          msg = paste0(urli , ": ", as.character(err))
          message(msg)
          test.result$code[test.result$href == urli] <<- paste0("GET_ERROR: ", as.character(err))
        },pool = pool)
      }

      for (url in seq_along(hrefs)) {
        add_async_url(hrefs[url])
      }

      curl::multi_run(timeout = timeout,pool = pool)

      res[[index]] = test.result

    }
    else{

      # file does not exist
      df = data.frame(file = pathi, href = NA, code = NA, stringsAsFactors=FALSE)

      res[[index]] = df

      message(paste0("File ", pathi, " does not exist. "))
    }

  }
  # a big data.frame
  return(do.call("rbind", res))
}

failed = 0

message("checking posts")
posts = test.local.urls(list.files("./_posts/",full.names = T))
failed_post = posts[!(posts$code %in% c("200","405","403")),]

if (nrow(failed_post)>0) {
	failed = failed + nrow(failed_post)
	print(failed_post)
}

message("checking draft")
draft = test.local.urls("./draft.md")
failed_draft = draft[!(draft$code %in% c("200","405","403")),]

if (nrow(failed_draft)>0) {
	failed = failed + nrow(failed_draft)
	print(failed_draft)
}

if (failed > 300) stop(paste0(failed, " links" ))
