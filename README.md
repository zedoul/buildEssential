# buildEssential
Resolve package dependency issues in R environment over multiple network nodes
for your target packages.

# What is the buildEseential
This source code is a package for R based on miniCRAN and devtools. It is
intended for resolving dependency issues over multiple different network nodes
in enterprise level.
The name is originated from
[build-essential](http://packages.ubuntu.com/precise/build-essential) package.

# What do I need
All dependencies will be installed by using
`devtools::install_github('zedoul/buildEssential')`, which means you need to
have a computer that has R with devtools, and the Internet connection to any
CRAN mirror.

# Why do I need this
Imagine a scenario where we face a condition that working with more than one
computer connected to each other except the Internet due to a security issue.
Even some of computer cannot access each other, so therefore handling package
dependency is not an easy problem. In this setting, for example, adding a new
package can take more time than just typing `install.packages`.
This package allows you to create a private repository consists of your package
and its dependencies.

# Where are the docs
Go to `vignettes` folder for the documentation.
