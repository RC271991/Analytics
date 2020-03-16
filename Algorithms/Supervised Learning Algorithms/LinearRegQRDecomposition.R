# Installing Packages
list.of.packages <- c("plotly", "matrixcalc", "dplyr")
new.packages <- list.of.packages[!(list.of.packages %in% installed.packages()[,"Package"])]
if(length(new.packages)) install.packages(new.packages)

library(plotly)
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

values = QRDecomposition(x,y) #Calling Function to get line

#Placing values into a matrix and sorting it to plot line
values = cbind(matrix(x),matrix(values)) 
values = values[order(values[,1]),]

plot_ly() %>%
  add_trace(x = values[,1],y = values[,2],type = 'scatter', mode = 'lines',name = 'Fitted Line') %>%
  add_trace(x = x,y = y, type = 'scatter', mode = 'markers', name = 'Data') %>%
  layout(title = '<b>Linear Regression: QR Decomposition</b>')
