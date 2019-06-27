x <- runif(100, -5, 5)
y <- x + rnorm(100) + 3

gradientDescent = function(x,y) {
  
  X = cbind(1, matrix(x)) #change based on amount of parameters x_1 ... x_n
  theta = matrix(c(0,0), nrow=2) #Change based on amount of parameters
  alpha <- 0.01 #Learning descent
  iter = 1000
  
  for (i in 1:iter) {
    y_hat = (X %*% theta)
    theta = theta - alpha* 1/length(y) * (t(X) %*% (y_hat - y))
  }
  
  #Predicted values
  pred_y = theta[1] + theta[2]*x
  return(pred_y)

}
