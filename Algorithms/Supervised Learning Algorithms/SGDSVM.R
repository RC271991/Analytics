#SGD on linear seperable data

# Installing Packages
list.of.packages <- c("plotly", "matrixcalc", "dplyr")
new.packages <- list.of.packages[!(list.of.packages %in% installed.packages()[,"Package"])]
if(length(new.packages)) install.packages(new.packages)

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
  iter = 1000
  
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

##############
##Prediction##
##############

vals = c(5,6,6,4,5,7,
         2,3,4,2,2.7,4.4)
NewData = matrix(vals,nrow = 6, ncol = 2)

SGD_pred = function(NewData, alg){
  pred = list()
  for (i in 1:NROW(NewData)){
    pred[[i]] = t(alg$w)%*%NewData[i,] + alg$b
    if (pred[[i]] < 0) {
      pred[[i]] = -1
    }else{
      pred[[i]] = 1
    }
  }
  return(cbind(NewData, unlist(pred)))
}

NewData = SGD_pred(NewData, values) #calling SGD_pred function. Note: This is used for the test set data. Usually, 80/20 split

NewData1 = NewData[NewData[,3] == -1,]
NewData2 = NewData[NewData[,3] == 1,]

intercept = -values$b/values$w[2] 
slope = -values$w[1]/values$w[2]

#y =mx+b
Y1 = slope*X[,1]+intercept
X =cbind(X,y) 
class0 = X[which(y == -1),]
class1 = X[which(y == 1),]

############
##Plotting##
############

p1 = plot_ly() %>%
  add_trace(x = X[,1], y = Y1, type = 'scatter', showlegend = F, mode = 'lines', name = 'wTx+b', line = list(color = '#1F618D'))%>%
  add_trace(x = class0[,1],y = class0[,2], showlegend = F, type = 'scatter', mode = 'markers',name = 'Class: -1', marker = list(color ='#FFFFFF', line = list(color = '#AF7AC5', width = 1))) %>%
  add_trace(x = class1[,1],y = class1[,2], showlegend = F, type = 'scatter', mode = 'markers',name = 'Class: 1', marker = list(color = '#FFFFFF', line = list(color = '#5499C7', width = 1)))

p2 =  plot_ly() %>%
  add_trace(x = X[,1], y = Y1, type = 'scatter', mode = 'lines', name = 'wTx+b', line = list(color = '#1F618D'))%>%
  add_trace(x = class0[,1],y = class0[,2], type = 'scatter', mode = 'markers',name = 'Class: -1', marker = list(color ='#FFFFFF', line = list(color = '#AF7AC5', width = 1))) %>%
  add_trace(x = class1[,1],y = class1[,2], type = 'scatter', mode = 'markers',name = 'Class: 1', marker = list(color = '#FFFFFF', line = list(color = '#5499C7', width = 1))) %>%
  add_trace(x = NewData1[,1], y = NewData1[,2], type = 'scatter', mode = 'markers', name = 'Predicted: -1', marker = list(color ='#9B59B6')) %>%
  add_trace(x = NewData2[,1], y = NewData2[,2], type = 'scatter', mode = 'markers', name = 'Predicted: 1', marker = list(color = '#1A5276'))

subplot(p1,p2) %>%
  layout(title = '<b>Iris Data -- SGD-SVM:</b> Sepal.Length vs. Sepal.Width',
         legend = list(orientation = 'h', y = -0.1, x = 0))

