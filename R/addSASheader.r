#' Create header for SAS code generated by SASnatch chunk
#'
#' @param SAScache.directory character value, optional argument
#' @param chunk.name character value, optional argument
#' @export
#' @examples
#' addSASheader('~/courses/stat585/lab1/')
addSASheader <- function(SAScache.directory='',chunk.name='unlabeled-SASnatch-chunk'){
   #make sure the SAScache directory exists
   if(SAScache.directory == ''){
      SAScache.directory = makeSAScache()
   }else{
      SAScache.directory = SAScache.directory
   }

   #make sure we know what to call this chunk
   if(!is.null(knitr:::opts_current$get('label')) & chunk.name == 'unlabeled-SASnatch-chunk'){
      chunk.name = knitr:::opts_current$get('label')
   }

   #SAS log template
   #SAScode.LOG.TEMPLATE = 'filename SASnatchlog "SASCACHE/SASnatch-chunk-name.log"; proc printto log = SASnatchlog new; run;'
   SAScode.LOG.TEMPLATE = ''

   #ODS TRACE template
   SAScode.ODS.TRACE.TEMPLATE = 'ods trace on; ods noproctitle; title;'

   #ODS HTML template
   SAScode.ODS.HTML.TEMPLATE = 'ods html body = "SASCACHE/SASnatch-chunk-name.html" NEWFILE = OUTPUT;'

   #ODS LaTeX template
   SAScode.ODS.TEX.TEMPLATE = 'ods tagsets.tablesonlylatex file="SASCACHE/SASnatch-chunk-name.tex" (notop nobot) NEWFILE = table;'

   #fix the SASCACHE in the templates
   SAScode.LOG.TEMPLATE = gsub('SASCACHE',SAScache.directory, SAScode.LOG.TEMPLATE)
   SAScode.ODS.TRACE.TEMPLATE = gsub('SASCACHE',SAScache.directory, SAScode.ODS.TRACE.TEMPLATE)
   SAScode.ODS.HTML.TEMPLATE = gsub('SASCACHE',SAScache.directory, SAScode.ODS.HTML.TEMPLATE)
   SAScode.ODS.TEX.TEMPLATE = gsub('SASCACHE',SAScache.directory, SAScode.ODS.TEX.TEMPLATE)

   #fix the SASnatch-chunk-name in the templates
   SAScode.LOG.TEMPLATE = gsub('SASnatch-chunk-name',chunk.name,SAScode.LOG.TEMPLATE)
   SAScode.ODS.HTML.TEMPLATE = gsub('SASnatch-chunk-name',chunk.name,SAScode.ODS.HTML.TEMPLATE)
   SAScode.ODS.TEX.TEMPLATE = gsub('SASnatch-chunk-name',chunk.name,SAScode.ODS.TEX.TEMPLATE)

   #return the header as a single text file
   return(paste(SAScode.LOG.TEMPLATE,SAScode.ODS.TRACE.TEMPLATE,SAScode.ODS.HTML.TEMPLATE,SAScode.ODS.TEX.TEMPLATE,sep = '\n\n'))
}
