library(shiny)

shinyUI(fluidPage(
  titlePanel("Calculate Triangles, Link Ratios from Detailed Claims"),
  sidebarLayout(
    sidebarPanel(
      fileInput('file1', 'Choose CSV File',
                accept=c('text/csv', 
                         'text/comma-separated-values,text/plain', 
                         '.csv')),
      # hr() doesn't mean horizontal line with HTML5
      # Can be defined as such for HTML5 as follows.
      # There's probably a better place to put this, but I don't know
      # shiny well enough yet.
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
      
    ),
    mainPanel(
      tabsetPanel(
        tabPanel("DetailSummary", 
                 selectizeInput('colName', label = "Select column to triangulate", 
                                  choices = NULL),
                 tableOutput('detailSummary')
        )
      , tabPanel("Triangle", tableOutput('tri'))
      , tabPanel("LinkRatios", tableOutput('tri.ata'))
        )

    )
  )
))