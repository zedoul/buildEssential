library(buildEssential)
library(yaml)

# Load setting files
setting_path <- system.file("setting.yml",
                            package='buildEssential')
description_path <- system.file("descriptions.yml",
                                package='buildEssential')

setting <- getSetting(setting_path)
packages <- getPackages(description_path)

# Load settings
miniCRAN_path <- setting[["minicran_path"]]
CRAN_url <- setting[["CRAN_url"]]
library_path <- setting[["library_paths"]]["main", ]
package_types <- setting[["package_types"]]

# Setup MCran
if (!dir.exists(miniCRAN_path)) {
  init_miniCRAN(miniCRAN_path,
                CRAN_url,
                package_types)
}

# Setup Library
if (!dir.exists(library_path)) {
  init_library(library_path)
}

# Configure
configure(miniCRAN_path, library_path)

# Add miniCRAN packages
for (package_type in package_types) {
  available_package_names <- row.names(miniCRAN::pkgAvail(type = package_type))

  for (package_name in packages) {
    if (!(package_name %in% available_package_names)) {
      add_CRAN_pkg(package_name,
                   miniCRAN_path,
                   CRAN_url,
                   package_type)
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
install_src_packages(dir_path = "~/Project")
