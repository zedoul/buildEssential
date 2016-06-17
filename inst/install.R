# Setup basic requirement for buildEssential
# The only requirement is R and CRAN mirror internet access, nothing else

# Change this
library_path <- "/Users/zedoul/Project/Temp/testR"
CRAN_url <- "http://ftp.acc.umu.se/mirror/CRAN/"
package_names <- c("devtools")

setupLibrary <- function(package_names, library_path, CRAN_url) {
  # Create library folder
  if (!dir.exists(library_path)) {
    dir.create(library_path)
  }

  # Install required packages
  for (package_name in package_names) {
    install.packages(package_name,
                     type = "source")
  }
}

options(repos = c(CRAN = CRAN_url))
.libPaths(library_path)

# Setup user R library
setupLibrary(package_names, library_path, CRAN_url)

devtools::install_github("zedoul/buildEssential")
