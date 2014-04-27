#' call SAS without knitr
#'
#' @param dsn character vector, optional argument
#' @param code character value, optional argument
#' @param S4name character value, optional argument
#' @export 
SnatchSAS <- function(dsn,code,S4name='SnatchSAScode'){
   #There is no SASnatch cache, so use the working directory
   SAScache.directory <- paste(getwd(),'SnatchSAS',sep='/')

   #First datasets are input second datasets are output
   SASnatch.dsn <- dsn

   #get the code from the chunk
   SASnatch.code <- code

   #get the chunk name
   SASnatch.chunk_name <- S4name
   SASnatch.label <- S4name

   #First datasets are input second datasets are output
   SASnatch.output.dsn <- dsn[2]

   #terminals don't work - if the terminal server is being used, then
   #we need U:/ not /////iastat stuff
   #cache path to the desktop and be done with it
   if(grepl('iastate',SAScache.directory)){
      SAScache.directory = unlist(strsplit(SAScache.directory,'/'))
      SAScache.directory = paste('U:',paste(SAScache.directory[4:length(SAScache.directory)],collapse='/'),sep='/')
   }

   #make sure the directory you are wriitng to exists
   if(!file.exists(SAScache.directory)){
      message.1 = "Creating folder 'SnatchSAS' in current working directory"
      message(message.1)
      dir.create(file.path(getwd(),'SnatchSAS'))
   }
   
   #Code Template for transfering dataset to SAS
   RtoSAS.WRITE.CODE.TEMPLATE <- 'write.csv(DATASET_TO_GIVE_TO_SAS,"SASCACHE/DATASET_TO_GIVE_TO_SAS.csv",na="",row.names=FALSE)'
   RtoSAS.READ.CODE.TEMPLATE <- 'proc import datafile = "SASCACHE/DATASET_TO_GIVE_TO_SAS.csv" out = DATASET_TO_GIVE_TO_SAS dbms = CSV replace; getnames = yes; run;'
   RtoSAS.READ.FILE.TEMPLATE <- 'write(ObjectWithDataLoadingCode,file="SASCACHE/SASnatch-chunk-name.read.data.sas")'

   #Make sure that the SAScache directory existsand you know where it is
   RtoSAS.WRITE.CODE.TEMPLATE <- gsub('SASCACHE',SAScache.directory,RtoSAS.WRITE.CODE.TEMPLATE)
   RtoSAS.READ.CODE.TEMPLATE <- gsub('SASCACHE',SAScache.directory,RtoSAS.READ.CODE.TEMPLATE)
   RtoSAS.READ.FILE.TEMPLATE <- gsub('SASCACHE',SAScache.directory,RtoSAS.READ.FILE.TEMPLATE)
   RtoSAS.READ.FILE.TEMPLATE <- gsub('SASnatch-chunk-name',SASnatch.chunk_name,RtoSAS.READ.FILE.TEMPLATE)

   #Code Template for transfering dataset to SAS
   SAStoR.WRITE.CODE.TEMPLATE = 'proc export data = DATASET_TO_GIVE_TO_R outfile = "SASCACHE/DATASET_TO_GIVE_TO_R.csv" dbms = csv replace; run;'

   #Make sure that the SAScache directory existsand you know where it is
   SAStoR.WRITE.CODE.TEMPLATE <- gsub('SASCACHE',SAScache.directory,SAStoR.WRITE.CODE.TEMPLATE)
      
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
   }else{
      RtoSAS.3 <- ''
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
   }else{
      SAStoR.3 <- ''
   }

   SASnatch.SASheader <- addSASheader(missing.chunk.name='unlabeled-SASnatch-chunk')
   SASnatch.SASfooter <- addSASfooter(missing.chunk.name='unlabeled-SASnatch-chunk')

   SASnatch.code <- paste(SASnatch.SASheader,RtoSAS.6,SAStoR.3,SASnatch.SASfooter,sep='\n\n')

   #create .sas file in SAScache directory
   SASnatch.write.sascode <- paste('write(SASnatch.code,file="',SAScache.directory,'/',SASnatch.label,'.sas")',sep='')
   eval(parse(text= SASnatch.write.sascode))

   #run the SAS code in the given file directory
   SASnatch.SASRUN <- runSASnatch(path_to_SAS.EXE=path_to_SAS.EXE, SAScache.directory=SAScache.directory, SASnatch.label=SASnatch.label)
   system(SASnatch.SASRUN)

   SASnatch.S4 <- read.SASnatch.object(chunk.name=SASnatch.label,SAS2R.names=SASnatch.output.dsn)
}
