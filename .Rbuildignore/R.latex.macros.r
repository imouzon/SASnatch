#--------------------------------------**--------------------------------------#
#  File Name: new.r
#  Purpose:
#
#  Creation Date: 18-02-2014
#  Last Modified: Sun Mar  9 12:14:52 2014
#  Created By:
#
#--------------------------------------**--------------------------------------#
#
#  FORTRAN and C: 
#  source('~/R/shlib/C_FORTRAN.shlib.r')
#  .Fortran("subroutine name",as.integer(input1),as.double(input2), etc)
#

#Begin defining macros
createarg=function(arg){
   arg <- gsub('list','',arg)
   arg <- arg[2:length(arg)]
   return(arg)
}

#--------------------------------------**--------------------------------------#
# Generic compact

   generic.nocompact.2 = function(arg){
      if(gsub("[0-9]",'',arg[2]) == ''){
         arg2 <- as.numeric(arg[2])
         ret=paste(
               arg[1],'_',arg2, '-seq.separator-',
               arg[1],'_',arg2+1, '-seq.separator-',
               arg[1],'_',arg2+2, '-seq.separator-',
               '\\ldots', '-seq.separator-',
               sep='')
      }else{
         ret=paste(
               arg[1],'_{',arg[2], '}-seq.separator-',
               arg[1],'_{',arg[2],'+1}', '-seq.separator-',
               arg[1],'_{',arg[2],'+2}', '-seq.separator-',
               '\\ldots', '-seq.separator-',
               sep='')
      }
      return(ret)
   }


   generic.nocompact.3 = function(arg){
      ret <- generic.nocompact.2(arg)
      if(length(arg) == 3){
         ret <- paste('front.cap-seq.separator-',
                     ret,
                     arg[1],'_{',arg[3],'}-seq.separator-',
                     sep = '')
      }else{
         ret <- paste('front.cap-seq.separator-',
                     ret,
                     sep = '')
      }
      ret <- paste(ret,'end.cap',sep = '')
      return(ret)
   }


   replace.generic.caps = function(generic,startcap,endcap){
      generic <- gsub('-seq.separator-end.cap',endcap,generic)
      generic <- gsub('front.cap-seq.separator-',startcap,generic)
      return(generic)
   }


   replace.generic.separator = function(generic,separator){
      generic <- gsub('-seq.separator-',separator,generic)
      return(generic)
   }
#--------------------------------------**--------------------------------------#
#--------------------------------------**--------------------------------------#






#--------------------------------------**--------------------------------------#
   # Generic compact
   generic.compact = function(caps,arg){
      ret = paste(caps[1],
               arg[1],'_{',arg[2],'}',
               caps[2],sep='')
      return(ret)
   }
#--------------------------------------**--------------------------------------#
#--------------------------------------**--------------------------------------#






#--------------------------------------**--------------------------------------#
#--------------------------------------**--------------------------------------#

R.latex.macros.options = function(arg,option){
   #use compact?
   options2check = paste(c('','no'),option,sep='')

   if(sum(grepl(options2check[1],arg))>0){
      use.option = TRUE
      arg <- arg[-which(arg == options2check[1])]
   }

   if(sum(grepl(options2check[2],arg))>0){
      use.option = FALSE
      arg <- arg[-which(arg == options2check[2])]
   }

   ret = list('arg' = arg,'use.option'=use.option)
   return(ret)
}

#--------------------------------------**--------------------------------------#
#--------------------------------------**--------------------------------------#











#--------------------------------------**--------------------------------------#
#--------------------------------------**--------------------------------------#

infseq.compact=function(arg){
   front.cap = '\\{'

   end.sub = paste('{',arg[2],' = ', arg[3],'}',sep='')
   end.sup = paste('{',arg[4],'}',sep='')
   end.cap = '\\}'
   end.cap = paste(end.cap,'_',end.sub,'^',end.sup,sep='')

   ret = generic.compact(c(front.cap,end.cap),arg)

   return(ret)
}

infseq.nocompact=function(arg){
   front.cap = '\\\\{'
   end.cap = '\\\\}'
   separator = ', '

   generic <- generic.nocompact.3(arg)
   generic <- replace.generic.caps(generic,front.cap,end.cap)
   ret <- replace.generic.separator(generic,separator)
   return(ret)
}

