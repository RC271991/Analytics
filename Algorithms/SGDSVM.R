#SGD on linear seperable data
#Hard-margin
library(plotly)

#Date Clean-Up
df = iris
df = df[df$Species != 'versicolor',]
df$Species = as.integer(df$Species)
df$Species[df$Species == 1] = -1
df$Species[df$Species == 3] = 1

#Assigning X matrix and labels
X = cbind(matrix(df[,1]), matrix(df[,3]))
y = df[,5]

SGDSVM = function(X,y) {
  
  #Stochastic Gradient Descent
  w = matrix(rep(0,ncol(X)))
  b = 0
  alpha = 0.08#learning rate: Note can adjust learning rate respectively to change hyperplane
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
  values = c(w,b)
  return(values)
}

values = SGDSVM(X,y)

intercept = -values[3]/values[2] 
slope = -values[1]/values[2]

#x values for line
vec = values[1]
x = list()
for (i in 1:10){
  x[[i]] = vec
  vec = vec + 1
}
x = unlist(x)
Y1 = slope*x+intercept

#Plotting data and wTx+b respect to SMO algorithm:
plot_ly() %>%
  add_trace(x = X[1:50,1], y = X[1:50,2], type = 'scatter', mode = 'markers',name = 'Class: -1') %>%
  add_trace(x = X[51:100,1], y = X[51:100,2], type = 'scatter', mode = 'markers',name = 'Class: 1') %>%
  add_trace(x = x, y = Y1, type = 'scatter', mode = 'markers + Line', name = 'wTx+b') %>%
  layout(title = '<b>Iris Data -- SMO-SVM</b>',
         xaxis = list(title = 'Sepal.Length'),
         yaxis = list(title = 'Petal.Length'))