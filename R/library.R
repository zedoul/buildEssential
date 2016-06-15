installPackages <- function(package_name, miniCRAN_path, library_path) {
  stopifnot(dir.exists(library_path))

  install.packages(package_name,
                   repos = paste0("file:///", miniCRAN_path),
                   lib = library_path,
                   type = "source")
}
