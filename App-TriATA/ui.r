library(shiny)

shinyUI(fluidPage(
  titlePanel("Calculate Triangles, Link Ratios from Detailed Claims"),
  sidebarLayout(
    sidebarPanel(
      fileInput('file1', 'Choose CSV File',
                accept=c('text/csv', 
                         'text/comma-separated-values,text/plain', 
                         '.csv')),
      tags$style(HTML("
        hr { 
        display: block;
        margin-top: 0.5em;
        margin-bottom: 0.5em;
        margin-left: auto;
        margin-right: auto;
        border-style: inset;
        border-width: 1px;
    } 
    ")),
      tags$hr(),
      checkboxInput('header', 'Header', TRUE),
      radioButtons('sep', 'Separator',
                   c(Comma=',',
                     Semicolon=';',
                     Tab='\t'),
                   ','),
      radioButtons('quote', 'Quote',
                   c(None='',
                     'Double Quote'='"',
                     'Single Quote'="'"),
                   '"'),
      tags$hr()
      
      , selectizeInput('colName', label = "Select column to triangulate", 
                       choices = NULL)

    ),
    mainPanel(
      tabsetPanel(
        tabPanel("DetailSummary", tableOutput('detailSummary'))
      , tabPanel("Triangle", tableOutput('tri'))
      , tabPanel("LinkRatios", tableOutput('tri.ata'))
        )

    )
  )
))