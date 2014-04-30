#' Hook function that guides SASnatch
#'
#' @param before logical, identifying before or after knitr chunk
#' @param options list, options from knitr
#' @param envir, options from R
#' @export
SASnatch_hook = function(before, options, envir){
   if(before){
      SAScache.directory <- makeSAScache()

      #get datasets from SASnatch
      if(!is.null(knitr:::opts_current$get('SASnatch'))){
         SASnatch.dsn <<- knitr:::opts_current$get('SASnatch')
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
      R2SAS <<- SASnatch.dsn[1]; SAS2R <<- SASnatch.dsn[2]

      #create SAS code
      SAScode <<- createSAScode(SASnatch.working.directory = SAScache.directory,
                  R2SAS = R2SAS,
                  SAS2R = SAS2R,
                  chunk.name=chunk.name,
                  code = code)


      #create SAS file
      SASfile <<- createSASfile(code=SAScode,
                                SAScache.directory=SAScache.directory,
                                chunk.name=chunk.name)

      #create csv files from r datasets
      R.WRITE.code <<- snatchR2SAS(SAScache.directory = SAScache.directory,
                                   R2SAS = R2SAS,
                                   chunk.name=chunk.name)

      #Run the SAS code now that this the set up is there
      SASnatch.SASRUN <<- runSASnatch(path_to_SAS.EXE = path_to_SAS.EXE,
                                      SAScache.directory=SAScache.directory,
                                      SASnatch.label=chunk.name)

      #BATCH submit the code
      system(SASnatch.SASRUN)

      #read the SASnatch output
      #SASnatch.S4 <<- read.SASnatch.object(chunk.name=chunk.name, SASresults.path=SAScache.directory, SAS2R.names=SAS2R,SAS2R.type='.csv')
      #Change the name of the S4 object
      #eval(parse(text=paste(chunk.name,'.snatch <<- SASnatch.S4',sep='')))
   }else{
      message('SASnatch_hook has run successfully')
   }
}
