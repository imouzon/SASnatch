#Two types of output, HTML and TeX
#setClass('snatchHTML',representation(HTMLoutput = 'list'))
#setClass('snatchTeX',representation(TeXoutput = 'list'))
#setClass('snatchResults',representation(HTML = 'snatchHTML', TeX = 'snatchTeX'),contains = c('snatchTeX','snatchHTML'))
setClass('snatchResults',representation(HTML = 'list', TeX = 'list'))

#the code that was used
setClass('snatchCode',representation(code = 'character'))

#the dataset that was the result
setClass('snatch2R',representation(SAS2R = 'list'))

#the log file
setClass('snatchLog',representation(log = 'character'))

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

   #html.table <- new('snatchHTML',HTMLoutput = html.output)
   #tex.table <- new('snatchTeX',TeXoutput = tex.output)

#put the results into results S4 object
   #results <- new('snatchResults', HTML = html.table, TeX = tex.table)
   results <- new('snatchResults', HTML = html.output, TeX = tex.output)

#code is an object
   code.file = 'proc reg data = d;'
   code <- new('snatchCode',code=code.file)

#results in a dataset
   d1 <- data.frame(x=1:10,y=1:10)
   d2 <- data.frame(fish=c(rep('bass',5),rep('trout',5)),wts=rexp(10))
   sas2r <- new('snatch2R',SAS2R=list(d1,d2))

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
