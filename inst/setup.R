library(buildEssential)
library(miniCRAN)
library(yaml)
library(devtools)
library(git2r)

# Load setting files
setting_path <- system.file("setting.yml",
                            package='buildEssential')
description_path <- system.file("descriptions.yml",
                                package='buildEssential')

setting <- get_setting(setting_path)
packages <- get_packages(description_path)

# Load settings
miniCRAN_path <- setting[["miniCRAN_path"]]
CRAN_url <- setting[["CRAN_url"]]
library_path <- setting[["library_paths"]]
src_pkg_paths <- setting[["source_package_paths"]]
package_types <- setting[["package_types"]]

# Setup MCran. At least it should contain source package folder
if (!file.exists(file.path(miniCRAN_path, "src", "contrib", "PACKAGE"))) {
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
  avail_pkgs_in_miniCRAN <- row.names(miniCRAN::pkgAvail(type = package_type))

  for (package_name in packages) {
    if (!(package_name %in% avail_pkgs_in_miniCRAN)) {
      tryCatch({
        add_CRAN_pkg(package_name,
                     miniCRAN_path,
                     CRAN_url,
                     package_type)
      }, error = function(e) {
        message(e)
      })
    }
  }
}

# Update miniCRAN packages
update_CRAN_pkgs(miniCRAN_path,
                 CRAN_url,
                 package_types)

# Install library from miniCRAN
# only installed version nothing else
avail_installed_pkgs <- installed.packages(library_path)
for (package_name in packages) {
  if (!(package_name %in% avail_installed_pkgs)) {
    install_package(package_name)
  }
}

# Install library from source
for (src_pkg_path in src_pkg_paths) {
  if (!(package_name %in% avail_installed_pkgs)) {
    install_src_packages(dir_path = src_pkg_path)
  }
}
