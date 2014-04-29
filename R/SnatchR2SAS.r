#' create the SAS code
#'
#' @param SAScache.directory character value, optional argument
#' @param R2SAS character value, optional argument
#' @param chunk.name character value, optional argument
#' @export
snatchR2SAS <- function(SAScache.directory = '',R2SAS = '',chunk.name=''){
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

   #get the datasets to pass to SAS
   R2SAS <- unique(unlist(strsplit(gsub('\\s*,\\s*',' ',R2SAS),' ')))
   
   #Right now R2SASfilet = 'csv' is option is not selectable
   R2SASfilet = 'csv'

   #Right now R2SASdbms = 'CSV' is option is not selectable
   R2SASdbms = 'CSV'

   #Template for writing datasets from R to be read by SAS
   R.WRITE.CODE.TEMPLATE <- 'write.csv(DATASET_TO_GIVE_TO_SAS,"SASCACHE/DATASET_TO_GIVE_TO_SAS.csv",na="",row.names=FALSE)'

   #fix the SASCACHE in the templates
   R.WRITE.CODE.TEMPLATE = gsub('SASCACHE',SAScache.directory,R.WRITE.CODE.TEMPLATE)

   #fix the SASnatch-chunk-name in the templates
   R.WRITE.CODE.TEMPLATE = gsub('SASnatch-chunk-name',chunk.name,R.WRITE.CODE.TEMPLATE)

   #fix the filetype in the templates
   R.WRITE.CODE.TEMPLATE = gsub('R2SASfilet',R2SASfilet,R.WRITE.CODE.TEMPLATE)

   #fix the dbms in the templates
   R.WRITE.CODE.TEMPLATE = gsub('R2SASdbms',R2SASdbms,R.WRITE.CODE.TEMPLATE)

   #fix the SASnatch-chunk-name in the templates
   if(R2SAS[1] == ''){
      #No data to import, only data to export
      R.WRITE.CODE = ''
   }else{
      R.WRITE.CODE = sapply(1:length(R2SAS), function(i) gsub('DATASET_TO_GIVE_TO_SAS',R2SAS[i],R.WRITE.CODE.TEMPLATE))
   }

   R.WRITE.code = paste(R.WRITE.CODE,collapse = ';')
   eval(parse(text = R.WRITE.code))
   return(R.WRITE.code)
}
