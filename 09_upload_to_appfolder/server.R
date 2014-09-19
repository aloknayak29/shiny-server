library(shiny)
html <- "<a href='/14_linearlog_with_vnames_clean2/'> Click this link for analysis</a>"
shinyServer(function(input, output) {
  output$contents <- renderTable({
    
    # input$file1 will be NULL initially. After the user selects and uploads a 
    # file, it will be a data frame with 'name', 'size', 'type', and 'datapath' 
    # columns. The 'datapath' column will contain the local filenames where the 
    # data can be found.

    inFile <- input$file1

    if (is.null(inFile))
      return(NULL)
    
    df <- read.csv(inFile$datapath, header=input$header, sep=input$sep, quote=input$quote)
    write.csv(df, "/srv/shiny-server/15_ana_with_vnames_samefolder/datafile.csv", row.names=F)
    head(df,20)
  })
  
  output$link <- renderText({
    if(is.null(input$file1)) return(NULL) else return(HTML(html))
  })   
})
