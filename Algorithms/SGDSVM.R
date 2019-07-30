#SGD on linear seperable data
#Hard-margin
library(plotly)

#Date Clean-Up
df = iris
df = df[df$Species != 'versicolor',]
df$Species = as.integer(df$Species)
df$Species[df$Species == 1] = -1
df$Species[df$Species == 3] = 1
df = df[df$Sepal.Width != 2.5,]

#Assigning X matrix and labels
X = cbind(matrix(df[,1]), matrix(df[,2]))
y = df[,5]

SGDSVM = function(X,y) {
  
  #Stochastic Gradient Descent
  w = matrix(rep(0,ncol(X)))
  b = 0
  alpha = 0.01#learning rate: Note can adjust learning rate respectively to change hyperplane
  iter = 10000

  for (i in 1:iter){
    #shuffling
    X = cbind(X,y)
    X = X[sample(nrow(X)),]
    
    y = X[,3]
    X = X[,1:2]
    epochs = 1/i #regularizer variable
    for (j in 1:NROW(X)){
      if (y[j]* (t(w) %*% X[j,]+b) < 1){
        #J(W) = sum from i to m of (1/2*||w||^2*epoch +  of the max of (0,1-yiwTxi))
        w = w - alpha*((epochs*w) - (X[j,] * y[j]) ) #w_old - (derative respect to line 32)
        b = b + alpha*y[j]
        }
      else{
        w = w - alpha*(epochs*w)
      }
    }
  }
  return(list("w" = w, "b" = b))
}

values = SGDSVM(X,y)

intercept = -values$b/values$w[2] 
slope = -values$w[1]/values$w[2]

#y =mx+b
Y1 = slope*X[,1]+intercept
X =cbind(X,y) 
class0 = X[which(y == -1),]
class1 = X[which(y == 1),]

plot_ly() %>%
  add_trace(x = X[,1], y = Y1, type = 'scatter', mode = 'lines', name = 'wTx+b')%>%
  add_trace(x = class0[,1],y = class0[,2], type = 'scatter', mode = 'markers',name = 'Class: -1') %>%
  add_trace(x = class1[,1],y = class1[,2], type = 'scatter', mode = 'markers',name = 'Class: 1')%>%
  layout(title = '<b>Iris Data -- SGD-SVM</b>',
         xaxis = list(title = 'Sepal.Length'),
         yaxis = list(title = 'Sepal.Width'))


