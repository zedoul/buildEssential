getSetting <- function(setting_path = "setting.yml") {
  setting_file <- system.file(setting_path, package='buildEssential')
  setting <- yaml.load_file(setting_file)

  getLibPath <- function(library_path) {
    paste0(library_path, "/", version$major, ".", version$minor)
  }

  setting[["library_path"]] <- getLibPath(setting[["library_path"]])

  return (setting)
}

getPackages <- function(description_path,
                        which_dep = c("Imports", "Depends", "LinkingTo")) {
  # Use devtools::dev_package_deps
  packages_file <- system.file('packages.yml', package='buildEssential')
  packages <- yaml.load_file(packages_file)

  return (packages)
}
