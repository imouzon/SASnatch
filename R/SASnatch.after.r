#' after functions for knitr hooks
#'
#' @param SASnatch.chunk_name character value, optional argument
#' @export 
SASnatch.after = function(SASnatch.chunk_name='SASnatch-chunk-name'){
   #Code Template for transfering dataset to SAS
   SAScache.directory <- makeSAScache()

   #Code Template for transfering dataset to SAS
   SAStoR.READ.CODE.TEMPLATE <- 'DATASET_TO_GIVE_TO_R <<- read.csv("SASCACHE/DATASET_TO_GIVE_TO_R.csv")'

   #Make sure that the SAScache directory existsand you know where it is
   SAStoR.READ.CODE.TEMPLATE <- gsub('SASCACHE',SAScache.directory,SAStoR.READ.CODE.TEMPLATE)

   #which data sets are we copying for R to use
   SAStoR.0 <- dsn[2]

   #if there are datasets to give to SAS, write them as csv files to the SAScache folder
   if(SAStoR.0[1] != '' & !is.null(SAStoR.0) & !is.logical(SAStoR.0) & !is.na(SAStoR.0)){
      #get the names of the datasets going from SAS to R
      SAStoR.1 <- unique(unlist(strsplit(gsub('\\s*,\\s*',' ',SAStoR.0),' ')))

      #modify R.READ.CODE.TEMPLATE so that it writes the datasets
      SAStoR.4 <- paste(sapply(1:length(SAStoR.1),function(i) gsub('DATASET_TO_GIVE_TO_R',SAStoR.1[i],SAStoR.READ.CODE.TEMPLATE)),collapse='; ')

      #create the sas file that reads the dataset
      eval(parse(text=SAStoR.4))
   }

   #SAScache: get the SASnatch object from the chunk name
   #eval(parse(text = paste('SASnatch.',SASnatch.chunk_name,' <<- read.SASnatch.object("',SASnatch.chunk_name,'")',sep='')))
   eval(parse(text = paste(SASnatch.chunk_name,' <<- read.SASnatch.object("',SASnatch.chunk_name,'",SAS2R.names=SAStoR.1)',sep='')))
}
