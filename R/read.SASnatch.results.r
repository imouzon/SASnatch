#' read results from SASnatch 
#'
#' @param chunk.name character value, optional argument
#' @param SASresults.path character value, optional argument
#' @param SAS2R.type character value, optional argument
#' @param SAS2R.names character vector, optional argument
#' @export

read.SASnatch.results<- function (chunk.name='',SASresults.path = '',SAS2R.names='',SAS2R.type='csv'){
   #get the SAScache.directory
   if(SASresults.path == ''){
      SAScache.directory = makeSAScache()
   }else{
      SAScache.directory = SASresults.path
   }

   #now that the file structure exists read the output
   files <- list.files(path=SAScache.directory)
   files <- unique(files[grepl(chunk.name,files)])

   #get .html files
   html.files <- paste(SAScache.directory,files[grepl('.html',files)],sep='/')
   html.results <- lapply(1:length(html.files),function(i) paste(scan(file=html.files[i],sep='\n',what='character',quiet=TRUE),collapse='\n'))

   #get .tex files
   tex.files <- paste(SAScache.directory,files[grepl('.tex',files)],sep='/')
   tex.results <- lapply(1:length(tex.files),function(i) paste(scan(file=tex.files[i],sep='\n',what='character',quiet=TRUE),collapse='\n'))

   #make new snatchResults S4 object
   SASnatch.results <- new('snatchResults', HTML = html.results, TeX = tex.results)
   return(SASnatch.results)
}
