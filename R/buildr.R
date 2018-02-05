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
                  package_types = 'source') {
  stopifnot(file.exists(description_path))
  stopifnot(dir.exists(minicran_path))
  if (!grepl(description_path, "DESCRIPTION")) {
    warning("It seems not a DESCRIPTION file\n")
  }

  packages <- get_packages(description_path)

  cat("description file path:", description_path, "\n")
  cat("miniCRAN path:", miniCRAN_path,"\n")
  cat("CRAN url:", CRAN_url,"\n")
  cat("R library path:", paste("\n-", .libPaths()), "\n")
  cat("package types:", package_types,"\n")
  stopifnot(RCurl::url.exists(CRAN_url))

  # Add miniCRAN packages
  for (package_type in package_types) {
    .package_names <- row.names(miniCRAN::pkgAvail(type = package_type))
    .pkg <- as.data.frame(available.packages(contriburl = contrib.url(CRAN_url),
                                             type = package_type))

    for (package_name in packages) {
      if (all(!(package_name %in% .package_names),
              !is.na(as.character(.pkg[package_name, "Package"])))) {
        tryCatch({
          cat(paste("Add", package_name, " to miniCRAN ...\n"))
          add_CRAN_pkg(package_name,
                       miniCRAN_path,
                       CRAN_url,
                       package_type)
        }, error = function(err) {
          warning(err)
        })
      }
    }
  }

  cat(paste("All done. Installed packages in the R library are as follows:\n"))
  print(installed.packages()[, c("Package", "Version")])
}
