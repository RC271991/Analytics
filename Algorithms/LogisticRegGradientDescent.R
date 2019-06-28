x1 = rnorm(30,3,2) + 0.1*c(1:30)
x2 = rbinom(30, 1,0.3)
x3 = rpois(n = 30, lambda = 4)
x3[16:30] = x3[16:30] - rpois(n = 15, lambda = 2)
y = c(rbinom(5, 1,0.1),rbinom(10, 1,0.25),rbinom(10, 1,0.75),rbinom(5, 1,0.9))
X = cbind(1,matrix(x1),matrix(x2),matrix(x3))

LogisticRegGradientDescent = function(X,y,alpha) {
  
  #Logistic Regression by Gradient Descent
  iter = 5000
  alpha = 0.1
  theta = matrix(rep(0,ncol(X)))

  for (i in 1:5000) {
    m = length(y)
    sigmoid = 1 /(1 + exp(-(X%*%theta)))
    # updating the theta
    theta = theta -  alpha / m * ( t(X) %*% (sigmoid - y) )
  }
  beta = theta
  #Fitted values based on coefficents: Make sure to change coef to the amount of parameters in model
  fitted.values = exp(beta[1] + beta[2]*X[1:m,2] +beta[3]*X[1:m,3]+beta[4]*X[1:m,4])/(1 + exp(beta[1] + beta[2]*X[1:m,2] +beta[3]*X[1:m,3]+beta[4]*X[1:m,4]))
  
  return(fitted.values)
  
}
