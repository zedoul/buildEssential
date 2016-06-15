library(buildEssential)
library(yaml)

# Load setting files
setting <- getSetting()
packages <- getPackages()

# Load settings
miniCRAN_path <- setting[["minicran_path"]]
CRAN_path <- setting[["mirror_path"]]
library_path <- setting[["library_path"]]
package_types <- setting[["package_types"]]
# TODO(ekimsen): we may get list of packages from package by using
# devtools::dev_package_deps
target_packages <- packages[["package_names"]]

# Configure
configure(miniCRAN_path, library_path)

# Setup MCran
if (!dir.exists(miniCRAN_path)) {
  initMCran(miniCRAN_path,
            CRAN_path,
            package_types)
}

# Add miniCRAN packages
for (package_type in package_types) {
  available_package_names <- row.names(miniCRAN::pkgAvail(type = package_type))

  for (package_name in target_packages) {
    if (!(package_name %in% available_package_names)) {
      addCranPkgToMCran(package_name,
                        miniCRAN_path,
                        CRAN_path,
                        package_type)
    }
  }
}

# Update miniCRAN packages
updatePkgsInMCran(miniCRAN_path,
                  CRAN_path,
                  package_types)

# Install source packages
source_packages <- list.dir("")
addSrcPkgToMCran(package_name,
              setting[["minicran_path"]],
              "source")

# Install library from miniCRAN
for (package_name in target_packages) {
  installPackages(package_name, miniCRAN_path, library_path)
}
