#' MCMC Derive
#'
#' Generate an MCMC object of derived parameter(s) from an MCMC
#' an \code{\link[mcmcr]{mcmcr}}, \code{\link[coda]{mcmc.list}} or
#' \code{\link[mcmcr]{mcmcrs}} object.
#'
#' @param object The original MCMC object.
#' @param expr A string of the R code defining the values of the 
#' derived parameter(s) with respect to the parameters in object.
#' @param values A named list of additional R objects to evaluate in the R expression.
#' @param monitor A regular expression specifying the 
#' derived parameter(s) in expr to monitor.
#' @param parallel A flag specifying whether to generate the derived parameters 
#' for each chain in parallel.
#' @param silent A flag specifying whether to suppress messages and warnings.
#' @param ... Unused.
#' @return An MCMC object 
#' of the derived parameter(s).
#' @export
#' @examples
#' mcmcr::mcmcr_example
#'
#' expr <- "
#'  log(alpha2) <- alpha
#'  gamma <- sum(alpha) * sigma"
#'
#' mcmc_derive(mcmcr::mcmcr_example, expr, silent = TRUE)
mcmc_derive <- function(object, ...) {
  UseMethod("mcmc_derive")
}

#' @describeIn mcmc_derive MCMC Derive for an mcmcr object
#' @export
mcmc_derive.mcmcr <- function(object, expr, values = list(), monitor = ".*", 
                              parallel = FALSE, silent = FALSE, ...) {
  check_mcmcr(object)
  check_string(expr)
  check_list(values)
  check_string(monitor)
  check_flag(parallel)
  check_flag(silent)
  check_unused(...)
  
  if (length(values)) {
    check_named(values, unique = TRUE)
    object <- drop_overridden_parameters(object, values, silent = silent)
    values <- drop_absent_values(values, expr, silent = silent)
  }
  object <- drop_absent_parameters(object, expr, silent = silent)
  values <- add_new_variables(values, object, expr, silent = silent)
  monitor <- monitor_variables(monitor, values)
  
  split_apply_combine(object, expr, values, monitor, parallel)
}

#' @describeIn mcmc_derive MCMC Derive for an mcmc.list object
#' @export
mcmc_derive.mcmc.list <- function(object, expr, values = list(), monitor = ".*", 
                                  parallel = FALSE, silent = FALSE, ...) {
  check_unused(...)
  object <- as.mcmcr(object)
  object <- mcmc_derive(object, expr = expr, values = values, 
                        monitor = monitor, parallel = parallel, silent = silent)
  coda::as.mcmc.list(object)
}

#' @describeIn mcmc_derive MCMC Derive for an mcmcrs object
#' @export
mcmc_derive.mcmcrs <- function(object, expr, values = list(), monitor = ".*", 
                               parallel = FALSE, silent = FALSE, ...) {
  check_unused(...)
  object <- lapply(object, mcmc_derive, expr = expr, values = values, 
                   monitor = monitor, parallel = parallel, silent = silent)
  as.mcmcrs(object)
}
