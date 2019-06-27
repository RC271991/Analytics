x <- runif(100, -5, 5)
y <- x + rnorm(100) + 3

localizedWeightedRegression = function(x,y){
  
  library(matrixcalc)
  X = cbind(1, matrix(x)) #change based on amount of parameters x_1 ... x_n
  tau = 1 #bandwidth
  w = list()
  ans = list()
  
  for (i in 1:length(x)) {
    w[[i]] = exp(-(X[i,2]-X[(1:length(x)),2])^2/( 2 * tau))
    
    #(xTwx)-1*xTwy
    theta = matrix.inverse(t(X) %*% (w[[i]] * X)) %*% t(X)%*% (w[[i]]*y)
    #Predicted values
    ans[[i]] = theta[1]+theta[2]*x[i]
  }
  ans = unlist(ans)
  return(ans)

}
