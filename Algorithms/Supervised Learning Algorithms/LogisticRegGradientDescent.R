set.seed(1234)

# Installing Packages
list.of.packages <- c("plotly", "matrixcalc", "dplyr")
new.packages <- list.of.packages[!(list.of.packages %in% installed.packages()[,"Package"])]
if(length(new.packages)) install.packages(new.packages)

library(plotly)
library(dplyr)
library(matrixcalc)

x1 <- rnorm(100, 1, 2)
x2 <- rnorm(100)
y <- sign(-1 - 2 * x1 + 4 * x2 )
y[ y == -1] <- 0
X = cbind(1, matrix(x1),matrix(x2))

LogisticRegGradientDescent = function(X,y,alpha) {
  
  #Logistic Regression by Gradient Descent
  iter = 5000
  theta = matrix(rep(0,ncol(X)))

  for (i in 1:5000) {
    m = length(y)
    sigmoid = 1 /(1 + exp(-(X%*%theta)))
    # updating the theta
    theta = theta -  alpha / m * ( t(X) %*% (sigmoid - y) )
  }
  beta = theta
  #Fitted values based on coefficents: Make sure to change coef to the amount of parameters in model
  fitted.values = exp(beta[1] + beta[2]*X[1:m,2] +beta[3]*X[1:m,3])/(1 + exp(beta[1] + beta[2]*X[1:m,2] +beta[3]*X[1:m,3]))
  
  return(list("Coefficients" = beta, "fitted.values" = fitted.values))
}

values = LogisticRegGradientDescent(X,y, 0.1)

#Reference: Understanding Decision boundaries for logistic Regression https://statinfer.com/203-5-2-decision-boundary-logistic-regression/

#If p(y) > 0.5 then class = 1: Y = mx+b ==> X2 = (-b1/b2)*X1 + -b0/b2
intercept = -values$Coefficients[1]/values$Coefficients[3] 
slope = -values$Coefficients[2]/values$Coefficients[3]

Y = slope*X[,2]+ intercept
class0 = X[which(y == 0),]
class1 = X[which(y == 1),]
plot_ly() %>%
  add_trace(x = X[,2], y = Y, type = 'scatter', mode = 'lines', name = 'Decision Boundary')%>%
  add_trace(x = class0[,2],y = class0[,3], type = 'scatter', mode = 'markers',name = 'Class: 0') %>%
  add_trace(x = class1[,2],y = class1[,3], type = 'scatter', mode = 'markers',name = 'Class: 1') %>%
  layout(title = '<b>Logistic Regression: Gradient Descent</b>')
