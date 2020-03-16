#For reference: http://cs229.stanford.edu/notes-spring2019/cs229-notes7b.pdf

# Installing Packages
list.of.packages <- c("plotly", "matrixcalc", "dplyr", "mvtnorm")
new.packages <- list.of.packages[!(list.of.packages %in% installed.packages()[,"Package"])]
if(length(new.packages)) install.packages(new.packages)

library(mvtnorm)
library(matrixcalc)
library(plotly)
set.seed(1234) #Used for random numbers to be equal for each ran script

##Gaussian Mixtures Model
#Creating 3 class Gaussian distributed data
x1 = rmvnorm(n=100, mean=c(1,1))
x2 = rmvnorm(n=100, mean=c(5,9))
x3 = rmvnorm(n=100, mean=c(10,-1))

X = rbind(x1,x2,x3)
k = 3 #Amount of Classes has to be greater or equal to 2 since the algorithm uses the co-variance

#######################
#Initialize Parameters#
#######################

u = matrix(0,nrow = k, ncol = NCOL(X))
for (i in 1:k){
  randn = runif(NCOL(X), min(X), max(X)) #selecting random numbers for the amount of columns in X
  for (j in 1:NCOL(X)){
    u[i,j]  = randn[j]
  }
}
first_u = u

#Note: Choose random variance for all classes. It doesn't need to be the Identity matrix
Sigma = list()
for (i in 1:k){
  Sigma[[i]] = diag(2)
}

phi = c(rep(100/k,k)) #we are pegging initial posterior probabilites to 0.33; otherwise, at times we can see a distribution that takes all the probability from each data point
w = matrix(0, nrow=NROW(X),ncol = k)

max_iter = 100
tol = 10^(-5) #setting tolerance level for error

#############
#EM Function#
#############

GMM = function(X,u,Sigma,phi,w,k,max_iter,tol) {
  
  #The following function follows a systematic approach by first 
  #doing the E step followed by the M step then caculating the log-likelihood.
  #Once completed with all 3 steps, it caculates if the log_likelhood of new - old
  #is greater than tolerance to end the for loop(Hence convergence) and return u and Sigma.
  
  loglike = list()
  error = list()
  u_list = list() #To hold u values for plotting
  Sigma_list = list() #To hold Sigma matrix for plotting
  
  for(iter in 1:max_iter){
    
    ##########
    ##E-Step##
    ##########
    
    # calculate w_j^{(i)}
    for (i in 1:NROW(X)){
      ithTotal = 0
      for (j in 1:k){
        multinormal = phi[[j]]*(1/((2*pi)^(length(u[j,])/2)*sqrt(det(Sigma[[j]])))*exp( -1/2 * t(matrix((X[i,] - u[j,]))) %*% matrix.inverse(Sigma[[j]]) %*% matrix(X[i,] - u[j,]) ))
        w[i, j] = multinormal
        ithTotal = ithTotal + multinormal
      }
      w[i,] = w[i,]/as.numeric(ithTotal) #Probability belonging to what class
    }
    
    ##########
    ##M-Step##
    ##########
    
    for (j in 1:k){
      #u, Sigma, and phi per class
      u_j = matrix(0,ncol = NCOL(X)) 
      Sigma_j = matrix(0, ncol = NCOL(X), nrow = NCOL(X))
      phi[[j]] = 1/NROW(X)*sum(w[,j])
      for (i in 1:NROW(X)){
        u_j = u_j + (X[i,]*w[i,j])
        Sigma_j = Sigma_j + w[i,j]*(matrix((X[i,] - u[j,])) %*% t(matrix(X[i,] - u[j,])) )
      }
      u[j,] = u_j/sum(w[,j])
      Sigma[[j]] = Sigma_j/sum(w[,j])
    }
    u_list[[iter]] = u
    Sigma_list[[iter]] = Sigma
    
    ##################
    ##Log-Likelihood##
    ##################
    
    #Log_likehood =logp(x_1,...,x_m) = sum from i to m of the log * the sum from i to K of p(x_i|k)p(k)
    log_likehood = 0
    for (i in 1:NROW(X)){
      pxkpk = 0
      for (j in 1:k){
        pxkpk =  pxkpk + phi[[j]]*(1/((2*pi)^(length(u[j,])/2)*sqrt(det(Sigma[[j]])))*exp( -1/2 * t(matrix((X[i,] - u[j,]))) %*% matrix.inverse(Sigma[[j]]) %*% matrix(X[i,] - u[j,]) ))
      }
      log_likehood = log_likehood + log(pxkpk)
    }
    
    ###############
    ##Convergence##
    ###############
    
    #Caculating if log-likelihood of new - previous is greater than tolerance. If not, break loop and return
    #u, Sigma, phi, and log-likelihood
    
    loglike[[iter]] = log_likehood
    if (iter == 1) {
      error[[iter]] = NULL
    }else if((iter >= 2) && (loglike[[iter]] - loglike[[(iter-1)]] > tol)){
      error[[iter]] = loglike[[iter]] - loglike[[(iter-1)]] 
    }else if ((iter >= 2) && (loglike[[iter]] - loglike[[(iter-1)]] < tol)){
      break
    }else if (iter == max_iter) {
      return(paste("The EM algorithm did not converge with the current amount of",max_iter, "max iterations", sep = ' '))
    }
  }
  return(list("u" = u, "Sigma" = Sigma,"phi" = phi, "Error History" = error, "U History" = u_list, "Sigma History" = Sigma_list))
}

