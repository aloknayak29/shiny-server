library(shiny)
library(ggplot2)
library(reshape2)
library(cluster)

factor_to_num <- function(dataset){
  for (i in 1:ncol(dataset)){
    if (class(dataset[,i])=="factor")
      dataset[,i] <- as.numeric(as.character(dataset[,i]))
  }
  return(datset)
}

num_dataset <- function(dataset){
  nums <- sapply(dataset,is.numeric)
  dataset <- dataset[,nums]
  return(dataset)
}
correlation <- function ( dataset, type="pearson") {
  numdataset <- num_dataset(dataset)
  cor(numdataset , use="pairwise.complete.obs", method = type )
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

shinyServer(function(input, output) {
  dbool <- FALSE
  df <- reactive({
    inFile <- input$file1
    
    if (is.null(inFile))
      return(NULL)
    dbool <<- TRUE
    df <- read.csv(inFile$datapath, header=input$header, sep=input$sep, quote=input$quote)
  })
  output$contents <- renderTable({
    
    # input$file1 will be NULL initially. After the user selects and uploads a 
    # file, it will be a data frame with 'name', 'size', 'type', and 'datapath' 
    # columns. The 'datapath' column will contain the local filenames where the 
    # data can be found.
    head(df(),20)
  })
  output$lm_output <- renderPrint({
    #print('asdfsaf')
    ana <- input$analysis
    an_number <- input$an_number
    if(dbool == TRUE) {
      x <- df()
      print(ana)
      if(ana == 'factor analysis'){
        factors <- as.integer(an_number)
        fit <- factorAnalysis(x, factors)
        print(fit,digits=2,cutoff=.3,sort=T)
      }
      else if(ana == 'pca'){
        pca(x)
      }
      else if(ana == 'correlation'){
        correlation(x)
      }
      else if(ana == 'heir. clustering'){
        hclustanal(x)
      }
      else if(ana == 'kmeans clustering'){
        kmeansclust(x, an_number)
      }
      else
        print("No analysis choosen")
    }
    else
      return(NULL)
  })
  output$clustplot <- renderPlot({
    ana <- input$analysis
    an_number <- input$an_number
    #plot(rnorm(10),rnorm(10))
    if(dbool == TRUE) {
      x <- df()
      if(ana == 'factor analysis'){
        factors <- as.integer(input$factors)
        fit <- factorAnalysis(x, factors)
        load <- fit$loadings[,1:2]
        plot(rnorm(20),rnorm(20))
        plot(load,type="n")
        text(load,labels=names(x),cex=.7)
      }
      else if(ana == 'cluster analysis'){
        cluster1 <- clustanal(x)
        plot(cluster1)
      }
      else if(ana=='correlation'){
        p <- qplot(x=Var1, y=Var2, data=melt(cor(num_dataset(x))), fill=value, geom="tile", xlab='x axis', ylab='y axis')
        print(p)
      }
      else if(ana=='kmeans clustering'){
        dataset <- num_dataset(factor_to_num(x))
        kfit <- kmeansclust(x, an_number)
        p <- clusplot(dataset, kfit$cluster, color=TRUE, shade=TRUE, labels=2, lines=0)
        print(p)
      }
      else return(NULL)
    }
  })
})
