#--------------------------------------**--------------------------------------#
#  File Name:
#  Purpose:
#
#  Creation Date: 14-04-2014
#  Last Modified: Mon Apr 14 18:11:57 2014
#  Created By:
#
#--------------------------------------**--------------------------------------#
#
#  FORTRAN and C: 
#  source('~/R/shlib/C_FORTRAN.shlib.r')
#  .Fortran("subroutine name",as.integer(input1),as.double(input2), etc)
#

   #output is two tables
   html.output <- list('this is the first HTML table', 'this is the second HTML table')
   tex.output <- list('this is the first TeX table', 'this is the second TeX table')

   #put the results into results S4 object
   results <- new('snatchResults', HTML = html.output, TeX = tex.output)

   #code is an object
   code.file = 'proc reg data = d;'

   #results in a dataset
   d1 <- data.frame(x=1:10,y=1:10)
   d2 <- data.frame(fish=c(rep('bass',5),rep('trout',5)),wts=rexp(10))
   sas2r <- new('snatchOutput',SAS2R=list(d1,d2))

   #results from log
   log.file <- 'this is erros and stuff'
   saslog <- new('snatchLog',log=log.file)

   #and this is the final SAS output
   snatch.Chunk <- new('SASnatch',code = code.file, results = results, out = sas2r, log = log.file)

   snatch.Chunk@results@HTML[[2]]
   snatch.Chunk@results@TeX[[2]]

   snatch.Chunk@code

   snatch.Chunk@log

   snatch.Chunk
