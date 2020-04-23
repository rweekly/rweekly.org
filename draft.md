---
layout: draft
title: R Weekly 2020-17
description: Draft of the R Weekly
image: https://rweekly.org/public/facebook.png
---

Release Date: 2020-04-27

###  Highlight



### Insights

+ [Automatic Code Cleaning in R with Rclean](https://ropensci.org/blog/2020/04/21/rclean/)

### R in the Real World

+ [Papers Please! 'Wide Open Spaces A statistical technique for measuring space creation in professional soccer' pt 1](https://www.robert-hickman.eu/post/fall_back_in_to_space/)

+ [Use R & GitHub as a Workout planner](https://colinfay.me/r-git-workout-planner/)

+ [Calculating lake outlets using R](https://fishandwhistle.net/post/2020/calculating-lake-outlets-using-r/)

### COVID19

+ [COVID-19: Analyze Mobility Trends with R](https://blog.ephorie.de/covid-19-analyze-mobility-trends-with-r)

###  R in Organizations

+ [Announcing tidymodels.org](https://www.tidyverse.org/blog/2020/04/tidymodels-org/)

+ [The Case for tidymodels](https://rviews.rstudio.com/2020/04/21/the-case-for-tidymodels/)

+ [Miscellaneous Wisdom about R Markdown & Hugo Gained from Work on our Website](https://ropensci.org/technotes/2020/04/23/rmd-learnings/)


###  R in Academia

+ [Applied Longitudinal Data Analysis in brms and the tidyverse](https://bookdown.org/content/4253/)

+ [What Panel Data Is Really All About](http://www.robertkubinec.com/post/fixed_effects/)

###  Resources



###  New Packages

<p class="added-hostname"><a href="https://rweekly.org/live" target="_blank" class="externalLink">📦 <i>Go Live for More New Pkgs</i> 📦</a></p>

**CRAN**



**BioC**



**GitHub or Bitbucket**

+ [{dplyr-cli}: Manipulate CSV files on the command line using dplyr](https://github.com/coolbutuseless/dplyr-cli)

+ [{minidrawio}: Create simple draw.io documents from R](https://github.com/coolbutuseless/minidrawio)

### Updated Packages

+ [{poorman} 0.1.11 (CRAN): A simple replication of key 'dplyr' verbs using only base R](https://cran.r-project.org/web/packages/poorman/index.html)

+ [{gratia} 0.3.2 (Github): ggplot-based graphics and useful functions for GAMs fitted using the mgcv package](https://github.com/gavinsimpson/gratia)

+ [{dm} 0.1.1.9006 (Github): Tools for working with multiple related tables, stored as data frames or in a relational database](https://github.com/krlmlr/dm)

###  Videos and Podcasts

+ [TidyX Episode 6: Exploring BBC Critic rankings Rap Music + Analyzing 2019 NWSL data with {nwslR}](https://www.youtube.com/watch?v=XKjhws2ryFw)

+ [Easy ggplot2 Theme Customization with {ggeasy}](https://www.youtube.com/watch?time_continue=1&v=iAH1GJoBZmI&feature=emb_logo)

+ [Tidy Tuesday live screencast: Analyzing GDPR violations in R](https://www.youtube.com/watch?v=EVvnnWKO_4w)

+ [Advanced R Book Club: Chapter 3: Vectors (2020-04-16)](https://www.youtube.com/watch?v=pQ-xDAPEQaw)

### Gist & Cookbook

+ [GDPR Violations - Tidy Tuesday - 2020, Week 17 - Antoine Bichat](https://github.com/abichat/tidytuesday/blob/master/scripts/script_2020-04-21.R)

+ [GDPR Violations - Tidy Tuesday - 2020, Week 17 - Georgios Karamanis](https://github.com/gkaramanis/tidytuesday/tree/master/2020-week17)

+ [GDPR Violations - Tidy Tuesday - 2020, Week 17 - John Mutiso](https://github.com/johnmutiso/-TidyTuesday/blob/master/2020/week%2017/script.R)

+ [The City of Lights](https://github.com/khufkens/city_of_lights)

### R Internationally



###  Tutorials

+ [Pathtracing Neon Landscapes in R](https://www.tylermw.com/pathtracing-neon-landscapes-in-r/)

+ [How to Run Python's Scikit-Learn in R in 5 minutes](https://www.business-science.io/learn-r/2020/04/20/setup-python-in-r-with-rmarkdown.html)

+ [No excuse not to be a Bayesian anymore](https://www.brodrigues.co/blog/2020-04-20-no_excuse/)

+ [How to check if groceries are in stock and automatically buy them with R](http://theautomatic.net/2020/04/21/make-your-amazon-purchases-with-r/)

<!--<div class="post-more-begin></div><div class="post-more-end"></div>-->

###  R Project Updates

Updates from [R Core](http://developer.r-project.org/blosxom.cgi/R-devel/NEWS):


###  Upcoming Events in 3 Months

Events in 3 Months:

+ [May 23rd, 85th (Virtual/Online) TokyoR Meetup](https://tokyor.connpass.com/)

+ [A list of R conferences and meetings](https://jumpingrivers.github.io/meetingsR/events.html)

+ [This week's local R-User and applied stats events](https://community.rstudio.com/c/irl)


More past events at [R conferences & meetups](https://conf.rweekly.org).


### Datasets

+ [Financial datasets provided by Marcelo S. Perlin](https://www.msperlin.com/blog/data/data/)

### Jobs




###  Call for Participation


<p class="hide-support added-hostname support-rweekly" style="text-align: center;font-weight: bold;">Your <a class="non-visited externalLink" href="https://www.patreon.com/rweekly" onclick="pas(this)">support</a> will keep R Weekly team moving! 💡</p>

###  Quotes of the Week

<blockquote class="twitter-tweet"><p lang="en" dir="ltr">I’ve got 99 problems and other people’s choices about data formatting are most of them</p>&mdash; Garrick (@grrrck) <a href="https://twitter.com/grrrck/status/1252704601024999437?ref_src=twsrc%5Etfw">April 21, 2020</a></blockquote> <script async src="https://platform.twitter.com/widgets.js" charset="utf-8"></script>

<blockquote class="twitter-tweet"><p lang="en" dir="ltr">Tidy R makes learning HARDER for non-coders. Consider an example.<br><br>mtcars %&gt;% <br> group_by(cyl) %&gt;% <br> summarise(mpg.mean = mean(mpg))<br><br>but in awk it&#39;s<br><br>awk -F, &#39;NR&gt;1{mpg[$3]+=$2;len[$3]++}BEGIN{print &quot;cyl\tmpg.mean&quot;}END{for (i in mpg) print i, mpg[i]/len[i]}&#39; OFS=&#39;\t&#39; mtcars.txt</p>&mdash; Jonathan Carroll (@carroll_jono) <a href="https://twitter.com/carroll_jono/status/1159266829098815489?ref_src=twsrc%5Etfw">August 8, 2019</a></blockquote> <script async src="https://platform.twitter.com/widgets.js" charset="utf-8"></script>

<blockquote class="twitter-tweet"><p lang="en" dir="ltr">Need something to read while in quarantine? <br><br>A lot of tutorials, articles, and function references are now at <a href="https://t.co/ybDlBsD9IA">https://t.co/ybDlBsD9IA</a>.<a href="https://t.co/YyzmRIH4hX">https://t.co/YyzmRIH4hX</a><a href="https://twitter.com/apreshill?ref_src=twsrc%5Etfw">@apreshill</a> is the MVP; we could not have done it without her. <a href="https://twitter.com/hashtag/rstats?src=hash&amp;ref_src=twsrc%5Etfw">#rstats</a></p>&mdash; Max Kuhn (@topepos) <a href="https://twitter.com/topepos/status/1252552821108588544?ref_src=twsrc%5Etfw">April 21, 2020</a></blockquote> <script async src="https://platform.twitter.com/widgets.js" charset="utf-8"></script>


