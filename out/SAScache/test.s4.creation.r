#--------------------------------------**--------------------------------------#
#  File Name: test.s4.creation.r
#  Purpose:
#
#  Creation Date: 02-04-2014
#  Last Modified: Wed Apr  2 13:18:47 2014
#  Created By:
#
#--------------------------------------**--------------------------------------#
#
#  FORTRAN and C: 
#  source('~/R/shlib/C_FORTRAN.shlib.r')
#  .Fortran("subroutine name",as.integer(input1),as.double(input2), etc)
#

makeSASnatch = function(chunkname,path.to.SAScache='./out/SAScache'){
   #clean up the path to the chunk files
   path.to.SAScache <- gsub('\\.','',path.to.SAScache)
   path.to.SAScache <- gsub('^/*','',path.to.SAScache)
   path.to.SAScache <- gsub(getwd(),'',path.to.SAScache)
   path.to.SAScache <- paste(getwd(),path.to.SAScache,sep='/')

   #get file names
   chunk.files <- list.files(path=path.to.SAScache)
   
   chunk.files <- paste(path.to.SAScache,chunk.files[grepl(chunkname,chunk.files)],sep='/')

   #output html
   chunk.files.output <- chunk.files[grepl('output',chunk.files)]
   chunk.files.output.html <- chunk.files.output[grepl('.html',chunk.files.output)]
   sasnatch.output.html = lapply(1:length(chunk.files.output.html),function(i) readChar(chunk.files.output.html[i], file.info(chunk.files.output.html[i])$size))

   #output tex
   chunk.files.output.tex  <- chunk.files.output[grepl('.tex',chunk.files.output)]
   sasnatch.output.tex = lapply(1:length(chunk.files.output.tex),function(i) readChar(chunk.files.output.tex[i], file.info(chunk.files.output.tex[i])$size))

   #chunk code
   chunk.files.code <- chunk.files[grepl('code',chunk.files)]
   sasnatch.code <- readChar(chunk.files.code, file.info(chunk.files.code[i])$size)
    
   #chunk returned objects
   chunk.files.returned.object <- chunk.files[grepl('returned-object',chunk.files)]
   sasnatch.returned.object = lapply(1:length(chunk.files.returned.object), function(i) read.csv(chunk.files.returned.object[i]))

   #chunk code
   chunk.files.log <- chunk.files[grepl('log',chunk.files)]
   sasnatch.log <- readChar(chunk.files.log, file.info(chunk.files.log[i])$size)

   #make output S4 object 
   sasnatch.results=new('snatchResults', 'HTML'=sasnatch.output.html, 'TeX'=sasnatch.output.tex)

   #make returned object S4 object
   sasnatch.returned.object = new('snatch2R',SAS2R = sasnatch.returned.object)

   #snatch chunk
   snatch.Chunk <- new('SASnatch', 
                       code = sasnatch.code,
                       results = sasnatch.results,
                       out = sasnatch.returned.object,
                       log = sasnatch.log)

   return(snatch.Chunk)
}




