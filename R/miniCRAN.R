#' Initialize minicran
#'
#' @param minicran_path A path of minicran
#' @param cran_path A url of cran mirror
#' @param package_types Types of package to be installed
#' @importFrom miniCRAN pkgDep makeRepo
#' @export
init_minicran <- function(minicran_path,
                          cran_url = 'http://cran.us.r-project.org',
                          package_types = 'source') {

  if (!dir.exists(minicran_path)) {
    warning("Directory not exist:", minicran_path,
            "\nit will be created automatically")
    dir.create(minicran_path, recursive = T)
  }
  stopifnot(RCurl::url.exists(cran_url))

  # Create empty folders for each package types
  # We cannot set pkg as NULL, otherwise we will face a bug when we try to use
  # addPackages function. So we put devtools instead, which is essential.
  package_name <- c("devtools")
  pkgList <- miniCRAN::pkgDep(pkg = package_name,
                              repos = c(CRAN = cran_url))
  for (package_type in package_types) {
    miniCRAN::makeRepo(pkgs = pkgList,
                       path = minicran_path,
                       repos = cran_url,
                       type = package_type)
  }

  cat("miniCRAN setup has been successfully completed\n")
}

#' Add cran packages into minicran
#'
#' @param package_name A package name to install
#' @param minicran_path A path of minicran
#' @param cran_path A url of cran mirror
#' @param package_types Types of package to be installed
#' @importFrom miniCRAN pkgDep addPackage
#' @export
add_cran_pkg <- function(package_name,
                         minicran_path,
                         cran_url = 'http://cran.us.r-project.org',
                         package_types = 'source') {
  stopifnot(dir.exists(minicran_path))

  pkgList <- miniCRAN::pkgDep(pkg = package_name,
                              repos = c(CRAN = cran_url))

  for (package_type in package_types) {
    miniCRAN::addPackage(pkgs = pkgList,
                         path = minicran_path,
                         repos = cran_url,
                         type = package_type)
  }
}

#' Update cran packages in minicran
#'
#' @param minicran_path A path of minicran
#' @param cran_url A url of cran mirror
#' @param package_types Types of package to be installed
#' @importFrom miniCRAN updatePackages
#' @export
update_cran_pkg <- function(minicran_path,
                             cran_url = 'http://cran.us.r-project.org',
                             package_types = 'source') {
  stopifnot(dir.exists(minicran_path))

  for (package_type in package_types) {
    miniCRAN::updatePackages(path = minicran_path,
                             repos = cran_url,
                             type = package_type,
                             ask = FALSE)
  }
}

#' Install R package from miniCRAN
#'
#' @param package_name A package name to install
#' @export
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
