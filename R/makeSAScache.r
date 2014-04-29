#' Create folder setup for SASnatch
#'
#' @param SASnatch.working.directory character value, optional argument
#' @export
makeSAScache(SASnatch.working.directory='')
makeSAScache <- function(SASnatch.working.directory=''){
   #Get the cache path in R
   if(SASnatch.working.directory != ''){
      message.1 = 'SASnatch.working.directory not set in chunk'
      message(message.1)
      SASnatch.R.cache.path = SASnatch.working.directory
   }else{
      if(!is.null(knitr:::opts_current$get('cache.path'))){
         message.1 = 'Setting SASnatch.R.cache.path to knitr cache path'
         message(message.1)
         SASnatch.R.cache.path = knitr:::opts_current$get('cache.path')
      }else{
         message.1 = 'Setting SASnatch.R.cache.path to working directory'
         message(message.1)
         SASnatch.R.cache.path = file.path(getwd(),'cache')
      }
   }

   #terminals don't work - if the terminal server is being used, just set the 
   #cache path to the desktop and be done with it
   if(grepl('iastate',SASnatch.R.cache.path)){
      SASnatch.R.cache.path = unlist(strsplit(SASnatch.R.cache.path,'/'))
      SASnatch.R.cache.path = paste('U:',paste(SASnatch.R.cache.path[4:length(SASnatch.R.cache.path)],collapse='/'),sep='/')
   }

   #Get one level up from the cache path
   SASnatch.R.cache.parent = unlist(strsplit(SASnatch.R.cache.path,'/'))
   SASnatch.R.cache.folder = SASnatch.R.cache.parent[length(SASnatch.R.cache.parent)]
   SASnatch.R.cache.parent = SASnatch.R.cache.parent[1:(length(SASnatch.R.cache.parent)-1)]
   SASnatch.R.cache.parent = paste(SASnatch.R.cache.parent,collapse='/')

   #At this point:
   #SASnatch.R.cache.path is knitr path to cache folder
   #SASnatch.R.cache.parent is folder containing knitr cache
   #SASnatch.R.cache.folder the name of knitr cache folder

   #check the existence of the Rcache
   if(!file.exists(SASnatch.R.cache.path)){
      message.2 = paste("Creating folder '",SASnatch.R.cache.folder[1],"' in directory",SASnatch.R.cache.parent,sep='')
      message(message.2)
      dir.create(file.path(SASnatch.R.cache.parent,SASnatch.R.cache.folder))
   }

   #put the SAScache beside knitrs cache
   SAScache.beside.Rcache = FALSE
   if(SAScache.beside.Rcache){
      SASnatch.SAScache.path <- gsub('cache','SAScache',SASnatch.R.cache.parent)
   }else{
      SASnatch.SAScache.path <- file.path(SASnatch.R.cache.path,'SAScache')
   }

   SASnatch.SAScache.folder <- 'SAScache'
   
   #At this point:
   #SASnatch.SAScache.path is full path to SAScache folder
   #SASnatch.SAScache.parent is folder containing SAScache
   #SASnatch.SAScache.folder the name of SAScache folder

   #check for the existence of the SAScache directory
   if(!file.exists(SASnatch.SAScache.path)){
      message.3 = paste("Creating folder 'SAScache' in directory",SASnatch.R.cache.parent)
      message(message.3)
      dir.create(file.path(SASnatch.SAScache.path))
   }

   #return the full path to the SAScache
   return(SASnatch.SAScache.path)
}
