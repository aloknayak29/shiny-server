library(shiny)

shinyUI(pageWithSidebar(
  headerPanel("Uploading Files"),
  sidebarPanel(
    fileInput('file1', 'Choose CSV File',
              accept=c('text/csv', 'text/comma-separated-values,text/plain')),
    tags$hr(),
    checkboxInput('header', 'Header', TRUE),
    radioButtons('sep', 'Separator',
                 c(Comma=',',
                   Semicolon=';',
                   Tab='\t'),
                 'Comma'),
    radioButtons('quote', 'Quote',
                 c(None='',
                   'Double Quote'='"',
                   'Single Quote'="'"),
                 'Double Quote'),
    selectInput("analysis", "Choose analysis type", 
                choices = c('linear regression','logistic regression')),
    checkboxGroupInput("xvars", "Choose x variables", as.character(1:15)),
    selectInput("yvar", "Choose y variable:", 
                choices = as.character(c(1:15))),
    submitButton("Update View")
  ),
  mainPanel(
    verbatimTextOutput('lm_output'),
    tableOutput('contents')
  )
))
