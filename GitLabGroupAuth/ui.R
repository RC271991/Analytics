source('global.R')

#Creating different ui's based on if user has group authentication

ui1 = div(
  id = "login-page"
)

#Include all your ui: for the developed dashboard
ui2 = hidden(
  div(
    id = "main-page",
    dashboardPage(
      title = "My title",
      dashboardHeader(),
      dashboardSidebar(),
      dashboardBody()
    )
  )
)

#Creating blank page requesting for more information if user is not in group
ui3 = hidden(
  div(
    id = "request-page",
    fluidPage(fluidRow(column(12, align = 'center', br(), br(), br(),br(), br(), br(), br(),br(), br(), br(), br(),br(),
                              h3("Only authorized employees can view dashboard.", align = 'center'),
                              h2("Please contact ... to gain access.", align = 'center')))
    )
  )
)

shinyUI(tagList(useShinyjs(),
                fluidPage(ui1,ui2,ui3)
                )
        )

