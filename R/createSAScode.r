#' create the SAS code
#'
#' @param SASnatch.working.directory, optional argument
#' @param R2SAS character value, optional argument
#' @param SAS2R character value, optional argument
#' @param chunk.name character value, optional argument
#' @param code character value, optional argument
#' @export
#' @examples
#' createSAScode('U:/Desktop/SAScache','d','regout','SASreg','proc reg data = d; model x = y; out=regout r=resid; run;')
createSAScode <- function(SASnatch.working.directory = '',R2SAS = '',SAS2R = '',chunk.name='unlabeled-SASnatch-chunk', code = ''){
   #If SASnatch.working.directory is blank, then we need to know where to put the code
   if(!(SASnatch.working.directory=='')){
      SAScache.directory = SASnatch.working.directory
   }else{
      SAScache.directory = makeSAScache()
   }

   #make sure we know what to call this chunk
   if(!is.null(knitr:::opts_current$get('label')) & chunk.name == 'unlabeled-SASnatch-chunk'){
      chunk.name = knitr:::opts_current$get('label')
   }

   #get the code from the chunk
   if(!is.null(knitr:::opts_current$get('code')) & code[1] == ''){
      code = knitr:::opts_current$get('code')
   }

   #get the header for the SAS file
   SASnatch.SASheader = SASnatch:::addSASheader(SAScache.directory=SAScache.directory,chunk.name=chunk.name)

   #get the footer for the file
   SASnatch.SASfooter = SASnatch:::addSASfooter(SAScache.directory=SAScache.directory,chunk.name=chunk.name)

   #get data import code
   SASnatch.SASimport = SASnatch:::addSASimport(R2SAS = R2SAS, SAScache.directory=SAScache.directory, chunk.name=chunk.name)

   #get data export code
   SASnatch.SASexport = SASnatch:::addSASexport(SAS2R = SAS2R, SAScache.directory=SAScache.directory, chunk.name=chunk.name)

   SASnatch.SAScode = paste(SASnatch.SASheader,
                            SASnatch.SASimport,
                            code,
                            SASnatch.SASexport,
                            SASnatch.SASfooter,sep='\n\n')
   return(SASnatch.SAScode)
}
