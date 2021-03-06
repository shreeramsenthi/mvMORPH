# Pruning algorithm (Felsenstein 1973) used to compute the matrix square-root and the variance component of a phylogenetic tree
# See also Stone 2011 - Syst. Bio. and Khabazzian et al. 2016 - Meth. Ecol. Evol.; for computing the matrix square root from the prunning algorithm
# inv = TRUE compute the square root of the inverse covariance matrix, inv=FALSE compute the square root of the covariance matrix

pruning <- function(tree, inv=TRUE){
  # check the order of the tree; prunning algorithm use "postorder"
  if(!is.binary.tree(tree)) tree <- multi2di(tree, random=FALSE)
  if(attr(tree,"order")!="postorder") tree <- reorder.phylo(tree, "postorder")
  invMat=1*inv
  mode(invMat)="integer"
  
  prunRes <- .Call(squareRootM, as.integer(tree$edge[,1]), as.integer(tree$edge[,2]), 
                   tree$edge.length, as.integer(Ntip(tree)), as.integer(invMat))
  
  logdet <- sum(log(c(prunRes[[2]], prunRes[[3]]))) # log-determinant
  
  results <- list(sqrtMat=t(prunRes[[1]]), varNode=prunRes[[2]], varRoot=prunRes[[3]], det=logdet)
  # we can also just rename the list slots (names(prunRes) = c("sqrtMat","varNode","varRoot","det"))
  class(results) <- c("mvmorph.var")
  return(results)
}
