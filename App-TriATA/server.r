library(shiny)
suppressPackageStartupMessages(library(mondate))
suppressPackageStartupMessages(library(ChainLadder))
library(reshape2)
options(shiny.maxRequestSize = 30 * 1024^2)


shinyServer(function(input, output, session) {

  observe({
    if (is.null(inFyle())) return(NULL)
#    numnames <- names(detailData())
    numnames <- names(detailData())[sapply(detailData(), is.numeric)]
    numnames <- sort(numnames)
    updateSelectizeInput(session, 'foo', choices = numnames, 
                         selected = numnames[1L], 
                         server = TRUE)
  })
  
  
  inFyle <- reactive({input$file1})
  detailData <- reactive({
    if (is.null(inFyle())) return(NULL)
    x <- read.csv(inFyle()$datapath, header=input$header, sep=input$sep, 
             quote=input$quote)
    x$age <- mondate(x$eval_dt) - mondate.ymd(x$ay - 1)
    x    
  })

  tri <- reactive({
    if (is.null(inFyle())) return(NULL)
    acast(detailData(), ay ~ age, sum, value.var = "directlossincurred", fill = as.numeric(NA))
  })
  
  savefyle <- reactive({
    if (is.null(inFyle())) return(NULL)
    write.csv(file.path(output$datadir(), "tri.csv"))
  })

  output$wd <- reactive({getwd()})

  output$datadir <- reactive({dir("..//data")[1]})

  output$contents <- renderTable({
    
    # input$file1 will be NULL initially. After the user selects
    # and uploads a file, it will be a data frame with 'name',
    # 'size', 'type', and 'datapath' columns. The 'datapath'
    # column will contain the local filenames where the data can
    # be found.
    
    inFile <- inFyle() #input$file1
    if (is.null(inFile)) return(NULL)
    
#    x <- read.csv(inFile$datapath, header=input$header, sep=input$sep, 
#                  quote=input$quote)
#    dimm <- dim(x)
#    head(x)
    summary(detailData())
  }, digits = 0)

  output$detailSummary <- renderTable({
    
    # input$file1 will be NULL initially. After the user selects
    # and uploads a file, it will be a data frame with 'name',
    # 'size', 'type', and 'datapath' columns. The 'datapath'
    # column will contain the local filenames where the data can
    # be found.
    
    inFile <- inFyle() #input$file1
    if (is.null(inFile)) return(NULL)
    
    summary(detailData())
  })

  output$tri.ata <- renderTable({
    triangle <- tri()
    if (is.null(triangle)) return(NULL)
    summary(ata(triangle))
  }, digits = 3)
  
  output$tri <- renderTable({
#    inFile <- inFyle() #input$file1
#    if (is.null(inFile)) return(NULL)
    tri()
#    acast(detailData(), ay ~ age, sum, value.var = "directlossincurred", fill = as.numeric(NA))
  }, digits = 0)

  output$numericColumns <- renderText({
    if (is.null(inFyle())) return(NULL)
    names(detailData())
  })
  
output$temppath <- renderText({
    inFile <- input$file1
    if (is.null(inFile)) return("path = no file yet chosen")
    paste("path =", inFile$datapath)
  })

  output$dimm <- renderText({
    inFile <- input$file1
    if (is.null(inFile)) return("dim = no file yet chosen")
    paste("dim =", paste(as.character(dim(detailData())), collapse = " "))
    })
})