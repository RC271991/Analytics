library(mvtnorm)
library(plotly)
set.seed(1) #Used for random numbers to be equal for each ran script

##K-Means Algorithm
#Creating 3 class distributed data
x1 = rmvnorm(n=100, mean=c(1,1))
x2 = rmvnorm(n=100, mean=c(4,3.8))
x3 = rmvnorm(n=100, mean=c(10,-1))

X = rbind(x1,x2,x3)
k = 3 #Amount of classes

#######################
#Initialize Parameters#
#######################

u = matrix(0,nrow = k, ncol = NCOL(X))
for (i in 1:k){
  randn = runif(NCOL(X), min(X[,1]), max(X[,2])) #selecting random numbers for the amount of columns in X
  for (j in 1:NCOL(X)){
    u[i,j]  = randn[j]
  }
}
first_u = u

KMeans = function(X,u,max_iter,k){
  
  #The following function caculates the centriods based on the k-means
  #algorithm. Note: K-means is suspectible to optimizing on local-minimums.
  #Hence, use cross-validation to select your k class centriods.
  
  u_list = list()
  for (iter in 1:max_iter){
    
    ############
    ##Distance##
    ############
    
    label = list()
    for (i in 1:NROW(X)){
      d = list()
      for (j in 1:k){
        d[[j]] = sqrt((u[j,1]-X[i,1])^2 + (u[j,2]-X[i,2])^2) 
      }
      label[[i]] = which.min(unlist(d))
    }
    ###############
    ##Convergence##
    ###############
    
    u_list[[iter]] = u
    if(iter >= 2 && (unique(u_list[[iter]] == u_list[[iter-1]])[,1]) == T &&  (unique(u_list[[iter]] == u_list[[iter-1]])[,2]) == T){
      break
    }
    
    #################
    ##New Centriods##
    #################
    
    X = cbind(matrix(X[,1]),matrix(X[,2]),matrix(unlist(label)))
    #Assigning new class means
    for (i in 1:k){
      for (j in 1:NCOL(X)-1){
        if (length(X[c(which(X[,3] == i)),j]) == 0){
          u[i,j] = u[i,j] #Added if centriod does not have any assigned data points
        }else{
        u[i,j]  = sum(X[c(which(X[,3] == i)),j])/NROW(X[c(which(X[,3] == i)),j])
        }
      }
    }
  }
  return(list("u" = u, "U list" = u_list, "X" = X, "iterations" = iter))
}

values = KMeans(X,u,1000,k)

############
##Plotting##
############

#Note: Will need to change for amount of classes
class1 = values$X[which(values$X[,NCOL(values$X)] == 1),] 
class2 = values$X[which(values$X[,NCOL(values$X)] == 2),] 
class3 = values$X[which(values$X[,NCOL(values$X)] == 3),] 

p_1 = plot_ly()%>%
  add_trace(x = x1[,1], y = x1[,2], type = 'scatter', mode = 'markers',showlegend = F, marker = list(color = '#5499C7')) %>%
  add_trace(x = x2[,1], y = x2[,2], type = 'scatter', mode = 'markers',showlegend = F, marker = list(color = '#5499C7')) %>%
  add_trace(x = x3[,1], y = x3[,2], type = 'scatter', mode = 'markers',showlegend = F, marker = list(color = '#5499C7'))

p_2 = plot_ly()%>%
  add_trace(x = x1[,1], y = x1[,2], type = 'scatter', mode = 'markers',showlegend = F, marker = list(color = '#5499C7')) %>%
  add_trace(x = x2[,1], y = x2[,2], type = 'scatter', mode = 'markers',showlegend = F, marker = list(color = '#5499C7')) %>%
  add_trace(x = x3[,1], y = x3[,2], type = 'scatter', mode = 'markers',showlegend = F, marker = list(color = '#5499C7')) %>%
  add_trace(x = first_u[1,1], y = first_u[1,2], type = 'scatter', mode = 'markers',showlegend = F,marker = list(size = 15, color = '#7DCEA0')) %>%
  add_trace(x = first_u[2,1], y = first_u[2,2], type = 'scatter', mode = 'markers',showlegend = F,marker = list(size = 15, color = '#F7DC6F')) %>%
  add_trace(x = first_u[3,1], y = first_u[3,2], type = 'scatter', mode = 'markers',showlegend = F,marker = list(size = 15, color = '#D35400'))

p_3 = plot_ly()%>%
  add_trace(x = class1[,1], y = class1[,2],name = 'Class: 1', type = 'scatter', mode = 'markers', marker = list(color = '#0B5345')) %>%
  add_trace(x = class2[,1], y = class2[,2],name = 'Class: 2', type = 'scatter', mode = 'markers', marker = list(color = '#9A7D0A')) %>%
  add_trace(x = class3[,1], y = class3[,2],name = 'Class: 3', type = 'scatter', mode = 'markers', marker = list(color = '#F0B27A')) %>%
  add_trace(x = values$u[1,1], y = values$u[1,2],name = 'Centroid: 1',type = 'scatter', mode = 'markers',marker = list(size = 15, color = '#7DCEA0')) %>%
  add_trace(x = values$u[2,1], y = values$u[2,2],name = 'Centroid: 2', type = 'scatter', mode = 'markers',marker = list(size = 15, color = '#F7DC6F')) %>%
  add_trace(x = values$u[3,1], y = values$u[3,2],name = 'Centroid: 3', type = 'scatter', mode = 'markers',marker = list(size = 15, color = '#D35400'))

subplot(p_1,p_2,p_3) %>%
  layout(title = '<b>K-Means: Beginning, Random Initilization, and End</b>',
         legend = list(orientation = 'h', y = -0.2, x = 0))

