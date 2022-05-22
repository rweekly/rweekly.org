# remotes::install.github("rweekly/rweekly.tools")
library(rweekly.tools)

# re-size images using rweekly.tools::upload_image()
# store raw images in scripts/img_raw directory
# by default, none of these images will be version-controlled since it is meant to be temporary

# clone https://github.com/rweekly/image locally and define appropriate path below

# example (customize as appropriate)
img_file <- "scripts/img_raw/README-Fig2-2D-spectros-1.png"
issue_img_dir <- "2022/W21"
image_repo <- "/tmp/image"

upload_image(
  file = img_file,
  caption = "",
  width = "600",
  issue = issue_img_dir,
  image_repo = image_repo,
  push = TRUE
)