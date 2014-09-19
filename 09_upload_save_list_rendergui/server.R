library(shiny)
html <- "<a href='/14_linearlog_with_vnames_clean2/'> Click this link for analysis</a>"
dir_loc <- "/media/baremetal/shared/alok/shiny-apps/"
shinyServer(function(input, output) {
  output$contents <- renderTable({
    uds <- input$udataset
    if((!is.null(uds)) && uds != 'None'){
      file.copy(paste(dir_loc, uds, sep=''), "/media/baremetal/shared/alok/shiny-apps/datafile.csv", overwrite=T)
    }
    # input$file1 will be NULL initially. After the user selects and uploads a 
    # file, it will be a data frame with 'name', 'size', 'type', and 'datapath' 
    # columns. The 'datapath' column will contain the local filenames where the 
    # data can be found.

    inFile <- input$file1

    if (is.null(inFile))
      return(NULL)
    
    df <- read.csv(inFile$datapath, header=input$header, sep=input$sep, quote=input$quote)
    file_loc <- paste(dir_loc, inFile$name, sep='')
    dnames <<- c(dnames, inFile$name)
    print("file1 present")
    write.csv(df, "/media/baremetal/shared/alok/shiny-apps/datafile.csv", row.names=F)
    file.copy("/media/baremetal/shared/alok/shiny-apps/datafile.csv", file_loc,overwrite=T)
    head(df,20)
  })
  
  output$link <- renderText({
    if(is.null(input$file1)) return(NULL) else return(HTML(html))
  })

  output$dui_si  <- renderUI({
    selectInput("udataset", "Choose previously uploaded datase", 
                choices = dnames)
  }) 
})
