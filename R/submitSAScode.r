#' Submit the SAS code generated by the SASnatch hook
#'
#' @param SASnatch.directory character value, optional argument
#' @param path_to_SAS.exe character value, optional argument
#' @param SASnatch.chunk_name character value, optional argument
#' @export
#' @examples
#' submitSAScode()
submitSAScode = function(SAScache.directory='',path_to_SAS.exe='',SASnatch.chunk_name=''){
   if(SAScache.directory=='') SAScache.directory = getwd()
   if(SASnatch.chunk_name =='') SASnathc.chunk_name = 'untitled-SAS-chunk'

   SAS.submit.TEMPLATE = 'PATHTOSASEXE/SAS.EXE -SYSIN SASCACHE/SASnatch-chunk-name.sas'
   SAS.submit.TEMPLATE = gsub('SASCACHE',SAScache.directory,SAS.submit.TEMPLATE)
   SAS.submit.TEMPLATE = gsub('SASnatch-chunk-name',SASnatch.chunk_name,SAS.submit.TEMPLATE)

   #do you know where SAS is
   if(path_to_SAS.exe == ''){
      return(0)
   }else{
      SAS.submit.TEMPLATE = gsub('PATHTOSASEXE',path_to_SAS.exe,SAS.submit.TEMPLATE)
      cat(SAS.submit.TEMPLATE)
      return(1)
   }
}
