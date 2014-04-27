#' SASnatch object
#'
#' @export

#the dataset that was the result
setClass('snatchOutput',representation(SAS2R = 'list'))

#Two types of output, HTML and TeX
setClass('snatchResults',representation(HTML = 'list', TeX = 'list', R = 'list'))

#The actual snatch object
setClass('SASnatch', 
         representation(code = 'character',
                        results= 'snatchResults',
                        out = 'snatchOutput',   
                        log = 'character'),
         contains = c('snatchResults','snatchOutput'))
