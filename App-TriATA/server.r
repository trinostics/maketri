library(shiny)
suppressPackageStartupMessages(library(mondate))
suppressPackageStartupMessages(library(ChainLadder))
library(reshape2)
library(excelRio)
library(data.table)
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

  # This will be the data.frame to work with once it's loaded.
  detailData <- reactive({
    if (is.null(inFyle())) return(NULL)
#    x <- read.csv(inFyle()$datapath, header=input$header, sep=input$sep, 
#             quote=input$quote
#             , stringsAsFactors = FALSE)
#    for (i in seq_along(x)) {
#      if (w <- excelRio:::is.date.string(x[[i]])) x[[i]] <- attr(w, "value")
#    }
    x <- readFromCsv(inFyle()$datapath, stringsAsFactors = FALSE, 
                     header = input$header, simplify = FALSE)
    x$ay <- year(x$lossdate)
    x$ayage <- mondate(x$eval_dt) - mondate.ymd(x$ay - 1)
    data.table(x)    
  })

  # Here will be calculated the traditional triangle
  # To do: allow the rows and columns to be other than 'ay' and 'age'
  # Here is where it's reactively calculated ...
  tri <- reactive({
    if (is.null(inFyle())) return(NULL)
    acast(detailData(), ay ~ ayage, sum, value.var = input$colName, fill = as.numeric(NA))
  })
  # ... and here is where it's made available to 'output'.
  output$tri <- renderTable({tri()}, digits = 0)
  
  # This being displayed will indicated that the file successfully loaded
  output$detailSummary <- renderTable({
    inFile <- inFyle() #input$file1
    if (is.null(inFile)) return(NULL)
    summary(detailData())
  })

  # This will show the traditional array of link ratios.
  # BUG! Before the file is uploaded, the link ratio page shows a summary.ata error!
  output$tri.ata <- renderTable({
    triangle <- tri()
    if (is.null(triangle)) return(NULL)
    summary(ata(triangle))
  }, digits = 3)
  
  # For the future.
  savefyle <- reactive({
    if (is.null(inFyle())) return(NULL)
    write.csv(file.path(output$datadir(), "tri.csv"))
  })
  
  # "Debugging data"
  output$wd <- reactive({getwd()})
  output$datadir <- reactive({dir("..//data")[1]})
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