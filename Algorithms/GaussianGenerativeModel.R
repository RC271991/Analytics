#For refernce: Variables phi, u0,u1, and Sigma are from http://cs229.stanford.edu/notes/cs229-notes2.pdf

library(matrixcalc)#used for matrix inverse

#Date Clean-Up
df = iris
df = df[df$Species != 'versicolor',]
df$Species = as.integer(df$Species)
df$Species[df$Species == 1] = 0
df$Species[df$Species == 3] = 1

#Assigning X matrix and labels
X = cbind(matrix(df[,1]), matrix(df[,3]))
y = df[,5]

GaussianGenerativeAnalysis = function(X,y) {
  
  #######
  ##Phi##
  #######

  phi = length(y[y==1])/length(y)
  
  #############
  ##U0 and #U1#
  #############
  
  u0 = list()
  u1 = list()
  for (i in 1:NCOL(X)){
    u0[[i]] = sum(X[c(which(y == 0)),i])/NROW(X[c(which(y == 0)),i])
    u1[[i]] = sum(X[c(which(y == 1)),i])/NROW(X[c(which(y == 1)),i])
  }
  u0 = matrix(unlist(u0))
  u1 = matrix(unlist(u1))
  
  #####################
  #Sigma (Co-Variance)#
  #####################
  
  index = 1
  sigma = list()
  X_new = X
  for (i in 1:NCOL(X_new)){
    #Subtracting u0 &u1 from each class per independent variable
    X_new[c(which(y == 0)),i]  = X_new[c(which(y == 0)),i] - u0[i,1]
    X_new[c(which(y == 1)),i]  = X_new[c(which(y == 1)),i] - u1[i,1]
    for (j in 1:NCOL(X_new)){
      m = NCOL(X_new)
      numerator = sum(X_new[,i]*t(X_new[,j]))
      sigma[[index]] = numerator/m
      index = index+1
    }
  }
  sigma = unlist(sigma)
  sigma = matrix(sigma, nrow = NCOL(X_new), ncol = NCOL(X_new))
  
  ############
  #Prediction#
  ############
  
  #Probablilty of p(x|y=0)*p(y) and p(x|y=1)*p(y)
  x = matrix(c(4.5,4.7,5.8,6,7,8,
               1.5,2,3.6,6,6,5.5), nrow = 6,ncol = 2)
  u0 = matrix(u0, nrow = 1, ncol = NCOL(X_new))
  u1 = matrix(u1, nrow = 1, ncol = NCOL(X_new))
  
  #Predicting Class
  Pxy0Py = list()
  Pxy1Py = list()
  for (i in 1:NROW(x)){
    Pxy0Py[[i]] = phi*(1/((2*pi)^(length(u0)/2)*sqrt(det(sigma)))*exp( -1/2 * t(matrix((x[i,] - u0))) %*% matrix.inverse(sigma) %*% matrix(x[i,] - u0) ))
    Pxy1Py[[i]] = phi*(1/((2*pi)^(length(u1)/2)*sqrt(det(sigma)))*exp( -1/2 * t(matrix((x[i,] - u1))) %*% matrix.inverse(sigma) %*% matrix(x[i,] - u1) ))
  }
  Pxy0Py = unlist(Pxy0Py)
  Pxy1Py = unlist(Pxy1Py)
  
  pred = list()
  maxVals = pmax(Pxy1Py, Pxy0Py) #argmax
  for (i in 1:length(maxVals)){
    if (Pxy1Py[i] == maxVals[i]) {
      pred[[i]] = 1
    } 
    else{
      pred[[i]] = 0
    }
  }
  pred = unlist(pred)
  return(pred)
}
GaussianGenerativeAnalysis(X,y)


