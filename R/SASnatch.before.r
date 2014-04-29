#' functions for knitr hooks
#'
#' @param dsn character vector, optional argument
#' @param SASnatch.code character value, optional argument
#' @param SASnatch.chunk_name character value, optional argument
#' @export 
SASnatch.before = function(dsn='',SASnatch.code='',SASnatch.chunk_name=''){
   #If SASnatch.working.directory is blank, then we need to know where to put the code
   if(!(SASnatch.working.directory=='')){
      SAScache.directory = SASnatch.working.directory
   }else{
      SAScache.directory = makeSAScache()
   }

   #make sure we know what to call this chunk
   if(!is.null(knitr:::opts_current$get('label'))){
      chunk.name = knitr:::opts_current$get('label')
   }

   #get the code from the chunk
   if(!is.null(knitr:::opts_current$get('code'))){
      code = knitr:::opts_current$get('code')
   }

   #determine which datasets go to SAS and which come from SAS 
   R2SAS = dsn[1]; SAS2R = dsn[2]

   #create SAS code
   SAScode <<- createSAScode(SASnatch.working.directory = SAScache.directory,
                 R2SAS = R2SAS,
                 SAS2R = SAS2R,
                 chunk.name=chunk.name,
                 code = code)

   #create SAS file
   SASfile = createSASfile(code=SAScode,SAScache.directory=SAScache.directory,chunk.name=chunk.name)

   #create csv files from r datasets
   R.WRITE.code = SnatchR2SAS(SAScache.directory = SAScache.directory,R2SAS = R2SAS,chunk.name=chunk.name)

   #Run the SAS code now that this the set up is there
   runSASnatch(SAScache.directory=SAScache.directory,SASnatch.label=chunk.name)

   SASnatch.S4 = read.SASnatch.object(chunk.name=chunk.name,SASresults.path=SAScache.directory,SAS2R.names=SAS2R,SAS2R.type='.csv')
   return(SASnatch.S4)
}
