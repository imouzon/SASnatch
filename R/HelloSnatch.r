#' Greeting to be written after successfully loading package
#'
#' @param x character value, optional argument
#' @export
#' @examples
#' helloSnatch('... hopefully')
helloSnatch <- function(x=''){
   chr <- 'SASnatch succesfully loaded. You can now use SAS naturally ... or knitrally'
   if(x != '') chr <- paste(chr,x)
   print(chr)
}
