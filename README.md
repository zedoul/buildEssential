# buildr
Resolve package dependency issues in R environment over computers
for your target packages.

# What is the buildEseential
This source code is a package for R based on miniCRAN and devtools. It is
intended for resolving dependency issues over multiple computers
in enterprise level.
The name is originated from
[build-essential](https://packages.ubuntu.com/search?keywords=build-essential).

# What do I need
All dependencies will be installed by using
`devtools::install_github('zedoul/buildr')`, which means you need to
have a computer that has R and the Internet connection.
There is no cran version of `buildr` yet.

In short,

* `install.packages('devtools', repos='http://cran.us.r-project.org')`
* `devtools::install_github('zedoul/buildr')`

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
Or run `pkgdown::build_site()` if you want to have it in your local machine.
