#' Create footer for SAS code generated by SASnatch chunk
#'
#' @param SAScache.directory character value, optional argument
#' @param chunk.name character value, optional argument
#' @export
#' @examples
#' addSASfooter('~/courses/stat585/lab1/','chunk3')
addSASfooter <- function(SAScache.directory='',chunk.name='unlabeled-SASnatch-chunk'){
   #Footer templates
   SAScode.ODS.CLOSE.TEMPLATE = 'ods _all_ close; ods trace off; run;'
   #SAScode.LOG.CLOSE.TEMPLATE = 'proc printto; run;'
   SAScode.LOG.CLOSE.TEMPLATE = ''
   return(paste(SAScode.ODS.CLOSE.TEMPLATE,SAScode.LOG.CLOSE.TEMPLATE,sep='\n\n'))
}
