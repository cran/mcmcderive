monitor_variables <- function(monitor, values) {
  variables <- names(values[vapply(values, is_NA, TRUE)])
  
  match <- variables[grepl(monitor, variables)]
  if(!length(match)) {
    err(co_or(variables, p0(
      "monitor '", monitor, 
      "' must match at least one of the following variable%s in expr: %c")))
  }
  sort(match)
}