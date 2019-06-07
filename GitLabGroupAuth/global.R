library(shinydashboard)
library(shiny)
library(jsonlite)
library(httr)
library(shinyjs)

#Insert your app url
App_url = "https://my_app_name.my_company.com"

#Insert client key and secret: It can be found in the setting tabs under CI/CD - Environment variables
#Note: These are made up id's and secrets's
client_key = "fsefev424234234234gdgdfgdfgdfgdgfdgacrrw"
client_secret = "fsfwfwfsgnbnjnj1n1j4njn14j41j1j4j56456"

app = oauth_app(appname = "my_app_name", #insert your app name under App_url
                key = client_key,
                secret = client_secret,
                redirect_uri = App_url)

#Select scope: I selected 'api' because it gives me access to my developed
#group authentication. Note: It grants a lot more access to your users.

#Documentation can be found at: https://docs.gitlab.com/ee/user/profile/personal_access_tokens.html
scope = "api"

#Developing functions to check if user has gitlab's authorization token and is in your created group

has_oauth2 = function(x) {
  #Verfying that gitlab's token exist once authentication is approved or disapproved
  #Note: Url should contain code if gitlab autorized user. If it
  #is not there, then the user does not have access to your company's gitlab repository.
  #An example of the url from gitlab's response: 
  #https://my_app_name.my_company.com?code=23123124fvsv2r3r2f2f2f2f2
  if (is.null(x$code) == T) {
    ans = 'Empty'
  }
  else{
    ans = "Filled"
  }
  return(ans)
}

has_group = function(x){
  #Verfying if user is assigned to your group
  #Documentation: https://docs.gitlab.com/ee/api/groups.html
  if (x$Name != 'your_group') { #your_group is the name of the group in gitlab
    ans = 'No'
  }
  else {
    ans = 'Yes'
  }
  return(ans)
}

