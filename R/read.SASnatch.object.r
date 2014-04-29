#' Create folder setup for SASnatch
#'
#' @param chunk.name character value, optional argument
#' @param SASresults.path character value, optional argument
#' @param SAS2R.names character vector, optional argument
#' @param SAS2R.type character value, optional argument
#' @export
read.SASnatch.object<- function(chunk.name='',SASresults.path='',SAS2R.names='',SAS2R.type='.csv'){
   #get the SAScache.directory
   if(SASresults.path == ''){
      SAScache.directory = makeSAScache()
   }else{
      SAScache.directory = SASresults.path
   }

   #now that the file structure exists read the output
   files.cache <- list.files(path=SAScache.directory)
   files <- unique(files.cache[grepl(chunk.name,files.cache)])

   #get results from SAS code
   SASnatch.results <- read.SASnatch.results(chunk.name=chunk.name,SASresults.path=SASresults.path,SAS2R.names=SAS2R.names,SAS2R.type=SAS2R.type)

   #get .sas files
   code.files <- paste(SAScache.directory,files[grepl('.sas',files)],sep='/')
   code.files <- code.files[!grepl('.sas~',code.files)]
   code.file <- paste(scan(file=code.files,sep='\n',what='character',quiet=TRUE),collapse='\n')

   #results in a dataset (default to CSV)
   if(SAS2R.names[1] != '' & !is.null(SAS2R.names) & !is.na(SAS2R.names)){
      #output datasets stored in the SAScache folder
      output.files.short <- files.cache[sapply(1:length(files.cache),function(j) sum(sapply(1:length(SAS2R.names),function(i) grepl(SAS2R.names[i],files.cache[j]))))  > 0]
      output.files <- paste(SAScache.directory,output.files.short,sep='/')
      output.sets <- lapply(1:length(output.files), function(i) read.csv(file=output.files[i]))
      names(output.sets) <- SAS2R.names
      output2R <- new('snatchOutput',SAS2R=output.sets)
   }else{
      #no output datasets
      output2R <- new('snathcOutput', list(NULL))
   }

   #log files imported into R
   log.files <- files[grepl('.log',files)]

   #There may be no log file written
   if(length(log.files) == 0){
      log.file = ''
   }else{
      #log.files <- paste(SAScache.directory,files[grepl('.log',files)],sep='/')
      #log.file <- paste(scan(file=log.files,sep='\n',what='character',quiet=TRUE),sep='\n')
      log.file = ''
   }
   
   #Store the SASnatch object
   SASnatch.object <- new('SASnatch',code = code.file, results = SASnatch.results, out = output2R, log=log.file)
   return(SASnatch.object)
}
