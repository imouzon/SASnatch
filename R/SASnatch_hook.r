#' Hook function that guides SASnatch
#'
#' @param before logical, identifying before or after knitr chunk
#' @param options list, of options from knitr
#' @param envir, options from R
#' @export
SASnatch_hook = function(before, options, envir){
   SASnatch.dsn = c('d1, d2','d3')
   SASnatch.working.directory = '~/courses/stat585/SASnatch_examples/fake_project2'
   SAScache.directory = '~/courses/stat585/SASnatch_examples/fake_project2/'
   chunk.name = 'SASregs'
   code = 'proc reg data = d; model y = x; out = dsnout p = yhat; run;'

   if(before){
      SAScache.directory <- makeSAScache(SASnatch.working.directory = SAScache.directory)

      #get datasets from SASnatch
      SASnatch.dsn <<- knitr:::opts_current$get('SASnatch')

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
      SASnatch.SASRUN <<- runSASnatch(SAScache.directory=SAScache.directory,
                                      SASnatch.label=chunk.name)

      #BATCH submit the code
      system(SASnatch.SASRUN)

      #read the SASnatch output
      SASnatch.S4 <<- read.SASnatch.object(chunk.name=chunk.name,SASresults.path=SAScache.directory,SAS2R.names=SAS2R,SAS2R.type='.csv')

      #run the SAS code in the given file directory
      SASnatch.S4 <<- read.SASnatch.object(chunk.name=SASnatch.label,SAS2R.names=SASnatch.output.dsn)
   }else{
      #Change the name of the S4 object
      eval(parse(text=paste(SASnatch.label,'.snatch <<- SASnatch.S4',sep='')))
   }
   return()
}
