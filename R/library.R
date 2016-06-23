#' Initialize library path
#'
#' @param package_name A package name to install
init_library <- function(library_path) {
  if (!dir.exists(library_path)) {
    dir.create(library_path, recursive = T)
  }
}

#' Install miniCRAN package
#'
#' @param package_name A package name to install
install_package <- function(package_name) {
  stopifnot(!missing(package_name))
  stopifnot(dir.exists(getOption("repos")))

  # Some of packages are only in Remotes, not in miniCRAN
  tryCatch({
    install.packages(package_name,
                     repos = paste0("file:///", getOption("repos")))
  }, error = function(e) {
    message(e)
  })
}

#' Install source packages
#'
#' @param dir_path A search path of the directory which source packages are
#' stored
#' @param pattern A regex pattern for source packages. \code{*.tar.gz} by
#' default
install_src_packages <- function(dir_path = NULL,
                                 pattern = "*.tar.gz") {

  stopifnot(dir.exists(dir_path))

  source_packages <- list.files(dir_path, pattern = pattern)

  # TODO(kim.seonghyun): Currently, miniCRAN do not support proper source
  # package support, so therefore we need to use devtools instead.
  # In order to make sure everything works well with miniCRAN, we need to put
  # related dependencies in DESCRIPTION of source packages to our own packages
  for (source_package in source_packages) {
    devtools::install_local(file.path(dir_path, source_packages),
                            dependencies = F,
                            repos = paste0("file:///", getOption("repos")))
  }
}
