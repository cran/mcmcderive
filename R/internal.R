variables <- function(expr) {
  all.vars(parse(text = expr))
}

is_NA <- function(x) {
  identical(x, NA)
}

set_class <- function(x, class) {
  class(x) <- class
  x
}
