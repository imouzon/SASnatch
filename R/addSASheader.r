#' Create header for SAS code generated by SASnatch chunk
#'
#' @param working.directory character value, optional argument
#' @param missing.chunk.name character value, optional argument
#' @export
#' @examples
#' addSASheader('~/courses/stat585/lab1/')
addSASheader <- function(working.directory='',missing.chunk.name='unlabeled-SASnatch-chunk'){
   #make sure the SAScache directory exists
   SAScache.directory <- makeSAScache()

   #Header templates
   SAScode.HEADER.0.TEMPLATE = 'ods noproctitle; title;'
   SAScode.HEADER.1.TEMPLATE = 'ods html body = "SASCACHE/SASnatch-chunk-name.html" NEWFILE = OUTPUT NOTOP NOBOT;'
   SAScode.HEADER.2.TEMPLATE = 'ods tagsets.tablesonlylatex file="SASCACHE/SASnatch-chunk-name.tex" (notop nobot) NEWFILE = table;'

   #fix the SASCACHE
   SAScode.HEADER.0.TEMPLATE = gsub('SASCACHE',SAScache.directory, SAScode.HEADER.0.TEMPLATE)
   SAScode.HEADER.1.TEMPLATE = gsub('SASCACHE',SAScache.directory, SAScode.HEADER.1.TEMPLATE)
   SAScode.HEADER.2.TEMPLATE = gsub('SASCACHE',SAScache.directory, SAScode.HEADER.2.TEMPLATE)

   if(!is.null(knitr:::opts_current$get('label'))){
      SAScode.HEADER.1.TEMPLATE = gsub('SASnatch-chunk-name',knitr:::opts_current$get('label'),SAScode.HEADER.1.TEMPLATE)
      SAScode.HEADER.2.TEMPLATE = gsub('SASnatch-chunk-name',knitr:::opts_current$get('label'),SAScode.HEADER.2.TEMPLATE)
   }else{
      SAScode.HEADER.1.TEMPLATE = gsub('SASnatch-chunk-name',missing.chunk.name,SAScode.HEADER.1.TEMPLATE)
      SAScode.HEADER.2.TEMPLATE = gsub('SASnatch-chunk-name',missing.chunk.name,SAScode.HEADER.2.TEMPLATE)
   }
   return(paste(SAScode.HEADER.0.TEMPLATE, SAScode.HEADER.1.TEMPLATE, SAScode.HEADER.2.TEMPLATE,sep='\n\n'))
}
