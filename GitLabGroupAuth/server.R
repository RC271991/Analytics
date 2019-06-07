source('global.R')
shinyServer(function(input, output, session) {
  
  #####################
  #User Authentication#
  #####################
  
  #Reading the url from user
  #Documentation: https://shiny.rstudio.com/articles/client-data.html
  parameters = parseQueryString(isolate(session$clientData$url_search))
  
  #Calling function from global.R
  if (has_oauth2(parameters) == 'Empty'){
    return()
  }
  
  resonse_gitlab = httr::POST("https://Your_company's_gitlab_repository/oauth/token",
                              body = list(client_id = client_key,
                                          scope = scope,
                                          redirect_uri = App_url,
                                          grant_type = "authorization_code",
                                          client_secret = client_secret))
  #Gitlab sends a json array containing all needed information such as access_token, scope etc.
  #From Here we will begin our group authentication
  
  ######################
  #Group Authentication#
  ######################
  
  #Step 1: Getting Access token from gitlab's response
  
  response_obj = jsonlite::fromJSON(rawToChar(response_gitlab$content))
  access_token = response_obj[[1]] #In the response_obj the first value should contain the access token. If not, this needs to be the access token that gitlab sends. So, change index if need be.
  
  #Step 2: Connecting api
  
  #Connecting api to gitlab to verify if the user is in the group with access_token recieved from the 'User Authentication' process.
  #A high level understanding is that this step goes to your company's gitlab repository and checks if the user is in the correct group by using groups?search.
  #Documentation: https://docs.gitlab.com/ee/api/groups.html
  
  urlM2 = paste("https://Your_company's_gitlab_repository/api/v4/groups?search=YOUR_GROUP&access_token=", access_token,sep ='') #YOUR_GROUP is your group name. Please, change this part in urlM2
  proInfo = httr::GET(url=urlM2)
  group = jsonlite::fromJSON(rawToChar(proInfo$content))
  
  #Step 3: Ui page determintion based on gitlab's group search
  
  observe({
    #If the user has credientials, then the user gets redirected to your dashboard. If not, the user gets sent to a page
    #asking them to contact the adminstrator of the app to include them into the gitlab's group list.
    
    if (length(group) == 0){ #If the user is not in group then the length of group will be 0 because the response from gitlab will be empty.
      shinyjs::hide(id = "login-page")
      shinyjs::show(id = "request-page")
    }
    else if (has_group(group) == 'Yes') {#User does have group and it is a success!!
      shinyjs::hide(id = "login-page")
      shinyjs::show(id = "main-page")
    }
    
  })
  
})