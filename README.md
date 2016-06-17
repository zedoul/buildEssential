# buildEssential
Resolve package dependency issues in R over multiple network nodes, with single
R package.

# What is the buildEseential
The buildEssential is an R package that manages package dependency issues based
on devtools and miniCRAN. It is intended for resolving dependency issues over
multiple different network nodes in enterprise level. This aims to resolve those
issues by easy-to-use APIs. The name is originated from
[build-essential](http://packages.ubuntu.com/precise/build-essential) package.

# What do I need
All dependencies will be installed by using
`devtools::install_github('zedoul/buildEssential')`, which means you need to
have a computer that has R with devtools, and the Internet connection to CRAN
mirror.

# Why I need this
Sometimes we face a condition that working with more than one computer connected
to each other except the Internet due to a security issue. Even some of computer
cannot access each other, so therefore handling package dependency is not an
easy problem. In this setting, for example, adding a new package can take more
time than just typing `install.packages`.

# Where are the docs
Go to `vignettes` folder for the documentation.
