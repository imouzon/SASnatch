#' Create code for SAS to export data to R
#'
#' @param SAS2R character value, optional argument
#' @param SAScache.directory character value, optional argument
#' @param chunk.name character value, optional argument
#' @export
addSASexport = function(SAS2R = '',SAScache.directory='',chunk.name='unlabeled-SASnatch-chunk'){
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

   #Right now SAS2Rfile = 'csv' is option is not selectable
   SAS2Rfilet = 'csv'

   #Right now SAS2Rdbms = 'CSV' is option is not selectable
   SAS2Rdbms = 'CSV'

   #PROC EXPORT template
   SAS.EXPORT.CODE.TEMPLATE = 'PROC EXPORT data = DATASET_TO_GIVE_TO_R outfile = "SASCACHE/DATASET_TO_GIVE_TO_R.SAS2Rfilet" dbms = SAS2Rdbms replace; run;'

   #fix the SASCACHE in the templates
   SAS.EXPORT.CODE.TEMPLATE = gsub('SASCACHE',SAScache.directory,SAS.EXPORT.CODE.TEMPLATE)

   #fix the SASnatch-chunk-name in the templates
   SAS.EXPORT.CODE.TEMPLATE = gsub('SASnatch-chunk-name',chunk.name,SAS.EXPORT.CODE.TEMPLATE)

   #fix the filetype in the templates
   SAS.EXPORT.CODE.TEMPLATE = gsub('SAS2Rfilet',SAS2Rfilet,SAS.EXPORT.CODE.TEMPLATE)

   #fix the dbms in the templates
   SAS.EXPORT.CODE.TEMPLATE = gsub('SAS2Rdbms',SAS2Rdbms,SAS.EXPORT.CODE.TEMPLATE)

   #fix the SASnatch-chunk-name in the templates
   if(SAS2R[1] == ''){
      #No data to import, only data to export
      SAS.EXPORT.CODE = ''
   }else{
      SAS.EXPORT.CODE = sapply(1:length(SAS2R), function(i) gsub('DATASET_TO_GIVE_TO_R',SAS2R[i],SAS.EXPORT.CODE.TEMPLATE))
   }

   #return the import code as a single text file
   return(paste(SAS.EXPORT.CODE,collapse='\n\n'))
}
