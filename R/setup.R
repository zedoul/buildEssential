setup <- function(setting_path = NULL, description_path = NULL) {
  if (any(is.null(setting_path), file.exists(setting_path))) {
    setting_path <- system.file("setting.yml",
                                package='buildEssential')
  }

  if (any(is.null(description_path), file.exists(description_path))) {
    description_path <- system.file("descriptions.yml",
                                    package='buildEssential')
  }

  setting <- get_setting(setting_path)
  packages <- get_packages(description_path)

  # Load settings
  miniCRAN_path <- setting[["miniCRAN_path"]]
  CRAN_url <- setting[["CRAN_url"]]
  # TODO(kim.seonghyun): remove "main"
  library_path <- setting[["library_paths"]]["main", ]
  source_package_paths <- setting[["source_package_paths"]]
  package_types <- setting[["package_types"]]

  # Setup MCran
  if (!dir.exists(miniCRAN_path)) {
    init_miniCRAN(miniCRAN_path,
                  CRAN_url,
                  package_types)
  } else {
    print("miniCRAN exists already")
  }

  # Setup Library
  if (!dir.exists(library_path)) {
    init_library(library_path)
  } else {
    print("library_path exists already")
  }

  # Configure
  configure(miniCRAN_path, library_path)

  # Add miniCRAN packages
  for (package_type in package_types) {
    available_package_names <- row.names(miniCRAN::pkgAvail(type = package_type))

    for (package_name in packages) {
      if (!(package_name %in% available_package_names)) {
        tryCatch({
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

  # Update miniCRAN packages
  update_CRAN_pkgs(miniCRAN_path,
                   CRAN_url,
                   package_types)

  # Install library from miniCRAN
  for (package_name in packages) {
    install_package(package_name)
  }

  # Install library from source
  for (source_package_path in source_package_paths) {
    install_src_packages(dir_path = source_package_path)
  }
}
