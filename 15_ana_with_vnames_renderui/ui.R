library(shiny)

shinyUI(pageWithSidebar(
  headerPanel("Upload file before using this APP"),
  sidebarPanel(
    uiOutput("dui_cb"),
    uiOutput("dui_dd"),
    selectInput("panalysis", "Choose analysis type", 
                choices = c('None','linear regression','logistic regression')),
    selectInput("eanalysis", "Choose analysis type", 
                choices = c('None','pca','correlation','heir. clustering','kmeans clustering','factor analysis')),
    textInput("an_number", "Choose number of factors/clusters:", value = 4),
    submitButton("Update View")
  ),
  mainPanel(
    #verbatimTextOutput('lm_output'),
    #plotOutput("clustplot"),
    tabsetPanel( 
      tabPanel("Predictive analysis", verbatimTextOutput("pana_output")),
      tabPanel("Exploratory Analysis", verbatimTextOutput("eana_output")),
      tabPanel("Plot", plotOutput("clustplot")),
      tabPanel("Table", tableOutput("contents"))
    )
  )
))
