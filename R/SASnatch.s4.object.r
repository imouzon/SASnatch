#' SASnatch object
#'
#' @export

#The actual snatch object
setClass('SASnatch', 
         representation(code = 'character',
                        results= 'snatchResults',
                        out = 'snatchOutput',   
                        log = 'character'),
         contains = c('snatchResults','snatchOutput'))
