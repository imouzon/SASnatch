#' Create folder setup for SASnatch
#'
#' @param SASnatch.working.directory character value, optional argument
#' @export
makeSAScache2 <- function(SASnatch.working.directory=''){
   #Get the cache path in R
   if(!(SASnatch.working.directory=='')){
      SASnatch.R.cache.path = SASnatch.working.directory
   }else{
      if(!is.null(knitr:::opts_current$get('cache.path'))){
         SASnatch.R.cache.path = expand.path(knitr:::opts_current$get('cache.path'))
      }else{
         SASnatch.R.cache.path = file.path(getwd(),'cache')
      }
   }
   SASnatch.R.cache.path = path.expand(SASnatch.R.cache.path)

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
      message.1 = paste("Creating folder '",SASnatch.R.cache.folder[1],"' in directory",SASnatch.R.cache.parent,sep='')
      message(message.1)
      dir.create(file.path(SASnatch.R.cache.parent,SASnatch.R.cache.folder))
   }


   #put the SAScache beside knitrs cache
   SAScache.beside.Rcache = TRUE
   if(!SAScache.beside.Rcache){
      SASnatch.SAScache.parent <- SASnatch.R.cache.parent
   }else{
      SASnatch.SAScache.parent <- SASnatch.R.cache.path
   }

   SASnatch.SAScache.path <- file.path(SASnatch.SAScache.parent,'SAScache')
   SASnatch.SAScache.folder <- 'SAScache'
   
   #At this point:
   #SASnatch.SAScache.path is full path to SAScache folder
   #SASnatch.SAScache.parent is folder containing SAScache
   #SASnatch.SAScache.folder the name of SAScache folder

   #check for the existence of the SAScache directory
   if(!file.exists(SASnatch.SAScache.path)){
      message.2 = paste("Creating folder 'SAScache' in directory",SASnatch.R.cache.parent)
      message(message.2)
      dir.create(file.path(SASnatch.SAScache.parent,'SAScache'))
   }
   return(SASnatch.SAScache.path)
}
