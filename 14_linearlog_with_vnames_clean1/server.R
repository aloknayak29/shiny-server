library(shiny)

shinyServer(function(input, output) {
  dbool <- FALSE
  
  output$contents <- renderTable({
    head(gdf, 10)
  })
  
  output$lm_output <- renderPrint({
    ana <- input$analysis
    xnames <- input$xvars
    yvariable <- input$yvar
    if(!is.null(xnames)){
      x <- gdf
      print(xnames)      
      print(yvariable)
      ytext <- paste(yvariable,"~")
      fmla <- as.formula(paste(ytext, paste(xnames, collapse= "+")))
      print(fmla)
      if(ana == 'linear regression'){
        fit <- lm(fmla, x, na.action=na.omit)
        print(summary(fit))
      }
      else if(ana == 'logistic regression'){
        logfit <- glm(fmla, x, na.action=na.omit, family = "binomial")
        print(summary(logfit))
      }
    }
    else
      print('ANALYSIS WILL APPEAR HERE') 
  })
})
