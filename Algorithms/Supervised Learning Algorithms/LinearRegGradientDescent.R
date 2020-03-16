# Installing Packages
list.of.packages <- c("plotly", "matrixcalc", "dplyr")
new.packages <- list.of.packages[!(list.of.packages %in% installed.packages()[,"Package"])]
if(length(new.packages)) install.packages(new.packages)

library(plotly)
library(matrixcalc)
library(dplyr)

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

values = gradientDescent(x,y) #Calling Function to get line

#Placing values into a matrix and sorting it to plot line
values = cbind(matrix(x),matrix(values)) 
values = values[order(values[,1]),]

plot_ly() %>%
  add_trace(x = values[,1],y = values[,2],type = 'scatter', mode = 'lines',name = 'Fitted Line') %>%
  add_trace(x = x,y = y, type = 'scatter', mode = 'markers', name = 'Data') %>%
  layout(title = '<b>Linear Regression: Gradient Descent</b>')
