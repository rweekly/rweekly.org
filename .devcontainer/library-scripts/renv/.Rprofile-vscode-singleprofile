# vscode flag
.in_vscode <- Sys.getenv("CODESPACES") == "true" || Sys.getenv("TERM_PROGRAM") == "vscode"

if (.in_vscode) {
  source(file.path(Sys.getenv(if (.Platform$OS.type == "windows") "USERPROFILE" else "HOME"), ".vscode-R", "init.R"))
  options(vsc.rstudioapi = TRUE)
  # use the new httpgd plotting device
  # options(vsc.plot = FALSE)
  # options(device = function(...) {
  #   httpgd:::hgd()
  #   .vsc.browser(httpgd::hgd_url(), viewer = "Beside")
  # })
}

if (!file.exists("renv/activate.R")) {
  renv::init()
} else {
  source("renv/activate.R")
}

if (.in_vscode) {
  .vscode_pkgs <- c("languageserver", "httpgd", "rstudioapi")

  .project <- renv:::renv_project_resolve(NULL)

  .lib_packages <- names(unclass(renv:::renv_diagnostics_packages_library(.project))$Packages)

  if (!all(.vscode_pkgs %in% .lib_packages)) {
    for (pkg in .vscode_pkgs) {
      if (!pkg %in% .lib_packages) {
        message(paste0("installing package: ", pkg))
        renv::install(pkg)
      }
    }

    file.copy(".devcontainer/library-scripts/renv/dependencies.R", "dependencies.R")

    renv::snapshot(prompt = FALSE)
  }
}
