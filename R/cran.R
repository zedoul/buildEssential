#' Initialize miniCRAN
#'
#' @param miniCRAN_path A path of miniCRAN
#' @param CRAN_path A url of CRAN mirror
#' @param package_types Types of package to be installed
init_miniCRAN <- function(miniCRAN_path,
                          CRAN_url,
                          package_types) {

  if (!dir.exists(miniCRAN_path)) {
    dir.create(miniCRAN_path, recursive = T)
  }

  # Create empty folders for each package types
  # We cannot set pkg as NULL, otherwise we will face a bug when we try to use
  # addPackages function. So we put devtools instead, which is essential.
  package_name <- c("devtools")
  pkgList <- miniCRAN::pkgDep(pkg = package_name,
                              repos = c(CRAN = CRAN_url))

  for (package_type in package_types) {
    miniCRAN::makeRepo(pkgs = pkgList,
                       path = miniCRAN_path,
                       repos = CRAN_url,
                       type = package_type)
  }
}

#' Add CRAN packages into miniCRAN
#'
#' @param package_name A package name to install
#' @param miniCRAN_path A path of miniCRAN
#' @param CRAN_path A url of CRAN mirror
#' @param package_types Types of package to be installed
add_CRAN_pkg <- function(package_name,
                         miniCRAN_path,
                         CRAN_url,
                         package_types) {
  pkgList <- miniCRAN::pkgDep(pkg = package_name,
                              repos = c(CRAN = CRAN_url))

  for (package_type in package_types) {
    miniCRAN::addPackage(pkgs = pkgList,
                         path = miniCRAN_path,
                         repos = CRAN_url,
                         type = package_type)
  }
}

#' Update CRAN packages in miniCRAN
#'
#' @param miniCRAN_path A path of miniCRAN
#' @param CRAN_url A url of CRAN mirror
#' @param package_types Types of package to be installed
update_CRAN_pkgs <- function(miniCRAN_path,
                            CRAN_url,
                            package_type) {
  for (package_type in package_types) {
    miniCRAN::updatePackages(path = miniCRAN_path,
                             repos = CRAN_url,
                             type = package_type,
                             ask = FALSE)
  }
}
