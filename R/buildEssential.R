#' Setup buildEssential
#'
#' BuildEssential sets two environmental variables. One is a miniCRAN path by
#' \code{options(repos)}, and another is a library path by \code{.libPaths}.
#' You'll need to put parameters in order to do this. If those paths are not
#' exist, then this function will create them.
#'
#' @param miniCRAN_path A path of miniCRAN
#' @param lib_path A search path of the library tree which packages are stored
configure <- function(miniCRAN_path,
                      lib_path) {
  stopifnot(!missing(miniCRAN_path))
  stopifnot(!missing(lib_path))
  stopifnot(dir.exists(miniCRAN_path))
  stopifnot(dir.exists(lib_path))

  options(repos = c(CRAN = miniCRAN_path))
  .libPaths(lib_path)
}

#' Get build setting
#'
#' @param setting_path A path of setting file
get_setting <- function(setting_path) {
  stopifnot(file.exists(setting_path))

  setting <- yaml.load_file(setting_path)

  getLibPath <- function(library_paths) {
    ret <- sapply(library_paths,
                  FUN = function(x) {
                    paste0(x, "/", version$major, ".", version$minor)
                  })
    colnames(ret) <- "libraryPath"
    rownames(ret) <- names(library_paths[[1]])
    return(ret)
  }

  setting[["library_paths"]] <- getLibPath(setting[["library_paths"]])

  return (setting)
}

#' Get required package names
#'
#' @param description_paths A vector of DESCRIPTION paths
get_packages <- function(description_path) {
  descriptions <- yaml.load_file(description_path)
  descriptions <- descriptions[["descriptions"]]

  pkgs <- c()
  for (description in descriptions) {
    stopifnot(any(file.exists(description), dir.exists(description)))

    # TODO(kim.seonghyun): Consider miniCRAN::getCranDescription function
    deps <- desc::desc_get_deps(description)
    target_deps <- deps[, "type"] %in% c("Imports", "Suggests", "LinkingTo")
    pkgs <- c(pkgs, deps[target_deps, "package"])
  }

  return (unique(pkgs))
}
