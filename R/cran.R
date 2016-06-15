# If you want to use this miniCRAN, then just call this function nothing else
initMCran <- function(miniCRAN_path,
                      CRAN_path,
                      package_types) {
  stopifnot(dir.exists(miniCRAN_path))

  # Create empty folders for each package types
  # We cannot set pkgs as NULL, otherwise we will face a bug when we try to use
  # addPackages function. So we put devtools instead.
  package_name <- c("devtools")
  pkgList <- miniCRAN::pkgDep(pkg = package_name,
                              repos = c(CRAN = CRAN_path))

  for (package_type in package_types) {
    miniCRAN::makeRepo(pkgs = pkgList,
                       path = miniCRAN_path,
                       repos = CRAN_path,
                       type = package_type)
  }
}

addCranPkgToMCran <- function(package_name,
                              miniCRAN_path,
                              CRAN_path,
                              package_types) {
  pkgList <- miniCRAN::pkgDep(pkg = package_name,
                              repos = c(CRAN = CRAN_path))

  for (package_type in package_types) {
    miniCRAN::addPackage(pkgs = pkgList,
                         path = miniCRAN_path,
                         repos = CRAN_path,
                         type = package_type)
  }
}

addSrcPkgToMCran <- function(package_path,
                             miniCRAN_path,
                             CRAN_path,
                             package_types) {
  pkgList <- miniCRAN::pkgDep(pkg = package_name,
                              repos = c(CRAN = CRAN_path))

  for (package_type in package_types) {
    # to be implemented
  }
}

updatePkgsInMCran <- function(miniCRAN_path, CRAN_path, package_type) {
  for (package_type in package_types) {
    miniCRAN::updatePackages(path = miniCRAN_path,
                             repos = CRAN_path,
                             type = package_type,
                             ask = FALSE)
  }
}