#--------------------------------------**--------------------------------------#
#--------------------------------------**--------------------------------------#









#--------------------------------------**--------------------------------------#
#--------------------------------------**--------------------------------------#

infcup.compact=function(arg){
   front.sub = paste('{',arg[2],' = ', arg[3],'}',sep='')
   front.sup = paste('{',arg[4],'}',sep='')
   front.cap = '\\cup'
   front.cap = paste(front.cap,'_',front.sub,'^',front.sup,' ',sep='')

   end.cap = ''

   ret = generic.compact(c(front.cap,end.cap),arg)

   return(ret)
}

infcup.nocompact=function(arg){
   front.cap = ''
   end.cap = ''
   separator = ' \\cup '

   generic <- generic.nocompact.3(arg)
   generic <- replace.generic.caps(generic,front.cap,end.cap)
   ret <- replace.generic.separator(generic,separator)
   return(ret)
}

#--------------------------------------**--------------------------------------#
#--------------------------------------**--------------------------------------#










#--------------------------------------**--------------------------------------#
#--------------------------------------**--------------------------------------#

infseq=function(...){
   #arg[1]: set/variable symbol
   #arg[2]: variable index (compact only)
   #arg[3]: start of sequence (default to 0)
   #arg[4]: end of sequence
   arg <- createarg(substitute(list(...)))

   #use compact?
   arg.opt=R.latex.macros.options(arg,'compact')
   arg = arg.opt[[1]]
   use.compact = arg.opt[[2]]

   if(use.compact){
     if(is.na(arg[4])){ arg[4] <- '\\infty' }
     ret = infseq.compact(arg)
   }else{
     ret = infseq.nocompact(arg)
   }

   ret <- paste('\\ensuremath{',ret,'}')

   return(ret)
}

infcup=function(...){
   arg <- createarg(substitute(list(...)))

   #use compact?
   arg.opt=R.latex.macros.options(arg,'nocompact')
   arg = arg.opt[[1]]
   use.compact = !arg.opt[[2]]

   if(use.compact){
     if(is.na(arg[3])){ arg[3] <- '1' }
     if(is.na(arg[4])){ arg[4] <- '\\infty' }
     ret = infcup.compact(arg)
   }else{
     ret = infcup.nocompact(arg)
   }

   ret <- paste('\\ensuremath{',ret,'}')

   return(ret)
}

infdcap = function(...){
   ret = infcup(...)
   ret <- gsub('cup','dcap',ret)
   return(ret)
}
     
infcap=function(...){
   ret = infcup(...)
   ret <- gsub('cup','cap',ret)
   return(ret)
}

infdcup = function(...){
   ret = infcup(...)
   ret <- gsub('cup','dcup',ret)
   return(ret)
}

infsum = function(...){
   arg <- createarg(substitute(list(...)))

   #use compact?
   arg.opt=R.latex.macros.options(arg,'nocompact')
   arg = arg.opt[[1]]
   use.compact = !arg.opt[[2]]

   ret = infcup(...)
   #use compact?
   if(use.compact){
      ret <- gsub('cup','sum',ret)
   }else{
      ret <- gsub('cup',' + ',ret)
   }
   return(ret)
}

infdsum = function(...){
   ret <- infsum(...)
   ret <- gsub('sum','dsum',ret)
   return(ret)
}

#--------------------------------------**--------------------------------------#
#--------------------------------------**--------------------------------------#




R.latex.macros = paste('inf',c('seq','cup','cap','sum'),sep='')
latex.macros = c(R.latex.macros,gsub('inf','infd',R.latex.macros))

#What macros have been loaded?
R.latex.macros.sed.func <- function(filedir){
   system(paste('rm ',filedir,'.tmp.rnw'))
   R.latex.macros.sed <- paste('s/\\',
                               latex.macros,
                               '\\((.*)\\)/\\Sexpr{',
                               latex.macros,'\\1}/g',
                               sep='',collapse=';')
   R.latex.macros.sed <- paste('sed \'',R.latex.macros.sed,'\' ',filedir,'.rnw > ',filedir,'.tmp.rnw',sep='')
   system(R.latex.macros.sed)
}
