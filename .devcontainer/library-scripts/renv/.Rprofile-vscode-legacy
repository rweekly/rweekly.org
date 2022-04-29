# setup if using with vscode and R plugin
if (Sys.getenv("TERM_PROGRAM") == "vscode") {
    source(file.path(Sys.getenv(if (.Platform$OS.type == "windows") "USERPROFILE" else "HOME"), ".vscode-R", "init.R"))
}
source("renv/activate.R")

if (Sys.getenv("TERM_PROGRAM") == "vscode") {
    # obtain list of packages in renv library currently
    project <- renv:::renv_project_resolve(NULL)
    lib_packages <- names(unclass(renv:::renv_diagnostics_packages_library(project))$Packages)

    # detect whether key packages are already installed
    # was: !require("languageserver")
    if (!"languageserver" %in% lib_packages) {
        message("installing languageserver package")
        renv::install("languageserver")
    }
    
    if (!"httpgd" %in% lib_packages) {
        message("installing httpgd package")
        renv::install("httpgd")
    }

    if (!"vscDebugger" %in% lib_packages) {
        message("installation vscDebugger package")
        renv::install("ManuelHentschel/vscDebugger@v0.4.7")
    }

    # use the rstudio addins feature
    if (!"rstudioapi" %in% lib_packages) {
        message("installing rstudioapi package")
        renv::install("rstudioapi")
    }
    options(vsc.rstudioapi = TRUE)

    # use the new httpgd plotting device
    options(vsc.plot = FALSE)
    options(device = function(...) {
      httpgd:::hgd()
      .vsc.browser(httpgd::hgd_url(), viewer = "Beside")
    })
}

# uncomment this section if using a pulseaudio server from a linux host
# play_sound <- function(sound_dir = "/soundboard_files", custom_sink = "SoundBoard", obs_animate = TRUE, wait = FALSE) {
#   audio_file <- sample(list.files(sound_dir, full.names = TRUE), size = 1)
#   play_args <- c(audio_file)

#   if (!is.null(custom_sink)) {
#     play_args <- c(play_args, "-d", custom_sink)
#   }

#   system2("paplay", args = play_args, wait = wait)

#   if (obs_animate) {
#     system2("curl", paste0("http://192.168.1.178:1030/image?filename=/", audio_file), stdout = FALSE, stderr = FALSE)
#   }

#   invisible(TRUE)
# }

# options(error = play_sound)