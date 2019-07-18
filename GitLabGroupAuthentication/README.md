# GitLab Oauth2 Group Authentication with R Shiny:

The following github page is made for group authentication using Oauth2. It is designed for Data Scientists or Data Analysts that
want to set up their own user authentication for their company or personal use in the R shiny platform.

The steps of the project verifies that the client is authorized by gitlab's oauth2, then uses the access token to verify that the
client is in your group. If the user is in the group, then the user gets directed to your dashboard. If not, then the user gets
directed to a blank page insisting them to contact the app manager for group request.

To replicate this use case on your project you need to begin with understanding the following documentations from gitLab.

#### Oauth2:
https://docs.gitlab.com/ee/api/oauth2.html

#### Scopes:
https://docs.gitlab.com/ee/user/profile/personal_access_tokens.html

#### Groups:
https://docs.gitlab.com/ee/api/groups.html

#### Shiny's ClientData:
https://shiny.rstudio.com/articles/client-data.html

The following steps of the project include:

1) Define redirect url, client id, client secret, and scope
2) Create different Ui's based on group approval
3) Create server file that contains api's from gitlab to app which includes user authentication and group authentication

#### Note: 
Each file goes in-depth on what is occuring on each line of code. I did this for people who may not be strong in
the DevOps side of user authentication.
