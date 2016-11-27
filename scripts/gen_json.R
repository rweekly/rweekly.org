library(stringr)
library(jsonlite)
library(tibble)
parse_one_file = function(post_file){
  post_content = readLines(post_file)
  end_of_post = which(grepl("## R Project Updates",post_content))[1]
  if (!is.na(end_of_post)){
    post_content = post_content[1:end_of_post]
  }

  link_ids  = grep("[-+\\*] *(?:\\[((?:[^]]*))\\] *(?:\\(([^)]*)\\)))", post_content)
  max_line = length(post_content)
  i = 1
  NA_TEMP = rep(NA_character_, length(link_ids))
  res = tibble(title = NA_TEMP , href = NA_TEMP ,
         des = NA_TEMP, img = NA_TEMP )

  for (i in 1:length(link_ids)){
    extract_content = str_match(post_content[link_ids[i]], "[-+\\*] *(?:\\[((?:[^]]*))\\] *(?:\\(([^)]*)\\)))(.*)")
    img_link = NA
    j = link_ids[i]
    while( (i < length(link_ids) && j < link_ids[i+1]) || (i == length(link_ids) && j <= max_line)  ){
      if (grepl("! *(?:\\[((?:[^]]*))\\] *(?:\\(([^)]*)\\)))", post_content[j])){
        img_content = str_match(post_content[j], "! *(?:\\[((?:[^]]*))\\] *(?:\\(([^)]*)\\)))(.*)")
        img_link = img_content[3]
        break
      }
      j = j+1
    }
    res[[i,1]] = extract_content[[1,2]]
    res[[i,2]] = extract_content[[1,3]]
    res[[i,3]] = extract_content[[1,4]]
    res[[i,4]] = img_link

  }
  res
}

posts_files = list.files("./_posts")
posts_files = posts_files[posts_files != "2016-5-21-issue-0.md"]
for (ii in 1:length(posts_files)){
  writeLines(toJSON(parse_one_file(file.path("./_posts",posts_files[ii]))), file.path("temp_json", paste0(ii+396, ".js")))
}


