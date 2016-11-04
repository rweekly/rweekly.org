---
layout: draft
title: Issue 23
---

Release Date: 2016-10-31

Hello and welcome to the new issue of **R Weekly**!

## Highlight

*Digested by R Weekly Members*


## News & Blog Posts

#### Tutorials



#### R in Real World
[R from the future](http://lionel-.github.io/2016/02/15/ideas-for-an-updated-r-syntax/) - RStudio's Lionel Henry gives his ideas for the future of R syntax

```r
test_that("new syntax works") {

   data <- list(mtcars, 1, 2, list(3, mtcars, 4))
   expected <- lapply(data, function(x) is.list(x) || is.double(x))

   mtcars |>
     [1, 2, [3, _, 4]] |>
     map([x] -> is.list(x) || is.double(x)) |>
     check_equal(expected)

 }
```


#### R in Organization



#### R in Academia



## Video and Podcast




## Resources





## New Releases




## New Packages & Tools



## R Project Updates

Updates from [R Core](http://developer.r-project.org/blosxom.cgi/R-devel/NEWS).



## Upcoming Events

+ [rstudio::conf 2017](https://www.rstudio.com/conference/)  **January 13 and 14, 2017** <br>
The conference about all things R and RStudio.<br /> 


## Quote of the Week


