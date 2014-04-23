#' Greeting to be written after successfully loading package
#'
#' @param dsn character vector, optional argument
#' @param SASnatch character vector, optional argument
#' @export
#' @examples
#' SASload.CSVdata('d1, d2, d3')
SASload.CSVdata <- function(dsn=''){
   #write the files to CSV
   dsn=gsub(',','',dsn)
   dsn=unlist(strsplit(dsn,' '))

   #export the data using write.csv and the following CODE TEMPLATE
   EXPORT.TEMPLATE = 'write.csv(DATASET-FROM-R,file=\'R-WORKINGDIR/out/SAScache/DATASET-FROM-R.csv\',row.names=FALSE,na=\'\');'

   #change the template to this specific situation
   EXPORT.TEMPLATE = gsub('R-WORKINGDIR',getwd(),EXPORT.TEMPLATE)
   EXPORT.COMMAND = paste(sapply(1:length(dsn), function(i) gsub('DATASET-FROM-R',dsn[i],EXPORT.TEMPLATE)),collapse=' ')


   #import data using proc import and the following CODE TEMPLATE
   IMPORT.TEMPLATE = 'proc import datafile = R-WORKINGDIR/out/SAScache/DATASET-FROM-R.csv dbms = CSV REPLACE; getnames = YES; run;'

   #change the template to this specific situation
   IMPORT.TEMPLATE = gsub('R-WORKINGDIR',getwd(),IMPORT.TEMPLATE)
   IMPORT.COMMAND = paste(sapply(1:length(dsn), function(i) gsub('DATASET-FROM-R',dsn[i],IMPORT.TEMPLATE)),collapse=' ')
}
