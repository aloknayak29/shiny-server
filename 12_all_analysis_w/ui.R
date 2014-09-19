library(shiny)

shinyUI(pageWithSidebar(
  headerPanel("Uploading Files"),
  sidebarPanel(
    tags$hr(),
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
