#reference: https://pdfs.semanticscholar.org/59ee/e096b49d66f39891eb88a6c84cc89acba12d.pdf
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
Y = df[,5]
K = X %*% t(X) #linear kernel: Note model can be applied with gaussian or polynomial kernel

SMOSVM = function(X,Y,K){
  alphas = rep(0, NROW(X))
  C = 1.2 #By changing C will effect placement of hyperplane
  b = 0
  eps = 10^(-5)
  maxiter = 1000
  count = 0
  
  while (count < maxiter) {
    changed_alphas <- 0
    for (i in 1:NROW(X)){
      y1 = Y[i]
      E1 = b + sum(alphas*Y*K[,i]) - y1
      if((y1*E1 < -eps & alphas[i] < C) || (y1 >  eps & alphas[i] > 0)) {
        #i!=j according to algorithm 
        j = sample(nrow(X),1)
        ans = T
        while (ans == T) {
          j = sample(nrow(X),1)
          if (j != i){
            ans = F
          }
        }
        y2 = Y[j]
        E2 = b + sum(alphas * Y * K[,j]) - y2
        s = y1*y2
        
        #Computing L and H
        alpha1 = alphas[i]
        alpha2 = alphas[j]
        if (y1 != y2) {
          L = max(0, alphas[j]-alphas[i])
          H = min(C, C + alphas[j]-alphas[i])
        }else{
          L = max(0, alphas[j]+alphas[i]-C)
          H = min(C, alphas[j]+alphas[i])
        }
        if (L == H) {
          next
        }
        
        #####
        #eta#
        #####
        
        kii = K[i,i]
        kjj = K[j,j]
        kij = K[i,j]
        eta = 2 * kij - kii - kjj
        if (eta >= 0) {
          next
        }
        
        ########
        #Alphas#
        ########
        
        #Computing new alpha
        alphas[j] = alphas[j] - y2 * (E1 - E2)/eta
        #Clipping
        alphas[j] = min(H, alphas[j])
        alphas[j] = max(L, alphas[j])
        if (abs(alphas[j]-alpha2) < eps){
          alphas[j] = alpha2
          next
        }
        alphas[i] = alphas[i]+s*(alpha2-alphas[j])
        
        ######
        #Bias#
        ######
        
        b1 = b - E1-y1*(alphas[i]-alpha1)*kij-y2*(alphas[j]-alpha2)*kij
        b2 = b - E2-y1*(alphas[i]-alpha1)*kij-y2*(alphas[j]-alpha2)*kij
        if ( alphas[i] > 0 && alphas[i] < C) {
          b = b1
        }else if (alphas[j] > 0 && alphas[j] < C) {
          b = b2
        }else {
          b = (b1+b2)/2
        }
        changed_alphas = changed_alphas + 1
      }
    }
    if (changed_alphas == 0) {
      count = count + 1
    }else {
      count =  0
    }
  }
  #solving for w and returning w an b
  index = which(alphas > 0)
  X1 = X[index,]
  Y1 = Y[index]
  alphas1 = alphas[index]
  w = t(alphas1 * Y1) %*% X1

  return(list("w" = w, "b" = b))
}

#Calling function with specified parameters
#Note: What is returned is the w vector and bias b
values = SMOSVM(X,Y,K)

intercept = -values$b/values$w[2] 
slope = -values$w[1]/values$w[2]

#y =mx+b
Y1 = slope*X[,1]+intercept

X =cbind(X,y) 
class0 = X[which(Y == -1),]
class1 = X[which(Y == 1),]

#Plotting data and wTx+b respect to SMO algorithm:
plot_ly() %>%
  add_trace(x = X[,1], y = Y1, type = 'scatter', mode = 'lines', name = 'wTx+b')%>%
  add_trace(x = class0[,1],y = class0[,2], type = 'scatter', mode = 'markers',name = 'Class: -1', marker = list(color = '55B0EA')) %>%
  add_trace(x = class1[,1],y = class1[,2], type = 'scatter', mode = 'markers',name = 'Class: 1')%>%
  layout(title = '<b>Iris Data -- SMO-SVM</b>',
         xaxis = list(title = 'Sepal.Length'),
         yaxis = list(title = 'Sepal.Width'))
