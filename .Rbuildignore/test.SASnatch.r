#--------------------------------------**--------------------------------------#
#  File Name: test.SASnatch.r
#  Purpose:
#
#  Creation Date: 14-04-2014
#  Last Modified: Tue Apr 22 20:27:44 2014
#  Created By:
#
#--------------------------------------**--------------------------------------#
#
#  FORTRAN and C: 
#  source('~/R/shlib/C_FORTRAN.shlib.r')
#  .Fortran("subroutine name",as.integer(input1),as.double(input2), etc)
#

#Need these packages
rm(list=ls())
library(devtools)

#Install SASnatch in particular
setwd('~/courses/stat585/SASnatch')
document()
build_vignettes()
#check()
install()


#load the library
library(SASnatch)

#does the hello message work?
helloSnatch('... hopefully')

#check to see if folders are being created for output
system('rm -rf ~/courses/stat585/SASnatch/sandbox/fake_project3')
system('mkdir ~/courses/stat585/SASnatch/sandbox/fake_project3')

#check to see if SASnatch objects exists
#   Example output is in two tables
html.output <- list('this is the first HTML table', 'this is the second HTML table')
tex.output <- list('this is the first TeX table', 'this is the second TeX table')

#put the results into results S4 object
results <- new('snatchResults', HTML = html.output, TeX = tex.output)

#code is an object
code.file = 'proc reg data = d;'

#results in a dataset
d1 <- data.frame(x=1:10,y=1:10)
d2 <- data.frame(fish=c(rep('bass',5),rep('trout',5)),wts=rexp(10))
output2R <- new('snatchOutput',SAS2R=list(d1,d2))

#results from log
log.file <- 'this is erros and stuff'

#and this is the final SAS output
snatch.Chunk <- new('SASnatch',code = code.file, results = results, out = output2R, log = log.file)

snatch.Chunk@results@HTML[[2]]
snatch.Chunk@results@TeX[[2]]
snatch.Chunk@code
snatch.Chunk@out
snatch.Chunk@log
snatch.Chunk

SAScache.directory <- makeSAScache('~/courses/stat585/SASnatch/sandbox/fake_project3')

##use fake_project3 to create new SASoutput
#create two tables each for HTML and TeX
write('this is the first HTML table from chunk 1',file='~/courses/stat585/SASnatch/sandbox/fake_project3/out/SAScache/untitled-SAS-chunk1-1.html')
write('this is the second HTML table from chunk 1\nIt has two lines',file='~/courses/stat585/SASnatch/sandbox/fake_project3/out/SAScache/untitled-SAS-chunk1-2.html')
write('this is the first TeX table from chunk 1',file='~/courses/stat585/SASnatch/sandbox/fake_project3/out/SAScache/untitled-SAS-chunk1-1.tex')
write('this is the second TeX table from chunk 1\nIt has two lines',file='~/courses/stat585/SASnatch/sandbox/fake_project3/out/SAScache/untitled-SAS-chunk1-2.tex')
write('this is the first HTML table from chunk 2',file='~/courses/stat585/SASnatch/sandbox/fake_project3/out/SAScache/untitled-SAS-chunk2-1.html')
write('this is the second HTML table from chunk 2',file='~/courses/stat585/SASnatch/sandbox/fake_project3/out/SAScache/untitled-SAS-chunk2-2.html')
write('this is the first TeX table from chunk 2',file='~/courses/stat585/SASnatch/sandbox/fake_project3/out/SAScache/untitled-SAS-chunk2-1.tex')
write('this is the second TeX table from chunk 2\n\nIt skips\n\nand\n\nskips',file='~/courses/stat585/SASnatch/sandbox/fake_project3/out/SAScache/untitled-SAS-chunk2-2.tex')

#code is an object
write('proc reg data = d;',file='~/courses/stat585/SASnatch/sandbox/fake_project3/out/SAScache/untitled-SAS-chunk1.sas')
write('proc SAS data = other_d;',file='~/courses/stat585/SASnatch/sandbox/fake_project3/out/SAScache/untitled-SAS-chunk2.sas')

#results in a dataset
d1 <- data.frame(x=1:10,y=1:10)
d2 <- data.frame(fish=c(rep('bass',5),rep('trout',5)),wts=rexp(10))
d3 <- data.frame(deer=c('y','y','n'),type=c('buck','doe','canine'))
write.csv(d1,row.names=FALSE,na='',file='~/courses/stat585/SASnatch/sandbox/fake_project3/out/SAScache/untitled-SAS-chunk1-d1.csv')
write.csv(d2,row.names=FALSE,na='',file='~/courses/stat585/SASnatch/sandbox/fake_project3/out/SAScache/untitled-SAS-chunk1-d2.csv')
write.csv(d3,row.names=FALSE,na='',file='~/courses/stat585/SASnatch/sandbox/fake_project3/out/SAScache/untitled-SAS-chunk2-d3.csv')

#results from log
write('this is erros and stuff',file='~/courses/stat585/SASnatch/sandbox/fake_project3/out/SAScache/untitled-SAS-chunk1.log')
write('there were another erros',file='~/courses/stat585/SASnatch/sandbox/fake_project3/out/SAScache/untitled-SAS-chunk2.log')

#use fake_project3 to create new SASoutput
fake.working.dir <- '~/courses/stat585/SASnatch/sandbox/fake_project3'
setwd(fake.working.dir)
Snatchy <- read.SASnatch.object('untitled-SAS-chunk1',SAS2R.names=c('d1','d2'))
Snatchy

Snatchy2 <- read.SASnatch.object('untitled-SAS-chunk2',SAS2R.names='d3')
Snatchy2
Snatchy2@out@SAS2R$d3[,'type']

SASnatch.after(SASnatch.chunk_name='untitled-SAS-chunk2')
