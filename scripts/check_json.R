library(curl)
library(jsonlite)
library(stringr)
check_one_file  = function(one_file){
  todo_json = fromJSON(readLines((one_file)))
  timeout = 30
  total_con = 30
  host_con = 6
  
  pool = curl::new_pool()
  
  curl::multi_set(total_con = total_con, host_con = host_con, multiplex = TRUE, pool = pool)
  
  add_async_url = function(urli){
    force(urli)
    # message(paste0("Getting ", urli))
    
    if(grepl("blogspot\\.sg", urli)){
      urli = str_replace(urli,"blogspot\\.sg","blogspot.com")
    }
    
    h <- curl::new_handle(url = urli)
    curl::handle_setopt(h, .list = list(nobody = TRUE, ssl_verifypeer = FALSE))
    curl::handle_setheaders(h,
                      "Accept" = "text/html,application/xhtml+xml,application/xml;q=0.9,*/*;q=0.8",
                      "Accept-Encoding" = "gzip, deflate, br",
                      "Content-Type" = "text/moo",
                      "Cache-Control" = "no-cache",
                      "User-Agent" = "Mozilla/5.0 (Macintosh; Intel Mac OS X 10.12; rv:49.0) Gecko/20100101 Firefox/49.0"
    )
    curl::multi_add(h, done = function(res){
      if(grepl("blogspot\\.sg", res$url)){
        res$url = str_replace(res$url,"blogspot\\.sg","blogspot.com")
      }
      url_num = (todo_json$href == urli)
      #message(paste0("Done ", res$url, " Status: ", res$status))
      if (res$status != "200"){
        msg = paste0(urli , ": ", as.character(res$status))
        message(msg)
        todo_json$href[url_num] <<- paste0("https://web.archive.org/web/", res$url)
      } else {
        todo_json$href[url_num] <<- res$url
      }
    }, fail = function(res){
      msg = paste0(urli , ": ", as.character(res))
      message(msg)
      url_num = (todo_json$href == urli)
      todo_json$href[url_num] <<- paste0("https://web.archive.org/web/", urli)
    }, pool = pool)
  }
  
  for (url in 1:nrow(todo_json)) {
    todo_url = todo_json$href[url]
    if (grepl("(revolutionanalytics)|(feedproxy\\.google\\.com)|(\\:\\/\\/web\\.archive\\.org\\/web)",todo_url)){
      todo_json$href[url] = todo_url
    } else{
      add_async_url(todo_json$href[url])
    }
  }
  
  curl::multi_run(timeout = timeout,pool = pool)
  return(todo_json)
}

all_json = list.files("./json")

for (ii in all_json[1:length(all_json)]){
  print(which(all_json==ii))
  writeLines(toJSON(check_one_file(file.path("json",ii)),pretty = T),file.path("temp_json",ii))
}

