#For reference: https://www.youtube.com/watch?v=OaIIr29Pj2g 
## Quadratic Discriminant Anlaysis

library(matrixcalc)#used for matrix inverse
library(plotly)

#Date Clean-Up
df = iris
df$Species = as.integer(df$Species) #turning factors into integers

#Assigning X matrix and labels
X = cbind(matrix(df[,1]), matrix(df[,2]))
y = df[,5]

QDA = function(X,y) {
  
    #######
    ##Phi##
    #######
    phi = list()
    for (i in 1:length(unique(y))){
      phi[[i]] = length(y[y==i])/length(y)
    }
    
    #################
    #Mean: Variables#
    #################
    
    u = matrix(0,nrow = length(unique(y)), ncol = NCOL(X))
    for (i in 1:length(unique(y))){
      for (j in 1:NCOL(X)){
        u[i,j]  = sum(X[c(which(y == i)),j])/NROW(X[c(which(y == i)),j])
      }
    }
    
    #####################
    #Sigma (Co-Variance)#
    #####################
    
    #In QDA: We arn't assuming that each class as similar distribution. Hence, we are taking a seperate Cov-variance for each class
    Sigma = list()
    X_new = X
    for (i in 1:length(unique(y))){
      Sigma[[i]] =  cov(X_new[c(which(y == i)),])
    }
    return(list("phi" = phi, "u" = u, "Sigma" = Sigma))
  }

values = QDA(X,y) #calling function to get phi, u, and Sigma

###########################
#Prediction and Boundaries#
###########################

QDA_pred = function(u,Sigma,phi,X){
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

#Setting grid for plot
#Note: This will change per data. So, plot data ahead of time to get x and y boundaries.
x2 <- seq(4,8,0.02)
y2 <- seq(1.8,4.5,0.02)
z <- as.matrix(expand.grid(x2,y2),0) #creating matrix to run QDA_pred function to acquire contour plot of each class;however, if we just want to predict onto test set just set z as test set

z = QDA_pred(values$u,values$Sigma,values$phi,z)

##########
#Plotting#
##########

#Grabbing each class for plot
#Note: Will need to change based on amount of classes per data set
class0 = X[which(y == 1),]
class1 = X[which(y == 2),]
class2 = X[which(y == 3),]

plot_ly() %>%
  add_trace(x = z[,1],y = z[,2],z = z[,3], type = 'contour', colorscale = 'Portland',name = 'Class Boundary', showlegend = F)%>%
  add_trace(x = class0[,1],y = class0[,2], type = 'scatter', mode = 'markers',name = 'Class: 1', marker = list(color = '55B0EA')) %>%
  add_trace(x = class1[,1],y = class1[,2], type = 'scatter', mode = 'markers',name = 'Class: 2', marker = list(color = '#239B56'))%>%
  add_trace(x = class2[,1],y = class2[,2], type = 'scatter', mode = 'markers',name = 'Class: 3', marker = list(color = '#E6B0AA'))%>%
  layout(title = '<b>Iris Data: QDA</b>',
         xaxis = list(title = 'Sepal.Length'),
         yaxis = list(title = 'Sepal.Width'),
         legend = list(orientation = 'h', y = -0.2, x = 0)) %>%
  hide_colorbar()

  

