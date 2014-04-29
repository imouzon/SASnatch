#' Create folder setup for SASnatch
#'
#' @param SASnatch.working.directory character value, optional argument
#' @export
#' @examples
#' makeSAScache('~/courses/stat585/lab1/')
makeSAScache <- function(SASnatch.working.directory=''){
   #Get the cache pathe in R
   rm(list=ls())
   SASnatch.working.directory=''
   if(!(SASnatch.working.directory=='')){
      SASnatch.R.cache.path = paste(SASnatch.working.directory,sep='/')
   }else{
      if(!is.null(knitr:::opts_current$get('cache.path'))){
         SASnatch.R.cache.path = knitr:::opts_current$get('cache.path')
      }else{
         SASnatch.R.cache.path = paste(getwd(),sep='/')
      }
   }

   SASnatch.R.cache.path
   #terminals don't work - if the terminal server is being used, just set the 
   #cache path to the desktop and be done with it
   if(grepl('iastate',SASnatch.R.cache.path)){
      SASnatch.R.cache.path = unlist(strsplit(SASnatch.R.cache.path,'/'))
      SASnatch.R.cache.path = paste('U:',paste(SASnatch.R.cache.path[4:length(SASnatch.R.cache.path)],collapse='/'),sep='/')
   }

   
        
   #expanded.SASnatch.R.cache.path = unlist(strsplit(SASnatch.R.cache.path,c('/','\\\\')))
   #SASnatch.working.directory = paste(expanded.SASnatch.R.cache.path[1:(which(expanded.SASnatch.R.cache.path == 'out')-1)],collapse='/')
   SASnatch.working.directory = SASnatch.R.cache.path

   use.out.SAScache = FALSE
   if(use.out.SAScache == TRUE){
      out.directory <- paste(SASnatch.working.directory,'out',sep='/')
      if(!file.exists(out.directory)){
         message.1 = paste("Creating folder 'out' in directory",SASnatch.working.directory)
         message(message.1)
         dir.create(file.path(SASnatch.working.directory,'out'))
      }
      #check for the existence of the SAS cache directory under the knitr out directory
      SAScache.directory <- paste(out.directory,'SAScache',sep='/')
      if(!file.exists(SAScache.directory)){
         message.2 = paste("Creating folder 'SAScache' in directory",paste(SASnatch.working.directory,'out',sep='/'))
         message(message.2)
         dir.create(file.path(SASnatch.working.directory,'out/SAScache'))
      }
   }else{
      SASnatch.working.directory = unlist(strsplit(SASnatch.working.directory,'/'))
      SASnatch.working.directory = paste(SASnatch.working.directory[1:length(SASnatch.working.directory)],collapse='/')
      SAScache.directory = paste(SASnatch.working.directory,SAScache,'/')
      if(!file.exists(SAScache.directory)){
         message.1 = paste("Creating folder 'SAScache' in directory",SASnatch.working.directory)
         message(message.1)
         dir.create(file.path(SASnatch.working.directory,'SAScache'))
      }
   }
   return(SAScache.directory)
}
