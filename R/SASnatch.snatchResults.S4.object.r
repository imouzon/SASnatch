#' snatchResults object
#'
#' @export

#Two types of output, HTML and TeX
setClass('snatchResults',representation(HTML = 'list', TeX = 'list'))
