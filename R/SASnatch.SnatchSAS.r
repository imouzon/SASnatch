#' call SAS without knitr
#'
#' @param dsn character vector, optional argument
#' @param code character value, optional argument
#' @param S4name character value, optional argument
#' @export 
snatchSAS <- function(dsn,code,S4name='SnatchSAScode'){
   #There is no SASnatch cache, so use the working directory
   SAScache.directory <- paste(getwd(),'SnatchSAS',sep='/')

   #First datasets are input second datasets are output
   SASnatch.dsn <- dsn

   #get the chunk name
   SASnatch.chunk.name <- S4name
   chunk.name <- S4name

   #get the code from input
   SASnatch.code <- code
   rawcode = code

   #determine which datasets go to SAS and which come from SAS 
   R2SAS <<- SASnatch.dsn[1]; SAS2R <<- SASnatch.dsn[2]

   #terminals don't work - if the terminal server is being used, then
   #we need U:/ not /////iastat stuff
   #cache path to the desktop and be done with it
   if(grepl('iastate',SAScache.directory)){
      SAScache.directory = unlist(strsplit(SAScache.directory,'/'))
      SAScache.directory = paste('U:',paste(SAScache.directory[4:length(SAScache.directory)],collapse='/'),sep='/')
   }

   #make sure the directory you are wriitng to exists
   if(!file.exists(SAScache.directory)){
      message("Creating folder 'SnatchSAS' in current working directory")
      dir.create(file.path(getwd(),'SnatchSAS'))
   }
   
   #determine which datasets go to SAS and which come from SAS 
   R2SAS <- SASnatch.dsn[1]; SAS2R <<- SASnatch.dsn[2]

   #create SAS code
   SAScode <- createSAScode(SASnatch.working.directory = SAScache.directory,
               R2SAS = R2SAS,
               SAS2R = SAS2R,
               chunk.name=chunk.name,
               code = code)

   #create SAS file
   SASfile <- createSASfile(code=SAScode,
                              SAScache.directory=SAScache.directory,
                              chunk.name=chunk.name)

   #create csv files from r datasets
   R.WRITE.code <- snatchR2SAS(SAScache.directory = SAScache.directory,
                                 R2SAS = R2SAS,
                                 chunk.name=chunk.name)

   #Run the SAS code now that this the set up is there
   SASnatch.SASRUN <- runSASnatch(path_to_SAS.EXE = path_to_SAS.EXE,
                                    SAScache.directory=SAScache.directory,
                                    SASnatch.label=chunk.name)

   #BATCH submit the code
   system(SASnatch.SASRUN)

   #read the SASnatch output
   SASnatch.S4 <- read.SASnatch.object(chunk.name=chunk.name, 
                                       rawcode = rawcode,
                                       SASresults.path=SAScache.directory, 
                                       SAS2R.names=SAS2R,SAS2R.type='.csv')

   #Change the name of the S4 object
   #eval(parse(text=paste(chunk.name,'.snatch <<- SASnatch.S4',sep='')))
   return(SASnatch.S4)
}
