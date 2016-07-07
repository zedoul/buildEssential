#' Setup buildEssential
#'
#' @param setting_path
#' @param description_path
#' @param miniCRAN_autoupdate
setup <- function(setting_path = NULL,
                  description_path = NULL,
                  miniCRAN_autoupdate = F) {
  if (is.null(setting_path)) {
    setting_path <- system.file("setting.yml",
                                package='buildEssential')
  } else {
    stopifnot(file.exists(setting_path))
  }

  if (is.null(description_path)) {
    description_path <- system.file("descriptions.yml",
                                    package='buildEssential')
  } else {
    stopifnot(file.exists(description_path))
  }

  cat(paste("setting file path:", setting_path, "\n"))
  cat(paste("description file path:", description_path, "\n"))

  setting <- get_setting(setting_path)
  packages <- get_packages(description_path)

  # Load settings
  miniCRAN_path <- setting[["miniCRAN_path"]]
  CRAN_url <- setting[["CRAN_url"]]
  library_path <- setting[["library_path"]]
  source_package_paths <- setting[["source_package_paths"]]
  package_types <- setting[["package_types"]]

  cat(paste("miniCRAN path:", miniCRAN_path,"\n"))
  cat(paste("CRAN url:", CRAN_url,"\n"))
  cat(paste("R library path:", library_path,"\n"))
  cat(paste("Source package paths:", source_package_paths,"\n"))
  cat(paste("package types:", package_types,"\n"))

  # Setup MCran
  if (!dir.exists(miniCRAN_path)) {
    init_miniCRAN(miniCRAN_path,
                  CRAN_url,
                  package_types)
  } else {
    cat("miniCRAN exists already\n")
  }

  # Setup Library
  if (!dir.exists(library_path)) {
    init_library(library_path)
  } else {
    cat("library_path exists already\n")
  }

  # Configure
  configure(miniCRAN_path, library_path)
  cat("Configuration setting complete\n")

  # Add miniCRAN packages
  for (package_type in package_types) {
    available_package_names <- row.names(miniCRAN::pkgAvail(type = package_type))

    for (package_name in packages) {
      if (!(package_name %in% available_package_names)) {
        tryCatch({
          cat(paste("Add", package_name, "and its dependencies to miniCRAN ...\n"))
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

  cat("miniCRAN setup complete\n")

  # Update miniCRAN packages
  if (miniCRAN_autoupdate == TRUE) {
    update_CRAN_pkgs(miniCRAN_path,
                     CRAN_url,
                     package_types)
    cat("miniCRAN update complete\n")
  } else {
    cat("Skip miniCRAN update\n")
  }

  # Install new libraries from miniCRAN
  avail_installed_pkgs <- installed.packages(library_path)
  avail_pkgs_in_miniCRAN <- row.names(miniCRAN::pkgAvail(type = "source"))

  for (package_name in packages) {
    if (all(!(package_name %in% avail_installed_pkgs),
            package_name %in% avail_pkgs_in_miniCRAN)) {
      cat(paste("Install miniCRAN package:", package_name, "...\n"))
      install_package(package_name)
    }
  }

  # Install library from source
  for (source_package_path in source_package_paths) {
    if (!(package_name %in% avail_installed_pkgs)) {
      cat(paste("Install source package:", package_name, "...\n"))
      install_src_packages(dir_path = source_package_path)
    }
  }

  cat(paste("All done. Installed packages in the R library are as follows:\n"))
  print(installed.packages()[, c("Package", "Version")])
}
