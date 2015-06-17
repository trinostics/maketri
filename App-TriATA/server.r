library(shiny)
suppressPackageStartupMessages(library(mondate))
suppressPackageStartupMessages(library(ChainLadder))
library(reshape2)
options(shiny.maxRequestSize = 30 * 1024^2)


shinyServer(function(input, output, session) {

  # Update the column name selection box based on the numeric's in the table
  # To do: have the default selectionBox value be the default column!
  observe({
    if (is.null(inFyle())) return(NULL)
    numnames <- names(detailData())[sapply(detailData(), is.numeric)]
    numnames <- sort(numnames)
    updateSelectizeInput(session, 'colName', choices = numnames, 
                         selected = numnames[1L], 
                         server = TRUE)
  })
  
  # input$file1 will be NULL initially. After the user selects
  # and uploads a file, it will be a data frame with 'name',
  # 'size', 'type', and 'datapath' columns. The 'datapath'
  # column will contain the local filenames where the data can
  # be found.
  inFyle <- reactive({input$file1})

  # This will be the data.frame to work one once it's loaded.
  detailData <- reactive({
    if (is.null(inFyle())) return(NULL)
    x <- read.csv(inFyle()$datapath, header=input$header, sep=input$sep, 
             quote=input$quote)
    x$age <- mondate(x$eval_dt) - mondate.ymd(x$ay - 1)
    x    
  })

  # Here will be calculated the traditional triangle
  # To do: allow the rows and columns to be other than 'ay' and 'age'
  tri <- reactive({
    if (is.null(inFyle())) return(NULL)
    acast(detailData(), ay ~ age, sum, value.var = input$colName, fill = as.numeric(NA))
  })
  
  # "Debugging data"
  output$wd <- reactive({getwd()})
  output$datadir <- reactive({dir("..//data")[1]})

  # This being displayed will indicated that the file successfully loaded
  output$contents <- renderTable({
      inFile <- inFyle() #input$file1
      if (is.null(inFile)) return(NULL)
      summary(detailData())
    }, 
    digits = 0
  )

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
    tri()
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
  
  # For the future.
  savefyle <- reactive({
    if (is.null(inFyle())) return(NULL)
    write.csv(file.path(output$datadir(), "tri.csv"))
  })
  
})