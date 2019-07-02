check_no_missing_values <- function(object) {
  missing <- vapply(object, anyNA, TRUE)
  
  if(any(missing)) {
    err(co(names(missing[missing]), 
           "the following derived parameter includes missing values: %c",
           "the following %n derived parameter%s include missing values: %c"))
  }
  object
}
