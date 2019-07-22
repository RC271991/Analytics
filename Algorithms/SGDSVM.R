#SGD on linear seperable data
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
  alpha = 0.004 #learning rate: Note can adjust learning rate respectively to change hyperplane
  iter = 10000
  
  for (i in 1:iter){
    #shuffling
    X = cbind(X,y)
    X = X[sample(nrow(X)),]
    
    y = X[,3]
    X = X[,1:2]
    epochs = 1/i
    for (j in 1:NROW(X)){
      if (y[j]* (t(w) %*% X[j,]+b) < 1){
        #J(W) = 1/2wTWlambda + sum from i to m of the max of (0,1-yiwTxi) 
        w = w - alpha*((epochs*w) - (X[j,] * y[j]) ) #w_old - (derative respect to line 32)
        b = b + alpha*y[j]
        }
      else{
        w = w - alpha*(epochs*w)
      }
    }
  }
  return(w)
}

w = SGDSVM(X,y)

#Perpendicular line to vector w
m = (w[2,] - 0)/(w[1,] - 0)
m = -1/m

#y = mx+b ==> b = y - mx
b = w[2,] - (m * w[1,])

#x values for line
vec = w[1,]
x = list()
for (i in 1:10){
  x[[i]] = vec
  vec = vec + 1
}
x = unlist(x)
Y = m*x +b

plot_ly() %>%
  add_trace(x = X[,1], y = X[,2], type = 'scatter', mode = 'markers',name = 'Data') %>%
  add_trace(x = c(0,w[1,]), y = c(0,w[2,]), type = 'scatter', mode = 'markers + Line', name = 'w') %>%
  add_trace(x = x, y = Y, type = 'scatter', mode = 'markers + Line', name = 'wTx+b')

