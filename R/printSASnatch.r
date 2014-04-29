#' Print SASnatch results
#'
#' @param SASnatch.S4 SASnatch object, optional argument
#' @param type character value, optional argument
#' @param items numeric vector, optional argument
#' @export
printSASnatch <- function(SASnatch=list(),type='R',items = 0){
   
   if(type == 'R'){
      if(length(items) == 1 & items == 0){items = 1:length(SASnatch@results@R)}
      for(i in items){
         #Footer templates
         for(j in 1:length(SASnatch@results@R[[i]])){
            print(SASnatch@results@R[[i]][[j]])
         }
      }
   }


   if(type == 'HTML'){
      if(length(items) == 1 & items == 0){items = 1:length(SASnatch@results@HTML)}
      for(i in items){
         #Footer templates
         for(j in 1:length(SASnatch@results@HTML[[i]])){
            print(SASnatch@results@HTML[[i]][[j]])
         }
      }
   }

   if(type == 'rawHTML'){
      if(length(items) == 1 & items == 0){items = 1:length(SASnatch@results@rawHTML)}
      for(i in items){
         #Footer templates
         for(j in 1:length(SASnatch@results@rawHTML[[i]])){
            print(SASnatch@results@rawHTML[[i]][[j]])
         }
      }
   }

   if(type == 'TeX'){
      if(length(items) == 1 & items == 0){items = 1:length(SASnatch@results@TeX)}
      for(i in 1:items){
         #Footer templates
         for(j in 1:length(SASnatch@results@TeX[[i]])){
            print(SASnatch@results@TeX[[i]][[j]])
         }
      }
   }

   if(type == 'rawTeX'){
      if(length(items) == 1 & items == 0){items = 1:length(SASnatch@results@rawTeX)}
      for(i in items){
         #Footer templates
         for(j in 1:length(SASnatch@results@rawTeX[[i]])){
            print(SASnatch@results@rawTeX[[i]][[j]])
         }
      }
   }
}
