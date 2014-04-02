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
         contains = c('snatchResults','snatch2R'))

mySASchunk <- makeSASnatch('mySASchunk','./out/SAScache')

write(file='check.tex',mySASchunk@results@TeX[[1]])
write(file='check.tex',mySASchunk@results@TeX[[2]],append=TRUE)


cat(mySASchunk@results@TeX[[1]])

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

#get results by integer
snatchTeXitem = function(S4obj,output.n,print.result=TRUE){
   if(is(snatch.Chunk,'SASnatch')){
      res = S4obj@results@TeX[[output.n]]
      if(print.result){
         print(res)
      }else{
         return(res)
      }
   }else{
      cat('Error in snatchHTML: input is not of class SASnatch\n')
   }
}

snatchHTMLitem = function(S4obj,output.n,print.result=TRUE){
   if(is(snatch.Chunk,'SASnatch')){
      res = S4obj@results@HTML[[output.n]]
      if(print.result){
         print(res)
      }else{
         return(res)
      }
   }else{
      cat('Error in snatchHTML: input is not of class SASnatch\n')
   }
}

snatchHTML = function(S4obj,input_vec){
   num_input = gsub('[^0-9.]','',input_vec)
   num_input=num_input[which(as.integer(num_input) == as.numeric(num_input))]


   if(length(num_input) > 0){
      for(i in 1:length(num_input)){
         snatchHTMLitem(S4obj,as.integer(num_input[i]))
      }
   }else{
      for(i in 1:length(S4obj@results@HTML)){
         snatchHTMLitem(S4obj,i)
      }
   }
}

snatchTeX = function(S4obj,input_vec){
   num_input = gsub('[^0-9.]','',input_vec)
   num_input=num_input[which(as.integer(num_input) == as.numeric(num_input))]

   cat(paste('first:', num_input[1],'\n'))
   cat(paste('second:', num_input[2],'\n'))

   if(length(num_input) > 0){
      for(i in 1:length(num_input)){
         snatchTeXitem(S4obj,as.integer(num_input[i]))
      }
   }else{
      for(i in 1:length(S4obj@results@TeX)){
         snatchTeXitem(S4obj,i)
      }
   }
}

snatchOptions=function(...){
   input_list <- as.list(substitute(list(...)))[-1L]
   return(input_list)
}

   
snatchPrint=function(S4obj,...){
   #get additional options
   input_list <- snatchOptions(...)
   if(length(input_list) > 0){
   input_vec <- sapply(1:length(input_list), function(i) as.character(input_list[[i]]))
   }else{
      input_vec <- 'TeX'
   }
   
   #was html table asked for? Use TeX by default
   use.html <- FALSE
   if(length(input_vec) > 0) use.html <- as.logical(sum(grepl('html',input_vec)))

   if(use.html) snatchHTML(S4obj,input_vec)
   if(!use.html) snatchTeX(S4obj,input_vec)
}
