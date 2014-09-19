library(shiny)
library(ggplot2)
library(reshape2)
library(cluster)

factor_to_num <- function(dataset){
  for (i in 1:ncol(dataset)){
    if (class(dataset[,i])=="factor")
      dataset[,i] <- as.numeric(as.character(dataset[,i]))
  }
  return(dataset)
}

num_dataset <- function(dataset){
  nums <- sapply(dataset,is.numeric)
  dataset <- dataset[,nums]
  return(dataset)
}
correlation <- function ( dataset, type="pearson") {
  numdataset <- num_dataset(dataset)
  cor(numdataset , use="complete.obs", method = type )
}

factorAnalysis <- function ( dataset, factors, rotationType="varimax") {
  fit <- factanal(dataset,factors,rotation=rotationType)
  print(fit,digits=2,cutoff=.3,sort=T)
  #load <- fit$loadings[,1:2] 
  #pdf(file="factorAnalysis.pdf")
  #plot(load,type="n")
  #text(load,labels=names(dataset),cex=.7)
  #dev.off()
  #return(fit)
}

pca <- function(dataset) {
  dataset <- num_dataset(dataset)
  dataset <- dataset[complete.cases(dataset),]
  fit <- princomp(dataset,cor=TRUE)
  print(summary(fit))
  #write.csv(fit$sdev,"pcaOutput.csv")
}

hclustanal <- function(dataset){
  dataset <- num_dataset(factor_to_num(dataset))
  cluster1 <- hclust(dist(t(log10(dataset[,1:ncol(dataset)]+1))))
  print(cluster1)
  return(cluster1)
}

kmeansclust <- function(dataset, nc){
  dataset <- num_dataset(factor_to_num(dataset))
  cluster1 <- kmeans(dataset, nc)
  print(cluster1)
  return(cluster1)
}

###########################################
shinyServer(function(input, output) {
  dbool <- FALSE
  bool <- T
  tryCatch({gdf <<- read.csv("/media/baremetal/shared/alok/shiny-apps/datafile.csv", header=T)}, error = function(e) bool <<- F)
  if(bool) cnames <<- names(gdf)

  
  output$contents <- renderTable({
    head(gdf, 10)
  })
  
  output$pana_output <- renderPrint({
    pana <- input$panalysis
    eana <- input$eanalysis
    xnames <- input$xvars
    yvariable <- input$yvar
    if(!is.null(xnames)){
      x <- gdf
      print(xnames)      
      print(yvariable)
      ytext <- paste(yvariable,"~")
      fmla <- as.formula(paste(ytext, paste(xnames, collapse= "+")))
      print(fmla)
      if(pana == 'linear regression'){
        fit <- lm(fmla, x, na.action=na.omit)
        print(summary(fit))
      }
      else if(pana == 'logistic regression'){
        logfit <- glm(fmla, x, na.action=na.omit, family = "binomial")
        print(summary(logfit))
      }
    }
    else
      print('Predictive Analysis will appear here, Please Choose independent variables')
  })
  
  output$eana_output <- renderPrint({
    eana <- input$eanalysis
    xnames <- input$xvars
    #yvariable <- input$yvar
    an_number <- input$an_number
    if(eana != 'None'){
      dbool <<- TRUE
      x <- gdf
      if(eana == 'factor analysis'){
        factors <- as.integer(an_number)
        fit <- factorAnalysis(x, factors)
        print(fit,digits=2,cutoff=.3,sort=T)
      }
      else if(eana == 'pca'){
        pca(x)
      }
      else if(eana == 'correlation'){
        correlation(x)
      }
      else if(eana == 'heir. clustering'){
        hclustanal(x)
      }
      else if(eana == 'kmeans clustering'){
        kmeansclust(x, an_number)
      }
    }
    else
      print('ANALYSIS WILL APPEAR HERE') 
  })
  
  output$clustplot <- renderPlot({
    eana <- input$eanalysis
    an_number <- input$an_number
    #plot(rnorm(10),rnorm(10))
    if(dbool == TRUE) {
      x <- gdf
      if(eana == 'factor analysis'){
        factors <- as.integer(input$factors)
        fit <- factorAnalysis(x, factors)
        load <- fit$loadings[,1:2]
        plot(rnorm(20),rnorm(20))
        plot(load,type="n")
        text(load,labels=names(x),cex=.7)
      }
      else if(eana == 'cluster analysis'){
        cluster1 <- clustanal(x)
        plot(cluster1)
      }
      else if(eana=='correlation'){
        p <- qplot(x=Var1, y=Var2, data=melt(cor(num_dataset(x))), fill=value, geom="tile", xlab='x axis', ylab='y axis')
        print(p)
      }
      else if(eana=='kmeans clustering'){
        dataset <- num_dataset(factor_to_num(x))
        kfit <- kmeansclust(x, an_number)
        p <- clusplot(dataset, kfit$cluster, color=TRUE, shade=TRUE, labels=2, lines=0)
        print(p)
      }
      else return(NULL)
    }
  })

  output$dui_cb <- renderUI({
    checkboxGroupInput("xvars", "Choose x variables", cnames)
  })
  output$dui_dd <- renderUI({
    selectInput("yvar", "Choose y variable:", 
                choices = cnames)
  })


})
