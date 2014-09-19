library(shiny)

shinyServer(function(input, output) {
  dbool <- FALSE
  df <- function(){ 
    if (!is.null(gdf))
      dbool <<- TRUE
    return(gdf)   
  }
  output$contents <- renderTable({
    
    # input$file1 will be NULL initially. After the user selects and uploads a 
    # file, it will be a data frame with 'name', 'size', 'type', and 'datapath' 
    # columns. The 'datapath' column will contain the local filenames where the 
    # data can be found.
    df()
  })
  output$lm_output <- renderPrint({
    temp1 <- input$xvars
    temp2 <- input$yvar
    if(dbool == TRUE) {
      x <- df()
      xnamesall <- names(x)
      xnames <- xnamesall[as.integer(input$xvars)]
      print(xnames)
      print(input$yvar)
      yvariable <- xnamesall[as.integer(input$yvar)]
      
      print(yvariable)
      ytext <- paste(yvariable,"~")
      fmla <- as.formula(paste(ytext, paste(xnames, collapse= "+")))
      #print(fmla)
      logfit <- glm(fmla, x, na.action=na.omit, family = "binomial")
      print(summary(logfit))
    }
    else
      print('ANALYSIS WILL APPEAR HERE') 
  })
})