values = GMM(X,u,Sigma,phi,w,k,max_iter,tol)

############
#Prediction#
############

GMM_pred = function(u,Sigma,phi,X){
  count = 1
  label = array()
  for (i in 1:NROW(X)){ #iterating through each data point
    val_hold = array()
    for (j in 1:NROW(u)){ #iterating per amount of classes (Does not need to be values$u)
      val_hold[[j]] = -1/2*log(det(Sigma[[j]])) - 1/2*t(X[i,]-u[j,])%*%matrix.inverse(Sigma[[j]])%*%(X[i,]-u[j,]) + log(phi[[j]])
    }
    label[[count]] = which(val_hold==max(val_hold)) #Taking argmax and assigning class per data point
    count = count + 1
  }
  return(cbind(X,label)) #combining data set with labels from previous for loop
}

z = GMM_pred(values$u,values$Sigma,values$phi,X)

##########
#Plotting#
##########

#Note: Will need to change for amount of classes
class1 = z[which(z[,NCOL(z)] == 1),] 
class2 = z[which(z[,NCOL(z)] == 2),]
class3 = z[which(z[,NCOL(z)] == 3),]

#Initial Plot
p_1 = plot_ly()%>%
  add_trace(x = x1[,1], y = x1[,2], type = 'scatter', mode = 'markers',showlegend = F, marker = list(color = '#5499C7')) %>%
  add_trace(x = x2[,1], y = x2[,2], type = 'scatter', mode = 'markers',showlegend = F, marker = list(color = '#5499C7')) %>%
  add_trace(x = x3[,1], y = x3[,2], type = 'scatter', mode = 'markers',showlegend = F, marker = list(color = '#5499C7'))

p_2 = plot_ly()%>%
  add_trace(x = x1[,1], y = x1[,2], type = 'scatter', mode = 'markers',showlegend = F, marker = list(color = '#5499C7')) %>%
  add_trace(x = x2[,1], y = x2[,2], type = 'scatter', mode = 'markers',showlegend = F, marker = list(color = '#5499C7')) %>%
  add_trace(x = x3[,1], y = x3[,2], type = 'scatter', mode = 'markers',showlegend = F, marker = list(color = '#5499C7')) %>%
  add_trace(x = first_u[1,1], y = first_u[1,2], type = 'scatter', mode = 'markers', name = 'Centroid: 1',marker = list(size = 15, color = '#7DCEA0')) %>%
  add_trace(x = first_u[2,1], y = first_u[2,2], type = 'scatter', mode = 'markers', name = 'Centroid: 2',marker = list(size = 15, color = '#F7DC6F')) %>%
  add_trace(x = first_u[3,1], y = first_u[3,2], type = 'scatter', mode = 'markers', name = 'Centroid: 3',marker = list(size = 15, color = '#D35400'))

p_3 = plot_ly()%>%
  add_trace(x = class1[,1], y = class1[,2], name = 'Class: 1' ,type = 'scatter', mode = 'markers', marker = list(color = '#0B5345')) %>%
  add_trace(x = class2[,1], y = class2[,2], name = 'Class: 2' ,type = 'scatter', mode = 'markers', marker = list(color = '#9A7D0A')) %>%
  add_trace(x = class3[,1], y = class3[,2], name = 'Class: 3' ,type = 'scatter', mode = 'markers', marker = list(color = '#F0B27A')) %>%
  add_trace(x = values$u[1,1], y = values$u[1,2], showlegend = F, type = 'scatter', mode = 'markers', name = 'Centroid 1',marker = list(size = 15, color = '#7DCEA0')) %>%
  add_trace(x = values$u[2,1], y = values$u[2,2], showlegend = F, type = 'scatter', mode = 'markers', name = 'Centroid 2',marker = list(size = 15, color = '#F7DC6F')) %>%
  add_trace(x = values$u[3,1], y = values$u[3,2], showlegend = F, type = 'scatter', mode = 'markers', name = 'Centroid 3',marker = list(size = 15, color = '#D35400')) %>%
  hide_colorbar()

subplot(p_1,p_2,p_3) %>%
  layout(title = 'Beginning, Random Initilization, and End: GMM Algorithm',
         legend = list(orientation = 'h', y = -0.2, x = 0))

