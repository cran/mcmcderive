subset_mcmcarray_chains <- function(x, chains) {			
  x <- abind::asub(x, chains, 1L, drop = FALSE)			
  set_class(x, "mcmcarray")
}

subset_mcmcarray_iterations <- function(x, iterations) {			
  x <- abind::asub(x, iterations, 2L, drop = FALSE)	
  dim <- dim(x)[-c(1,2)]
  if(length(dim) == 1) dim <- NULL
  dim(x) <- dim
  x
}

subset_mcmcr_iterations <- function(x, iterations) {			
  lapply(x, subset_mcmcarray_iterations, iterations = iterations)	  
}

subset_mcmcr_chains <- function(x, chains) {			
  x <- lapply(x, subset_mcmcarray_chains, chains = chains)	  
  set_class(x, "mcmcr")
}

subset_mcmcr_parameters <- function(x, parameters) {
  x <- x[parameters]
  set_class(x, "mcmcr")
}

bind_iterations_mcmcarrays <- function(x) {
  x <- lapply(x, unclass)
  niters <- length(x)
  dim <- dims(x[[1]])
  dim <- c(dim, niters, 1L)
  x <- do.call("c", x)
  dim(x) <- dim
  x <- set_class(x, "mcarray")
  as.mcmcarray(x)
}


bind_iterations_mcmcrs <- function(x) {
  x <- purrr::transpose(x)
  x <- lapply(x, bind_iterations_mcmcarrays)
  x <- set_class(x, "mcmcr")
  x
}
