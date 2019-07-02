context("mcmc-derive")

test_that("mcmc_derive", {
  
  mcmcr <- subset(mcmcr::mcmcr_example, 1:2, 1:10)
  
  expr <- "
    gamma <- alpha + beta
  alpha2 <- alpha * 2
  znot <- alpha * 2
  for(i in seq_along(x)) {
    alpha3[i] <- alpha[1] * x[i]
  }
  "
  
  values <- list(x = 2:10)
  
  derived <- mcmc_derive(mcmcr, expr, values = values, monitor = "^g|^a", silent = TRUE)
  
  expect_identical(parameters(derived), c("alpha2", "alpha3", "gamma"))
  expect_identical(nchains(derived), 2L)
  expect_identical(niters(derived), 10L)
  expect_identical(nterms(derived), 15L)
  
  expect_equal(estimates(derived),
               list(alpha2 = c(6.0195, 8.0195), 
                    alpha3 = c(6.0195, 9.02925, 12.039, 15.04875, 18.0585, 
                               21.06825, 24.078, 27.08775, 30.0975), 
                    gamma = structure(c(3.941852, 5.941852, 4.941852, 6.941852),
                                      .Dim = c(2L, 2L))))
  
  expect_error(mcmc_derive(mcmcr, expr, values = values, monitor = "something",
                           silent = TRUE), 
               "monitor 'something' must match at least one of the following variables in expr: 'gamma', 'alpha2', 'znot', 'i' or 'alpha3'")
})

test_that("mcmc_derive.mcmc.list", {
  mcmc_list <- coda::as.mcmc.list(subset(mcmcr::mcmcr_example, 1:2, 1:10))
  
  expect_warning(mcmc_derive(mcmc_list, "gamma <- alpha + beta"), 
                 "the following parameter was not in expr and so was dropped from object: 'sigma'")
  derived <- mcmc_derive(mcmc_list, "gamma <- alpha + beta", silent = TRUE)
  expect_identical(parameters(derived), "gamma")
  expect_identical(nchains(derived), 2L)
  expect_identical(niters(derived), 10L)
  expect_identical(nterms(derived), 4L)
})

test_that("mcmc_derive.mcmcr", {
  mcmcr_example <- subset(mcmcr::mcmcr_example, 1:2, 1:10)
  mcmcrs <- mcmcr::as.mcmcrs(list(model1 = mcmcr_example, model2 = mcmcr_example))
  
  expect_warning(mcmc_derive(mcmcrs, "gamma <- alpha + beta"), 
                 "the following parameter was not in expr and so was dropped from object: 'sigma'")
  derived <- mcmc_derive(mcmcrs, "gamma <- alpha + beta", silent = TRUE)
  expect_identical(parameters(derived), "gamma")
  expect_identical(nchains(derived), 2L)
  expect_identical(niters(derived), 10L)
  expect_identical(nterms(derived), 4L)
})

test_that("mcmc_derive in parallel", {
  
  mcmcr <- subset(mcmcr::mcmcr_example, 1:2, 1:10)
  
  expr <- "
    gamma <- alpha + beta
  alpha2 <- alpha * 2
  znot <- alpha * 2
  for(i in seq_along(x)) {
    alpha3[i] <- alpha[1] * x[i]
  }
  "
  
  values <- list(x = 2:10)
  
  doParallel::registerDoParallel(2)
  
  derived <- mcmc_derive(mcmcr, expr, values = values, monitor = "^g|^a", 
                         parallel = TRUE,silent = TRUE)
  
  expect_identical(parameters(derived), c("alpha2", "alpha3", "gamma"))
  expect_identical(nchains(derived), 2L)
  expect_identical(niters(derived), 10L)
  expect_identical(nterms(derived), 15L)
  
  
  expect_equal(estimates(derived),
               list(alpha2 = c(6.0195, 8.0195), 
                    alpha3 = c(6.0195, 9.02925, 12.039, 15.04875, 18.0585, 
                               21.06825, 24.078, 27.08775, 30.0975), 
                    gamma = structure(c(3.941852, 5.941852, 4.941852, 6.941852),
                                      .Dim = c(2L, 2L))))
  
  expect_error(mcmc_derive(mcmcr, expr, values = values, monitor = "something",
                           silent = TRUE), 
               "monitor 'something' must match at least one of the following variables in expr: 'gamma', 'alpha2', 'znot', 'i' or 'alpha3'")
})


test_that("mcmc_derive matrix in values", {
  mcmcr <- subset( mcmcr::mcmcr_example, 1:2, 1:10, parameters = "beta")
  
  expr <- "
    x <- Z
    for(i in 1:nrow(beta)) {
      for(j in 1:ncol(beta)) {
        x[i,j] <- beta[i,j]
      }
    }
  "
  
  Z <- matrix(0, 2, 2)
  
  values <- list(Z = Z)
  
  derived <- mcmc_derive(mcmcr, expr, values = values, monitor = "x")
  
  names(derived) <- "beta"
  expect_identical(derived, mcmcr)
})

test_that("mcmc_derive warnings and errors", {
  
  mcmcr <- subset(mcmcr::mcmcr_example, 1:2, 1:10)
  
  expect_error(mcmc_derive(mcmcr, expr = "garbage r code"),
               "garbage r")
  
  expect_error(mcmc_derive(mcmcr, expr = "alpha <- beta", 
                           values = list(alpha = 1, beta = 2, sigma = 3)),
               "all the parameters in object are also in values")
  
  expect_warning(mcmc_derive(mcmcr, expr = "alpha2 <- beta * sigma + alpha", 
                             values = list(alpha = 1)),
                 "the following parameter was also in values and so was dropped from object: 'alpha'")
  
  expect_warning(mcmc_derive(mcmcr, expr = "alpha2 <- beta * sigma + alpha", 
                             values = list(alpha3 = 1)),
                 "none of the variables in values are in expr")
  
  expect_warning(mcmc_derive(mcmcr, expr = "alpha2 <- beta + beta3 * sigma + alpha", 
                             values = list(alpha3 = 1, beta3 = 2)),
                 "the following variable was not in expr and so was dropped from values: 'alpha3'") 
  
  expect_warning(mcmc_derive(mcmcr, expr = "alpha2 <- beta * alpha"),
                 "the following parameter was not in expr and so was dropped from object: 'sigma'") 
  
  expect_error(mcmc_derive(mcmcr, expr = "unknown <- unknowable"),
               "none of the parameters in object are in expr")
  
  
  expect_error(mcmc_derive(mcmcr, expr = "alpha <- beta * sigma"),
               "expr must include at least one variable that is not in object or values")
  
  expect_error(mcmc_derive(mcmcr, expr = "alpha2 <- beta * sigma * alpha", monitor = "alpha3"),
               "monitor 'alpha3' must match at least one of the following variable in expr: 'alpha2'")
  
  expect_error(mcmc_derive(mcmcr, expr = "alpha2 <- beta * sigma * alpha * alpha3", monitor = "2$"),
               "the following derived parameter includes missing values: 'alpha2'")
})
