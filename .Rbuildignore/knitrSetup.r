#--------------------------------------**--------------------------------------#
#  File Name:
#  Purpose:
#
#  Creation Date: 06-02-2014
#  Last Modified: Mon Apr  7 14:10:19 2014
#  Created By:
#
#--------------------------------------**--------------------------------------#
#
#  FORTRAN and C: 
#  source('~/R/shlib/C_FORTRAN.shlib.r')
#  .Fortran("subroutine name",as.integer(input1),as.double(input2), etc)
#
   knitrSetup = function(rootDir = FALSE, use.tikz = FALSE){
      require('knitr')
      if(rootDir == FALSE) rootDir <- getwd()

      #store figures in the fig folder, prefix with 'graphics-'
      fig.folder = paste(rootDir,'/fig/',sep='')
      fig.prefix = paste('fig_',format(Sys.time(),'%m-%d'),sep='')
      fig.path = paste(fig.folder,fig.prefix,'_',sep='')

      #cahced output stored in cache.path
      cache.folder = paste(rootDir,'/out/cache/',sep='')
      cache.prefix = paste('out_',format(Sys.time(),'%m-%d'),sep='')
      cache.path = paste(cache.folder,cache.prefix,'_',sep='')

      options(replace.assign=TRUE,width=50)
      opts_chunk$set(
         fig.path=fig.path,
         cache.path=cache.path,
         fig.align='center', 
         fig.width=5, 
         fig.height=5, 
         fig.pos = 'h',
         fig.show='hold', 
         #crop=TRUE,
         tidy=TRUE,
         par=TRUE
      )

      if(use.tikz != FALSE){
         #library(tikzDevice)
         #options(tikzLatex = '/opt/local/bin/pdflatex')
         opts_chunk$set(dev='tikz', sanitize=TRUE,crop=TRUE)
         knit_hooks$set(
            par=function(before, options, envir){
               if(before && options$fig.show!='none') par(mar=c(4,4,.1,.1), 
                                                       cex.lab=.95, 
                                                       cex.axis=.9, 
                                                       mgp=c(2,.7,0), 
                                                       tcl=-.3)
            }, 
            crop=hook_pdfcrop
         )
         knit_hooks$set(
            true.font=function(before,options,envir) if(before && !is.null(options$out.width)) dev.args = list(pointsize=10*as.numeric(strsplit(options$out.width,'\\\\')[[1]][1])))
      }
   }
   knitrSetup()
