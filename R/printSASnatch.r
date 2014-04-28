#' Print SASnatch results
#'
#' @param SASnatch.S4 SASnatch object
#' @param type character value, optional argument
#' @export
printSASnatch <- function(SASnatch.S4,type='R'){
   if(type == 'R'){
   for(i in 1:length(SASnatch@results@R)){
      #Footer templates
      for(j in 1:length(SASnatch@results@R[[i]])){
         print(SASnatch@results@R[[i]][[j]])
      }
   }

   if(type == 'TeX'){
   for(i in 1:length(SASnatch@results@TeX)){
      #Footer templates
      for(j in 1:length(SASnatch@results@TeX[[i]])){
         print(SASnatch@results@TeX[[i]][[j]])
      }
   }

   if(type == 'HTML'){
   for(i in 1:length(SASnatch@results@HTML)){
      #Footer templates
      for(j in 1:length(SASnatch@results@HTML[[i]])){
         print(SASnatch@results@HTML[[i]][[j]])
      }
   }
}
