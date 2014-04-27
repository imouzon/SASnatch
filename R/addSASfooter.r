#' Create footer for SAS code generated by SASnatch chunk
#'
#' @param working.directory character value, optional argument
#' @param chunk.name character value, optional argument
#' @export
#' @examples
#' addSASfooter('~/courses/stat585/lab1/','chunk3')
addSASfooter <- function(working.directory='',missing.chunk.name='unlabeled-SASnatch-chunk'){
   #Footer templates
   SAScode.HEADER.0.TEMPLATE = 'ods _all_ close; ods trace off; proc print; run;'

   return(SAScode.HEADER.0.TEMPLATE)
}
