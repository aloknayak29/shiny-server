library(shiny)

bool <- T
cnames <- names(iris)
tryCatch({gdf <<- read.csv("/media/baremetal/shared/alok/shiny-apps/datafile.csv", header=T)}, error = function(e) bool <<- F)
if(bool) cnames <- names(gdf)

shinyUI(pageWithSidebar(
  headerPanel("Upload file before using this APP"),
  sidebarPanel(
    checkboxGroupInput("xvars", "Choose x variables", cnames),
    selectInput("yvar", "Choose y variable:", 
                choices = cnames),
    selectInput("analysis", "Choose analysis type", 
                choices = c('linear regression','logistic regression')),
    submitButton("Update View")
  ),
  mainPanel(
    verbatimTextOutput('lm_output'),
    tableOutput('contents')
  )
))
