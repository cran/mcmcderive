drop_overridden_parameters <- function(object, values, silent) {
  parameters <- parameters(object)
  drop <- parameters[parameters %in% names(values)]
  if(length(drop)) {
    if(all(parameters %in% drop)) 
      err("all the parameters in object are also in values")
    
    if(!silent) {
      wrn(co(drop, 
             "the following parameter was also in values and so was dropped from object: %c",
             "the following %n parameters were also in values and so were dropped from object: %c"))
      
    }
    object <- subset_mcmcr_parameters(object, parameters = setdiff(parameters, drop))
  }
  object
}

drop_absent_values <- function(values, expr, silent) {
  variables <- variables(expr)
  name_values <- names(values)
  drop <- name_values[!name_values %in% variables]
  if(length(drop)) {
    if(all(name_values %in% drop)) {
      if(!silent) wrn("none of the variables in values are in expr")
      return(list())
    }
    if(!silent) {
      wrn(co(drop, "the following variable was not in expr and so was dropped from values: %c",
             "the following %n variables were not in expr and so were dropped from values: %c"))
    } 
    values <- values[setdiff(name_values, drop)]
  }
  values  
}

drop_absent_parameters <- function(object, expr, silent) {
  variables <- variables(expr)
  parameters <- parameters(object)
  drop <- parameters[!parameters %in% variables]
  if(length(drop)) {
    if(all(parameters %in% drop)) err("none of the parameters in object are in expr")
    if(!silent) {
      wrn(co(drop, "the following parameter was not in expr and so was dropped from object: %c",
             "the following %n parameters were not in expr and so were dropped from object: %c"))
    }
    object <- subset_mcmcr_parameters(object, parameters = setdiff(parameters, drop))
  }
  object  
}
