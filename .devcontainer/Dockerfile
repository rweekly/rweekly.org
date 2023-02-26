FROM ghcr.io/rocker-org/devcontainer/tidyverse:4.2

# key dependencies for utilities
RUN apt-get update -qq \
  && export DEBIAN_FRONTEND=noninteractive \
  && apt-get -y install --no-install-recommends libxt6 curl python3-pip libsodium-dev imagemagick libmagick++-dev

# install additional R packages
RUN install2.r --error --skipinstalled --ncpus -4 tidyRSS pkgsearch lubridate dplyr rtweet readr longurl tidyr twitterwidget urltools
RUN installGithub.r rweekly/rweekly.tools rweekly/rweekly.highlights

# [Optional] Set the default user. Omit if you want to keep the default as root.
USER rstudio