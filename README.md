
<!-- README.md is generated from README.Rmd. Please edit that file -->

# mcmcderive

<!-- badges: start -->

[![lifecycle](https://img.shields.io/badge/lifecycle-maturing-blue.svg)](https://www.tidyverse.org/lifecycle/#maturing)
[![R build
status](https://github.com/poissonconsulting/mcmcderive/workflows/R-CMD-check/badge.svg)](https://github.com/poissonconsulting/mcmcderive/actions)
[![Codecov test
coverage](https://codecov.io/gh/poissonconsulting/mcmcderive/branch/master/graph/badge.svg)](https://codecov.io/gh/poissonconsulting/mcmcderive?branch=master)
[![License:
MIT](https://img.shields.io/badge/License-MIT-green.svg)](https://opensource.org/licenses/MIT)
[![CRAN
status](https://www.r-pkg.org/badges/version/mcmcderive)](https://cran.r-project.org/package=mcmcderive)
![CRAN downloads](http://cranlogs.r-pkg.org/badges/mcmcderive)
<!-- badges: end -->

## Why `mcmcderive`?

`mcmcderive` is an R package to generate derived parameter(s) from Monte
Carlo Markov Chain (MCMC) samples using R code.

This is useful because it means Bayesian models can be fitted without
the inclusion of derived parameters which add unnecessary clutter and
slows model fitting. For more information on MCMC samples see Brooks et
al. (2011).

## Installation

To install the latest release version from
[CRAN](https://cran.r-project.org/package=mcmcderive)

    install.packages("mcmcderive")

To install the latest development version from
[GitHub](https://github.com/poissonconsulting/mcmcderive)

    remotes::install_github("poissonconsulting/mcmcderive")

## Demonstration

``` r
library(mcmcderive)
#> Registered S3 methods overwritten by 'mcmcr':
#>   method                    from      
#>   as_nlist.mcmc             nlist     
#>   as_nlist.mcmc.list        nlist     
#>   as_nlists.mcmc            nlist     
#>   as_term.mcmc              nlist     
#>   collapse_chains.default   universals
#>   collapse_chains.mcmc.list nlist     
#>   complete_terms.mcmc       nlist     
#>   nchains.mcmc              nlist     
#>   nchains.mcmc.list         nlist     
#>   niters.mcmc               nlist     
#>   niters.mcmc.list          nlist     
#>   npdims.mcmc.list          nlist     
#>   nterms.mcmc               nlist     
#>   nterms.mcmc.list          nlist     
#>   pars.mcmc                 nlist     
#>   pars.mcmc.list            nlist     
#>   pdims.mcmc                nlist     
#>   pdims.mcmc.list           nlist     
#>   set_pars.mcmc             nlist     
#>   set_pars.mcmc.list        nlist     
#>   sort.mcmc                 nlist     
#>   sort.mcmc.list            nlist     
#>   subset.mcmc               nlist     
#>   subset.mcmc.list          nlist     
#>   tidy.mcmc                 nlist     
#>   tidy.mcmc.list            nlist

mcmcr::mcmcr_example
#> $alpha
#> [1] 3.718025 4.718025
#> 
#> nchains:  2 
#> niters:  400 
#> 
#> $beta
#>           [,1]     [,2]
#> [1,] 0.9716535 1.971654
#> [2,] 1.9716535 2.971654
#> 
#> nchains:  2 
#> niters:  400 
#> 
#> $sigma
#> [1] 0.7911975
#> 
#> nchains:  2 
#> niters:  400

expr <- "
  log(alpha2) <- alpha
  gamma <- sum(alpha) * sigma
"

mcmc_derive(mcmcr::mcmcr_example, expr, silent = TRUE)
#> $alpha2
#> [1]  41.18352 111.94841
#> 
#> nchains:  2 
#> niters:  400 
#> 
#> $gamma
#> [1] 6.60742
#> 
#> nchains:  2 
#> niters:  400
```

### Parallel Chains

If the MCMC object has multiple chains the run time can be substantially
reduced by generating the derived parameters for each chain in parallel.
In order for this to work it is necessary to:

1)  Ensure plyr and doParallel are installed using
    `install.packages(c("plyr", "doParallel"))`.
2)  Register a parallel backend using
    `doParallel::registerDoParallel(4)`.
3)  Set `parallel = TRUE` in the call to `mcmc_derive()`.

### Extras

To facilitate the translation of model code into R code the `extras`
package provides the R equivalent to common model functions such as
`pow()`, `phi()` and `log() <-`.

## Contribution

Please report any
[issues](https://github.com/poissonconsulting/mcmcderive/issues).

[Pull requests](https://github.com/poissonconsulting/mcmcderive/pulls)
are always welcome.

## Code of Conduct

Please note that the mcmcderive project is released with a [Contributor
Code of
Conduct](https://contributor-covenant.org/version/2/0/CODE_OF_CONDUCT.html).
By contributing to this project, you agree to abide by its terms.

## References

Brooks, S., Gelman, A., Jones, G.L., and Meng, X.-L. (Editors). 2011.
Handbook for Markov Chain Monte Carlo. Taylor & Francis, Boca Raton.
