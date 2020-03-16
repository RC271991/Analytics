
# Installing packages
list.of.packages <- c("plotly", "matrixcalc", "dplyr", "mvtnorm")
new.packages <- list.of.packages[!(list.of.packages %in% installed.packages()[,"Package"])]
if(length(new.packages)) install.packages(new.packages)

library(mvtnorm)
library(plotly)
library(matrixcalc)
library(dplyr)

set.seed(88) #setting random numbers so plots can be the same for each ran script
#K-Nearest Neighbors - Classification

#Creating 2 classes
x1 = rmvnorm(n=100, mean=c(1,1))
x2 = rmvnorm(n=100, mean=c(2,2))
k = 11 #Can modify K to select k closest points. Note: Use cross validation to select best K. Note: Remember bias and variance trade-off with the higher amount of k
#Note: Select odd amount of k's otherwise developed algroithm may fail on duplicate amount of class predictions

X = rbind(x1,x2)
label1 = rep(0,100) #labeling data
label2 = rep(1,100)
labels = rbind(matrix(label1),matrix(label2))
X = cbind(X,labels)

ind = sample(seq_len(nrow(X)),size = 160)  #sample function randomly selects rows from X
train =X[ind,] #creates the training dataset with row numbers stored in ind
test=X[-ind,]

KNN = function(train,test, k){
  #The following function takes the K nearest neighbors and classifies the test data
  #based on the distance from the data point and data points in the train set.
  
  pred = list() #prediction list: returning from function
  for (i in 1:NROW(test)){
    sample = test[i,1:(NCOL(X)-1)]
    
    ######################
    ##Euclidean Distance##
    ######################
    
    d = list()
    for (j in 1:NROW(train)){
      d[[j]] = sqrt((sample[1] - train[j,1])^2 + (sample[2] - train[j,2])^2)
    }
    d = unlist(d)
    
    ###############
    ##Predictions##
    ###############
    
    a = sort(d)[1:k] #finding smallest values from euclidean distance
    rows = match(a,d) #Matching index in list "d" that contains all distances from train set
    ans = train[c(rows),NCOL(X)] #Selecting Classification column: Taking last column of X
    tab = table(ans) #table is a r base function that counts amount of duplicates
    label_sample = names(which(tab == max(tab))) #getting the name of the tab variable to input into test[i,] to label data point
    pred[[i]] = label_sample
  }
  Data = cbind(test[,1],test[,2],as.numeric(unlist(pred)),as.numeric(unlist(pred)) == test[,3]) #Combining Test set with predicted classification with KNN
  return(list("Data" = Data,"Predicted Class" = as.numeric(unlist(pred))))
}

values = KNN(train,test,k)#Calling KNN function

#################
##Accuracy Rate##
#################

Accuracy = paste(table(values$`Predicted Class` == test[,3])['TRUE'][[1]]/NROW(test)*100 , "%",sep ='') #Counting amount of Correctly classified
paste("K-Nearest Neighbors with K =",k,"models the data with the following classification Accuracy:", Accuracy, sep = ' ')

############
##Plotting##
############

class0 = train[train[,NCOL(X)] == 0,]
class1 = train[train[,NCOL(X)] == 1,]

classT0 = test[test[,NCOL(X)] == 0,]
classT1 = test[test[,NCOL(X)] == 1,]

pred0 = values$Data[values$Data[,NCOL(X)] == 0,]#Predicted values
pred1 = values$Data[values$Data[,NCOL(X)] == 1,]

corr0 = pred0[pred0[,4] == 1,] #correctly classified
corr1 = pred1[pred1[,4] == 1,]

incorr0 = pred0[pred0[,4] == 0,] #incorrectly classified
incorr1 = pred1[pred1[,4] == 0,]

p1 = plot_ly()%>%
  add_trace(x = class0[,1], y = class0[,2], type = 'scatter',name = 'Train: 0', mode = 'markers', marker = list(color = '#FFFFFF',line = list(color = '#5499C7',width = 1))) %>%
  add_trace(x = class1[,1], y = class1[,2], type = 'scatter',name = 'Train: 1', mode = 'markers', marker = list(color = '#FFFFFF',line = list(color = '#F7DC6F',width = 1)))
  
p2 = plot_ly()%>%
  add_trace(x = class0[,1], y = class0[,2], type = 'scatter', mode = 'markers',showlegend = F, marker = list(color = '#FFFFFF',line = list(color = '#5499C7',width = 1))) %>%
  add_trace(x = class1[,1], y = class1[,2], type = 'scatter', mode = 'markers',showlegend = F, marker = list(color = '#FFFFFF',line = list(color = '#F7DC6F',width = 1))) %>%
  add_trace(x = classT0[,1], y = classT0[,2], type = 'scatter', mode = 'markers',showlegend = F, marker = list(color = '#5499C7',size = 8)) %>%
  add_trace(x = classT1[,1], y = classT1[,2], type = 'scatter', mode = 'markers',showlegend = F, marker = list(color = '#F7DC6F',size = 8))

p3 = plot_ly()%>%
  add_trace(x = class0[,1], y = class0[,2], type = 'scatter', mode = 'markers',showlegend = F, marker = list(color = '#FFFFFF',line = list(color = '#5499C7',width = 1))) %>%
  add_trace(x = class1[,1], y = class1[,2], type = 'scatter', mode = 'markers',showlegend = F, marker = list(color = '#FFFFFF',line = list(color = '#F7DC6F',width = 1))) %>%
  add_trace(x = pred0[,1], y = pred0[,2], name = 'Predicted: 0', type = 'scatter', mode = 'markers', marker = list(color = '#5499C7',size = 8)) %>%
  add_trace(x = pred1[,1], y = pred1[,2], name = 'Predicted: 1', type = 'scatter', mode = 'markers', marker = list(color = '#F7DC6F',size = 8)) %>%
  add_trace(x = corr0[,1], y = corr0[,2], name = 'Correct: 0', type = 'scatter', mode = 'markers', marker = list(color = '#5499C7',size = 8, line = list(color = '#2ECC71', width = 2))) %>%
  add_trace(x = corr1[,1], y = corr1[,2], name = 'Correct: 1', type = 'scatter', mode = 'markers', marker = list(color = '#F7DC6F',size = 8, line = list(color = '#2ECC71', width = 2))) %>%
  add_trace(x = incorr0[,1], y = incorr0[,2], name = 'Incorrect: 0', type = 'scatter', mode = 'markers', marker = list(color = '#5499C7',size = 8, line = list(color = '#E74C3C', width = 2))) %>%
  add_trace(x = incorr1[,1], y = incorr1[,2], name = 'Incorrect: 1', type = 'scatter', mode = 'markers', marker = list(color = '#F7DC6F',size = 8, line = list(color = '#E74C3C', width = 2)))

subplot(p1,p2,p3) %>%
  layout(title = '<b>KNN Classification: Train, Predicted Data, Correct vs. Incorrect</b>',
         legend = list(orientation = 'h', y = -0.1, x = 0))
