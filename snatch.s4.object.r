#Two types of output, HTML and TeX
setClass('snatchResults',representation(HTML = 'list', TeX = 'list'))

#the results from SAS
setClass('snatch2R',representation(SAS2R = 'list'))

#The actual snatch object
setClass('SASnatch', 
         representation(code = 'character',
                        results= 'snatchResults',
                        out = 'snatch2R',   
                        log = 'character'),
         contains = c('snatchCode','snatchResults','snatch2R','snatchLog'))

#try an example

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
   sas2r <- new('snatch2R',SAS2R=list(d1,d2))

#results from log
   log.file <- 'this is erros and stuff'

#and this is the final SAS output
   snatch.Chunk <- new('SASnatch',code = code.file, 
                                  results = results, 
                                  out = sas2r, 
                                  log = log.file)

setGeneric('htmlResult', function(
setMethod('htmlResult', function () {
   
}


   snatch.Chunk@results@HTML[[2]]
   snatch.Chunk@results@TeX[[2]]

   snatch.Chunk@code

   snatch.Chunk@log

   snatch.Chunk

   getSlots(class(snatch.Chunk))
   snatch.Chunk@TeX
