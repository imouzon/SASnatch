#--------------------------------------**--------------------------------------#
#  File Name: SASnatch.CreateCodeToLoadDatabase.sas
#  Purpose: 
#
#  Creation Date: 09-04-2014
#  Last Modified: Wed Apr  9 11:36:26 2014
#  Created By:
#
#--------------------------------------**--------------------------------------#
#
#  FORTRAN and C: 
#  source('~/R/shlib/C_FORTRAN.shlib.r')
#  .Fortran("subroutine name",as.integer(input1),as.double(input2), etc)
#

#This code writes the file that stores the data in SAS
#it should be in the first line of the SAS chunk code, ala:
#
#   %include(./out/SAScache/SASnatch_LoadDatabase.sas);
#
SASnatch.CreateCodeToLoadDatabase <- function (DBlocation,DBname='sasnatch',DBtype='SQLite') {
   require(RSQLite)
   text = paste('libname snatchR',
                'odbc',
                'complete = ',
                '"dsn = ',
                DBtype,';',
                'Driver={SQLite3 ODBC Driver};',
                'Database=',
                    DBlocation,
                    DBname,'.db";',
                )
   write(text,'./out/SAScache/SASnatch_LoadDatabase.sas')
}

#test: 
SASnatch.CreateCodeToLoadDatabase('Y:/dogs/')


