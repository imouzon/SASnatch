#' cat() printing for SASnatch objects
#'
#' @param SASnatch.S4 SASnatch object, optional argument
#' @param type character value, optional argument
#' @export
catSnatch <- function(SASnatch.S4 = NULL,type='rawcode'){
   cat(SASnatch.S4@rawcode)
}
