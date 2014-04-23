#--------------------------------------**--------------------------------------#
#  File Name: SASnatch.knitr.setup.R
#  Purpose:
#
#  Creation Date: 07-04-2014
#  Last Modified: Mon Apr  7 21:48:22 2014
#  Created By:
#
#--------------------------------------**--------------------------------------#
#
#  FORTRAN and C: 
#  source('~/R/shlib/C_FORTRAN.shlib.r')
#  .Fortran("subroutine name",as.integer(input1),as.double(input2), etc)
#

require(knitr)
SASnatch = function(before,options,envir){
   if(before){
      normalize
      write.csv(

opts_chunk$get()
SAS.cache = function(R.cache){
   #
      opts_chunk$get('cache.path')

setwd('~/courses/stat585/SASnatch/sandbox')

