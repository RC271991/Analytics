x <- runif(100, -5, 5)
y <- x + rnorm(100) + 3

QRDecomposition = function(x,y){
  
  X = cbind(1, matrix(x))
  qrx = qr(X)
  (f = t(qr.Q(qrx)) %*% y)
  
  #Coefficients
  coef = backsolve(qr.R(qrx),f)
  b0 = coef[[1]]
  b1 = coef[[2]]

  #Predicted values
  pred_y = b0 + b1*x
  return(pred_y)

}
