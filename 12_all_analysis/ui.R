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
    #checkboxGroupInput("xvars", "Choose x variables", as.character(1:10)),
    selectInput("analysis", "Choose analysis type", 
                choices = c('pca','correlation','heir. clustering','kmeans clustering','factor analysis')),
    textInput("an_number", "Choose number of factors/clusters:", value = 4),
    submitButton("Update View")
  ),
  mainPanel(
    verbatimTextOutput('lm_output'),
    plotOutput("clustplot"),
    tableOutput('contents')
  )
))
