#' Given the path to SAS, execute the SAS code created by SASnatch
#'
#' @param path_to_SAS.EXE character value, optional argument
#' @param SAScache.directory character value, optional argument
#' @param SASnatch.label character value, optional argument
#' @export

runSASnatch <- function(path_to_SAS.EXE='',SAScache.directory='',SASnatch.label=''){
   EXECUTE.SAS.CODE.TEMPLATE.0  <- 'PATH_TO_SASEXE PATH_TO_SASCACHE/SASnatch-chunk-label.sas' 
   EXECUTE.SAS.CODE.TEMPLATE.1  <- gsub('PATH_TO_SASEXE',path_to_SAS.EXE,EXECUTE.SAS.CODE.TEMPLATE.0)
   EXECUTE.SAS.CODE.TEMPLATE.2  <- gsub('PATH_TO_SASCACHE',SAScache.directory,EXECUTE.SAS.CODE.TEMPLATE.1)
   EXECUTE.SAS.CODE.TEMPLATE.3  <- gsub('SASnatch-chunk-label',SASnatch.label,EXECUTE.SAS.CODE.TEMPLATE.2)
   execute.sas <<- EXECUTE.SAS.CODE.TEMPLATE.3
   #system(execute.sas)
   return(execute.sas)
}
