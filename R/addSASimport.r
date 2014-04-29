#' Create code for SAS to import data from R
#'
#' @param R2SAS character value, optional argument
#' @param SAScache.directory character value, optional argument
#' @param chunk.name character value, optional argument
#' @export
addSASimport <- function(R2SAS = '', SAScache.directory='',chunk.name='unlabeled-SASnatch-chunk'){
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

   #Right now R2SASfilet = 'csv' is option is not selectable
   R2SASfilet = 'csv'

   #Right now R2SASdbms = 'CSV' is option is not selectable
   R2SASdbms = 'CSV'

   #PROC IMPORT template
   SAS.IMPORT.CODE.TEMPLATE <<- 'PROC IMPORT DATAFILE = "SASCACHE/DATASET_TO_GIVE_TO_SAS.R2SASfilet" out = DATASET_TO_GIVE_TO_SAS dbms = R2SASdbms replace; getnames = yes; run;'

   #fix the SASCACHE in the templates
   SAS.IMPORT.CODE.TEMPLATE <<- gsub('SASCACHE',SAScache.directory,SAS.IMPORT.CODE.TEMPLATE)

   #fix the SASnatch-chunk-name in the templates
   SAS.IMPORT.CODE.TEMPLATE <<- gsub('SASnatch-chunk-name',chunk.name,SAS.IMPORT.CODE.TEMPLATE)

   #fix the filetype in the templates
   SAS.IMPORT.CODE.TEMPLATE <<- gsub('R2SASfilet',R2SASfilet,SAS.IMPORT.CODE.TEMPLATE)

   #fix the dbms in the templates
   SAS.IMPORT.CODE.TEMPLATE <<- gsub('R2SASdbms',R2SASdbms,SAS.IMPORT.CODE.TEMPLATE)

   #make sure that the R2SAS stuff works
   R2SAS = unique(unlist(strsplit(gsub('\\s*,\\s*',' ',R2SAS),' ')))

   #fix the SASnatch-chunk-name in the templates
   if(R2SAS[1] == ''){
      #No data to import, only data to export
      SAS.IMPORT.CODE <<- ''
   }else{
      SAS.IMPORT.CODE <<- sapply(1:length(R2SAS), function(i) gsub('DATASET_TO_GIVE_TO_SAS',R2SAS[i],SAS.IMPORT.CODE.TEMPLATE))
   }

   #return the import code as a single text file
   return(paste(SAS.IMPORT.CODE,collapse='\n\n'))
}
