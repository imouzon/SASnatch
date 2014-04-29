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

   #We know that knitr puts R cache in the folder SASnatch.R.cache.path
   SASnatch.working.directory = SASnatch.R.cache.path

   #never use the out/SAScache setting
   use.out.SAScache = FALSE
   if(use.out.SAScache == TRUE){
      #put an out directory under the SASnatch.working.directory
      out.directory = paste(SASnatch.working.directory,'out',sep='/')
      if(!file.exists(out.directory)){
         message.1 = paste("Creating folder 'out' in directory",SASnatch.working.directory)
         message(message.1)
         dir.create(file.path(SASnatch.working.directory,'out'))
      }
   }else{
      #just use the SASnatch.working.directory
      out.directory = SASnatch.working.directory
   }

   #check for the existence of the SAS cache directory under the knitr out directory
   SAScache.beside.Rcache = TRUE
   if(!SAScache.beside.Rcache){
      #this branch puts the SAScache underneath the outdirectory
      SAScache.directory = paste(out.directory,'SAScache',sep='/')
      if(!file.exists(SAScache.directory)){
         message.2 = paste("Creating folder 'SAScache' in directory",out.directory)
         message(message.2)
         dir.create(file.path(out.directory,'SAScache'))
      }
   }else{
      out.directory = unlist(strsplit(out.directory,'/'))
      out.directory = paste(out.directory[1:(length(out.directory)-1)],sep='/')
      SAScache.directory = paste(out.directory,'SAScache','/')
      if(!file.exists(SAScache.directory)){
         message.2 = paste("Creating folder 'SAScache' in directory",out.directory)
         message(message.2)
         dir.create(file.path(out.directory,'SAScache'))
      }
   }
   return(SAScache.directory)
}
