#' Create the file containing the SAS data
#'
#' @param code character value, optional argument
#' @param SAScache.directory character value, optional argument
#' @param chunk.name character value, optional argument
#' @export
createSASfile <- function(code='',SAScache.directory='',chunk.name='unlabeled-SASnatch-chunk'){
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

   #create SAS file
   CREATE.SAS.FILE.TEMPLATE = 'write(code,file="SASCACHE/SASnatch-chunk-name.sas")'

   #fix the SASCACHE in the templates
   CREATE.SAS.FILE.TEMPLATE = gsub('SASCACHE',SAScache.directory, CREATE.SAS.FILE.TEMPLATE)

   #fix the SASnatch-chunk-name in the templates
   CREATE.SAS.FILE.TEMPLATE = gsub('SASnatch-chunk-name',chunk.name, CREATE.SAS.FILE.TEMPLATE)

   #use R to create the table
   eval(parse(text = CREATE.SAS.FILE.TEMPLATE))

   #return the header as a single text file
   return()
}
