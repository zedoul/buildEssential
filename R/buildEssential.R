configure <- function(miniCRAN_path,
                      library_path) {

  # Create miniCRAN folder
  if (!dir.exists(miniCRAN_path)) {
    dir.create(miniCRAN_path)
  }

  # Create library folder
  if (!dir.exists(library_path)) {
    dir.create(library_path)
  }

  # Set CRAN path and library path
  options(repos = c(CRAN = miniCRAN_path))
  .libPaths(library_path)
}
