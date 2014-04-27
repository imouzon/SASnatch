#' Hook function that guides SASnatch
#'
#' @param before logical, identifying before or after knitr chunk
#' @param options list, of options from knitr
#' @param envir, options from R
#' @export
#' @examples 
#' SASnatch_hook(TRUE,knitr_options,'r')

SASnatch_hook = function(before, options, envir){
   if(before){
      #make folder SAScache for storing SAS output, store in SAScache.directory
      SAScache.directory <<- makeSAScache()

      #get datasets to input and output
      SASnatch.dsn <<- opts_current$get('SASnatch')

      #get the code from the chunk
      SASnatch.code <<- opts_current$get('code')

      #get the chunk name
      SASnatch.label <<- opts_current$get('label')

      #Create datasets for SAS to read
      SASnatch.code <<- SASnatch.before(SASnatch.dsn,SASnatch.code,SASnatch.chunk_name=SASnatch.label)

      #create .sas file in SAScache directory
      SASnatch.write.sascode <<- paste('write(SASnatch.code,file="',SAScache.directory,'/',SASnatch.label,'.sas")',sep='')
      eval(parse(text= SASnatch.write.sascode))

      #run the SAS code in the given file directory
      SASnatch.SASRUN <<- runSASnatch(path_to_SAS.EXE=path_to_SAS.EXE, SAScache.directory=SAScache.directory, SASnatch.label=SASnatch.label)
      system(SASnatch.SASRUN)
      SASnatch.results.S4 <<- read.SASnatch.results(chunk.name=SASnatch.label,SAS2R.names='')

      SASnatch.S4 <<- read.SASnatch.object(chunk.name=SASnatch.label,SAS2R.names='')
   }else{
      #eval(parse(text=paste(SASnatch.label,'.res <<- SASnatch.S4',sep='')))
   }
   return()
}


