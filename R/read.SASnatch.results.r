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

   #"true results are results that output a table
   html.files <- paste(SAScache.directory,files[grepl('.html',files)],sep='/')
   r.results <- lapply(1:length(html.files),function(i) readHTMLTable(html.results[[i]]))
   true.results <- sapply(1:length(html.files), function(i) length(r.results))

   #get only the .html files that have tables in them (the "true" results)
   html.files <- html.files[true.results]
   html.results <- lapply(1:length(html.files),function(i) paste(scan(file=html.files[i],sep='\n',what='character',quiet=TRUE),collapse='\n'))

   #get .tex files using the corresponding "true" html files
   tex.files <- paste(SAScache.directory,files[grepl('.tex',files)],sep='/')
   tex.files <- tex.files[true.results]
   tex.results <- lapply(1:length(tex.files),function(i) paste(scan(file=tex.files[i],sep='\n',what='character',quiet=TRUE),collapse='\n'))

   #get simple text results as R tables using "true" results
   r.results <- lapply(1:length(html.files),function(i) readHTMLTable(html.results[[i]]))

   #make new snatchResults S4 object
   SASnatch.results <- new('snatchResults', HTML = html.results, TeX = tex.results, R = r.results)
   return(SASnatch.results)
}
