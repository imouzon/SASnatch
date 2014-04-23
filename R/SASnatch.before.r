#' functions for knitr hooks
#'
#' @param dsn character vector, optional argument
#' @param SASnatch.chunk_name character value, optional argument
#' @export 
SASnatch.before = function(dsn,SASnatch.code,SASnatch.chunk_name='SASnatch'){
   #Code Template for transfering dataset to SAS
   RtoSAS.WRITE.CODE.TEMPLATE <- 'write.csv(DATASET_TO_GIVE_TO_SAS,"SASCACHE/DATASET_TO_GIVE_TO_SAS.csv",na="",row.names=FALSE)'
   RtoSAS.READ.CODE.TEMPLATE <- 'proc import datafile = "SASCACHE/DATASET_TO_GIVE_TO_SAS.csv" out = DATASET_TO_GIVE_TO_SAS dbms = CSV replace; getnames = yes; run;'
   RtoSAS.READ.FILE.TEMPLATE <- 'write(ObjectWithDataLoadingCode,file="SASCACHE/SASnatch-chunk-name.read.data.sas")'

   #Make sure that the SAScache directory existsand you know where it is
   SAScache.directory <- makeSAScache()
   RtoSAS.WRITE.CODE.TEMPLATE <- gsub('SASCACHE',SAScache.directory,RtoSAS.WRITE.CODE.TEMPLATE)
   RtoSAS.READ.CODE.TEMPLATE <- gsub('SASCACHE',SAScache.directory,RtoSAS.READ.CODE.TEMPLATE)
   RtoSAS.READ.FILE.TEMPLATE <- gsub('SASCACHE',SAScache.directory,RtoSAS.READ.FILE.TEMPLATE)
   RtoSAS.READ.FILE.TEMPLATE <- gsub('SASnatch-chunk-name',SASnatch.chunk_name,RtoSAS.READ.FILE.TEMPLATE)

   #Code Template for transfering dataset to SAS
   SAStoR.WRITE.CODE.TEMPLATE = 'proc export data = DATASET_TO_GIVE_TO_R outfile = "SASCACHE/DATASET_TO_GIVE_TO_R.csv" dbms = csv replace; run;'
   #SAStoR.WRITE.FILE.TEMPLATE <- 'write(ObjectWithDataWritingCode,file="SASCACHE/SASnatch-chunk-name.write.data.sas")'

   #Make sure that the SAScache directory existsand you know where it is
   SAStoR.WRITE.CODE.TEMPLATE <- gsub('SASCACHE',SAScache.directory,SAStoR.WRITE.CODE.TEMPLATE)
   #SAStoR.WRITE.FILE.TEMPLATE <- gsub('SASCACHE',SAScache.directory,SAStoR.WRITE.FILE.TEMPLATE)
   #SAStoR.WRITE.FILE.TEMPLATE <- gsub('SASnatch-chunk-name',SASnatch.chunk_name,SAStoR.WRITE.FILE.TEMPLATE)
      
   #which data sets are we copying for SAS to use
   RtoSAS.0 <- dsn[1]

   #if there are datasets to give to SAS, write them as csv files to
   #the SAScache folder
   if(RtoSAS.0[1] != '' & !is.null(RtoSAS.0) & !is.logical(RtoSAS.0)){
      #get the names of the datasets going from R to SAS
      RtoSAS.1 <- unique(unlist(strsplit(gsub('\\s*,\\s*',' ',RtoSAS.0),' ')))

      #modify R.WRITE.CODE.TEMPLATE so that it writes the datasets
      RtoSAS.2 <- sapply(1:length(RtoSAS.1),function(i) gsub('DATASET_TO_GIVE_TO_SAS',RtoSAS.1[i],RtoSAS.WRITE.CODE.TEMPLATE))

      #collapse the text so that it is code that will run in one line
      RtoSAS.3 <- paste(RtoSAS.2,collapse='; ')

      #modify R.READ.CODE.TEMPLATE so that it writes the datasets
      RtoSAS.4 <- sapply(1:length(RtoSAS.1),function(i) gsub('DATASET_TO_GIVE_TO_SAS',RtoSAS.1[i],RtoSAS.READ.CODE.TEMPLATE))

      #collapse the text so that it is code that will run in one line
      RtoSAS.5 <- paste(RtoSAS.4,collapse='\n\n')
      #RtoSAS.READ.FILE.TEMPLATE <- gsub('ObjectWithDataLoadingCode','RtoSAS.5',RtoSAS.READ.FILE.TEMPLATE)
      
      #create the sas file that reads the dataset
      #eval(parse(text = RtoSAS.READ.FILE.TEMPLATE))
   }else{
      RtoSAS.3 <- ''
      #RtoSAS.READ.FILE.TEMPLATE <- ''
   }

   #create the csv files using the code from RtoSAS.3
   eval(parse(text = RtoSAS.3))

   #Add the ODS statements to the SAS code from the chunk

   RtoSAS.6 <- paste(RtoSAS.5,SASnatch.code,sep='\n\n')

   #which data sets are we copying for R to use
   SAStoR.0 <- dsn[2]
   
   #if there are datasets to give to SAS, write them as csv files to the SAScache folder
   if(SAStoR.0[1] != '' & !is.null(SAStoR.0) & !is.logical(SAStoR.0) & !is.na(SAStoR.0)){
      #get the names of the datasets going from SAS to R
      SAStoR.1 <- unique(unlist(strsplit(gsub('\\s*,\\s*',' ',SAStoR.0),' ')))

      #modify SAStoR.WRITE.CODE.TEMPLATE so that it writes the datasets when run in SAS
      SAStoR.2 <- sapply(1:length(SAStoR.1),function(i) gsub('DATASET_TO_GIVE_TO_R',SAStoR.1[i],SAStoR.WRITE.CODE.TEMPLATE))

      #collapse the text so that it is code that will run in one line
      SAStoR.3 <- paste(SAStoR.2,collapse='\n\n')
      #SAStoR.WRITE.FILE.TEMPLATE <- gsub('ObjectWithDataWritingCode','SAStoR.3',SAStoR.WRITE.FILE.TEMPLATE)

      #create the SAS file used to write the code
      #eval(parse(text = SAStoR.WRITE.FILE.TEMPLATE))

      #SAStoR.READ.CODE.TEMPLATE <- gsub('SASCACHE',SAScache.directory,SAStoR.READ.CODE.TEMPLATE)
   }else{
      SAStoR.3 <- ''
   }

   SASnatch.SASheader <- SASnatch:::addSASheader(missing.chunk.name='unlabeled-SASnatch-chunk')
   SASnatch.SASfooter <- SASnatch:::addSASfooter(missing.chunk.name='unlabeled-SASnatch-chunk')

   SASnatch.SASfile <- paste(SASnatch.SASheader,RtoSAS.6,SAStoR.3,SASnatch.SASfooter,sep='\n\n')

   return(SASnatch.SASfile)
}
