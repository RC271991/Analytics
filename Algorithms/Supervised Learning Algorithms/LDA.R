#For reference: https://www.youtube.com/watch?v=OaIIr29Pj2g and https://web.stanford.edu/class/stats202/content/lec9.pdf
## Linear Discriminant Anlaysis
list.of.packages <- c("plotly", "matrixcalc", "dplyr")
new.packages <- list.of.packages[!(list.of.packages %in% installed.packages()[,"Package"])]
if(length(new.packages)) install.packages(new.packages)

library(matrixcalc)#used for matrix inverse
library(plotly)
set.seed(1) #Setting random generator so results are same for each script instance

#Date Clean-Up
df = iris
df$Species = as.integer(df$Species) #turning factors into integers

#Assigning X matrix and labels
X = cbind(matrix(df[,1]), matrix(df[,2]))
y = df[,5]

LDA = function(X,y){
  
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

  Sigma = cov(X) #Assumming all classes have same Co-Variance
  b_list = list()
  w_list = list()
  count = 1
  #log(p(x|y=i)*p(y=i)/p(x/y=j)*p(y=j))
  for (i in 1:(length(unique(y))-1)){
    for (j in 2:length(unique(y))){
      if (i == (length(unique(y))-1) && j == (length(unique(y))-1)){
        next #Note: I only need 3 cases based on amount of classes
      }else{
        b_list[[count]] = -1/2*(t(u[i,])%*%matrix.inverse(Sigma)%*%u[i,] - t(u[j,])%*%matrix.inverse(Sigma)%*%u[j,])  +  log(phi[[i]])-log(phi[[j]])
        w_list[[count]] = (t(u[i,])%*%matrix.inverse(Sigma) - (t(u[j,])%*%matrix.inverse(Sigma)))
        count = count + 1
      }
    }
  }

  #Needed to take list and put into matrix: Not based on algorithm but for my own critque and plotting purposes
  b = matrix(0,nrow = length(unique(y)), ncol = 1)
  w = matrix(0,nrow = length(unique(y)), ncol = NCOL(X))
  for (i in 1:length(w_list)){
    b[i,] = b_list[[i]] 
    for (j in 1:length(w_list[[1]])){
      w[i,j] = w_list[[i]][j]
    }
  }
  
  intercept = list()
  slope = list()
  for (i in 1:NROW(b)){
    intercept[[i]] = -b[i,]/w[i,2]
    slope[[i]] = -w[i,1]/w[i,2]
  }
  intercept = unlist(intercept)
  slope = unlist(slope)
  
  return(list("phi" = phi,"u" = u,"Sigma" = Sigma,"w" = w,"b" = b,"intercept" = intercept,"slope" = slope))
}

values = LDA(X,y) #Calling function

#################################
#Intersection: of all boundaries#
#################################

#Note: Need to change for each data set and amount of classes highlighted by ## at end of line
value1 = c(values$intercept[1],values$slope[1]) ##
value2 = c(values$intercept[2],values$slope[2])##
cm = rbind(value1,value2) # Coefficient matrix
intersect = c(-solve(cbind(cm[,2],-1)) %*% cm[,1])  ##

###############
#Plotting Data#
###############

#Note: This section will need to change based on data and amount of classes
x1 = seq(4,intersect[1], length.out = 10) #plotting data to intersection ##
x2 = seq(intersect[1],8, length.out = 10) #plotting data to intersection ##
x3 = seq(intersect[1],8, length.out = 10) #plotting data to intersection ##

#Extracting lines 
Y1 = values$slope[1]*x1+values$intercept[1]
Y2 = values$slope[2]*x2+values$intercept[2]
Y3 = values$slope[3]*x3+values$intercept[3]

class0 = X[which(y == 1),]
class1 = X[which(y == 2),]
class2 = X[which(y == 3),]

plot_ly() %>%
  add_trace(x = x1, y = Y1, type = 'scatter', mode = 'lines', name = 'Decesion Boundary', line = list(color = "#666666"), fill = 'tonexty', fillcolor = '#D5F5E3')%>%
  add_trace(x = x2, y = Y2, type = 'scatter', mode = 'lines', name = 'Decesion Boundary 2', line = list(color = "#666666"),showlegend = F, fill = 'tozeroy', fillcolor = '#D5F5E3')%>%
  add_trace(x = x3, y = Y3, type = 'scatter', mode = 'lines', name = 'Decesion Boundary 3', line = list(color = "#666666"),showlegend = F, fill = 'tonexty', fillcolor = '#E6B0AA')%>%
  add_trace(x = class0[,1],y = class0[,2], type = 'scatter', mode = 'markers',name = 'Class: 1', marker = list(color = '55B0EA')) %>%
  add_trace(x = class1[,1],y = class1[,2], type = 'scatter', mode = 'markers',name = 'Class: 2', marker = list(color = '#239B56'))%>%
  add_trace(x = class2[,1],y = class2[,2], type = 'scatter', mode = 'markers',name = 'Class: 3', marker = list(color = '#C0392B'))%>%
  layout(title = '<b>Iris Data: LDA</b>',
         xaxis = list(title = 'Sepal.Length'),
         yaxis = list(title = 'Sepal.Width'),
         legend = list(orientation = 'h', y = -0.2, x = 0))

############
#Prediction#
############

m = sample(nrow(X),15)
NewData = X[m,] #Note: I am taking random data from train set but you are suppose to do 80/20 split of actual data and predict on 20% split

LDA_predict = function(phi,u,Sigma, NewData){
  #Taking argmax: per class
  pred = matrix(0, nrow = NROW(NewData), ncol = NROW(u))
  for (i in 1:NROW(u)){
    for (j in 1:NROW(NewData)){
      pred[j,i] = -1/2*( t(u[i,])%*%matrix.inverse(Sigma)%*%(u[i,])) + t(NewData[j,])%*%matrix.inverse(Sigma)%*%(u[i,]) + phi[[i]] 
    }
  }
  predN = data.frame(pred)
  colnames(predN) = c(1:NROW(u)) #Naming class per based on number of classes in y
  predN = as.numeric(colnames(predN)[apply(predN,1,which.max)]) #Taking argmax per class
  return(list("Prediction Values" = pred,"Prediction results" = predN))
}
pred=LDA_predict(values$phi,values$u,values$Sigma,NewData)

##
#Comparing results to Caret/Mass (packages) LDA function:
library(caret)
library(MASS)

train = iris
train = train[,c(1,2,5)] #Getting same data
lda.fit = train(Species ~ ., data=train, method="lda") #calling function from the MASS package
colnames(NewData) = c('Sepal.Length', 'Sepal.Width')
results = predict(lda.fit,NewData)
ans_1 = paste('Library Results:',length(which(as.numeric(results) == y[m]))/length(y[m])*100, '%',sep='')
ans_2 = paste(':: Developed Algorithm:',length(which(pred$`Prediction results` == y[m]))/length(y[m])*100, '%',sep='')
paste(ans_1,ans_2)
