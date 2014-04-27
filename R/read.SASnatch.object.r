#' Create folder setup for SASnatch
#'
#' @param chunk.name character value, optional argument
#' @param SAS2R.type character value, optional argument
#' @param SAS2R.names character vector, optional argument
#' @export
#' @examples
#' read.SASnatch.object('SASout','~/courses/stat585/lab1/')

read.SASnatch.object<- function (chunk.name='',SAS2R.names='',SAS2R.type='csv'){
   #get the SAScache.directory
   SAScache.directory <- makeSAScache()

   #now that the file structure exists read the output
   files <- list.files(path=SAScache.directory)
   files <- files[grepl(chunk.name,files)]

   #get .sas files
   code.files <- paste(SAScache.directory,files[grepl('.sas',files)],sep='/')
   code.file <- paste(scan(file=code.files,sep='\n',what='character',quiet=TRUE),collapse='\n')

   ##results in a dataset (assumed to be CSV)
   if(length(SAS2R.names) > 1 | SAS2R.names[1] != ''){
      output.files.short <- files[sapply(1:length(files),function(j) sum(sapply(1:length(SAS2R.names),function(i) grepl(SAS2R.names[i],files[j]))))  > 0]
   }else{
      output.files.short <- files[grepl(SAS2R.type,files)]
   }

   output.files <- paste(SAScache.directory,output.files.short,sep='/')
   output.sets <- lapply(1:length(output.files), function(i) read.csv(file=output.files[i]))

   if(length(SAS2R.names) > 1 | SAS2R.names[1] != ''){
      names(output.sets) <- SAS2R.names
   }
   output2R <- new('snatchOutput',SAS2R=output.sets)
   output2R <- output.sets

   #log files imported into R
   #log.files <- paste(SAScache.directory,files[grepl('.log',files)],sep='/')
   #log.file <- paste(scan(file=log.files,sep='\n',what='character',quiet=TRUE),sep='\n')
   log.file <- ''

   #SASnatch.object <- new('SASnatch',code = code.file, results = SASnatch.results, out = output2R, log=log.file)
   SASnatch.object <- list(code = code.file, 
                           results = SASnatch.results, 
                           out = output2R, 
                           log = log.file)
   return(SASnatch.object)
}
