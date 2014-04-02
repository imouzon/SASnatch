#Two types of tables
setClass('snatchHTML',representation(HTMLoutput = 'list'))
setClass('snatchTeX',representation(TeXoutput = 'list'))
setClass('snatchRes',representation(HTML = 'snatchHTML', TeX = 'snatchTeX'),contains = c('snatchTeX','snatchHTML'))

#the code that was used
setClass('snatchCode',representation(SAScode = 'character'))

#the dataset that was the result
setClass('snatch2R',representation(SASdata = 'list'))

#the log file
setClass('snatchLog',representation(SASlog = 'character'))

#The actual snatch object
setClass('SASnatch', 
         representation(tables = 'snatchTables',code = 'snatchCode',
                        data = 'snatchData',   log = 'snatchLog'),
         contains = c('snatchTables', 'snatchCode', 'snatchData', 'snatchLog'))

html.able <- new('snatchHTML',HTMLout = list('this is an html table from SAS'))
   tex.table <- new('snatchTeX',TeXTable = 'this is an tex table from SAS')
   tables <- new('snatchTables', HTML = html.table, TeX = tex.table)

   code <- new('snatchCode',SAScode = 'proc reg data = d;')

   d <- data.frame(x=1:10,y=1:10)

   
   tex.table@HTMLTable
   setClass('SASnatch',representation(code = 'character', '
@

\renewcommand{\Semester}{Spring 2014}
\groupleaderinfo{Prelim Group 2014}{ISU Statistics PhD Prelim Exam Study Group}
\groupspecinfo{Prelim Group}{ISU Group}{TR, 3:10 - 4:00}


%-- title page and quote
\titleheader{}
\Sexpr{source('~/R/randomTeXquote.r'); randomTeXquote}


%-- package: R code (Code in Document)
<<package, echo=TRUE, cache=TRUE, include = TRUE>>=
?grepl
@

Let $X_1, X_2, \ldots$ be a sequence of random variables ...
