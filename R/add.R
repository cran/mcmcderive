add_new_variables <- function(values, object, expr, silent) {
  names_values <- names(values)
  parameters <- parameters(object)
  variables <- variables(expr)
  
  variables <- setdiff(variables, union(parameters, names_values))

  if (!length(variables)) 
    err("expr must include at least one variable that is not in object or values")
  
  values[variables] <- NA
  values
}
