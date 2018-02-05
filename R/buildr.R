#' Get packages
#'
#' @param description_path a file path of DESCRIPTION
#' @importFrom desc desc_get_deps
#' @importFrom yaml yaml.load_file
get_packages <- function(description_path) {
  stopifnot(file.exists(description_path))

  # Do not consider miniCRAN::getCranDescription function, since this function
  # should support both CRAN and local packages.
  deps <- desc::desc_get_deps(description_path)
  target_deps <- deps[, "type"] %in% c("Imports", "Suggests", "LinkingTo")
  unique(deps[target_deps, "package"])
}

#' Setup Your Build Essentials
#'
#' @param description_path to DESCRIPTION
#' @importFrom miniCRAN pkgAvail
#' @importFrom RCurl url.exists
#' @export
setup <- function(description_path,
                  minicran_path,
                  cran_url = 'http://cran.us.r-project.org',
                  package_type = 'source') {
  stopifnot(file.exists(description_path))
  stopifnot(dir.exists(minicran_path))
  if (!grepl("DESCRIPTION", description_path)) {
    warning("It seems not a DESCRIPTION file\n")
  }

  packages_to_install <- get_packages(description_path)

  cat("- DESCRIPTION:", description_path, "\n")
  cat("- miniCRAN:", minicran_path,"\n")
  cat("- CRAN:", cran_url,"\n")
  cat("- R library:", paste("\n ", .libPaths()), "\n")
  cat("- package type:", package_type,"\n")
  cat("Start to setup miniCRAN...\n")
  stopifnot(RCurl::url.exists(cran_url))

  # Add miniCRAN packages
  .mpkgs <- row.names(miniCRAN::pkgAvail(repos = minicran_path,
                                         type = package_type))
  .cpkgs <- as.data.frame(available.packages(contriburl = contrib.url(cran_url),
                                             type = package_type))

  for (i in 1:length(packages_to_install)) {
    package_name <- packages_to_install[i]
    cat(paste0("[", i, "/", length(packages_to_install), "]: "),
        "Add", package_name, "to miniCRAN ... ")

    if (all(!(package_name %in% .mpkgs),
            !is.na(as.character(.cpkgs[package_name, "Package"])))) {
      cat("\n")
      tryCatch({
        add_cran_pkg(package_name,
                     minicran_path,
                     cran_url,
                     package_type)
      }, error = function(err) {
        warning(err)
      })
    } else {
      cat("already exists\n")
    }
  }

  cat(paste("All done. Installed packages in the R library are as follows:\n"))
  print(installed.packages()[, c("Package", "Version")])
}
