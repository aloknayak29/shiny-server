library(shiny)

shinyUI(pageWithSidebar(
  headerPanel("Uploading Files"),
  sidebarPanel(
    selectInput("udataset", "Choose previously uploaded datase", 
                choices = dnames),
    submitButton("choose dataset"),
    tags$hr(),
    fileInput('file1', 'Choose CSV File',
              accept=c('text/csv', 'text/comma-separated-values,text/plain', '.csv')),
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
                 'Double Quote')
  ),
  mainPanel(
    htmlOutput("link"),
    tableOutput('contents')
  )
))
