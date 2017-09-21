
library(shiny)
library(colourpicker)

# Define UI for application that draws a histogram
shinyUI(fluidPage(
  
  headerPanel("Statistical Descriptive & Student's T-Test"),
  
  # Sidebar with a slider input for number of bins 
  sidebarLayout(
    sidebarPanel(
      fileInput(inputId = "file", label = "Choose CSV/Text file:"),
      checkboxInput(inputId = "header", label = "First row as header", value = TRUE),
      radioButtons(inputId = "delim", label = "Delimiter", choices = list("Comma"=",", "Semicolon"=";", "Blank/space"="\t")),
      h3("Graphics"),
      selectInput(inputId = "graphs", label = "Choose graphic:", choices = list("Histogram"="hist", "Boxplot"="boxplot", "Scatter"="scatter")),
      conditionalPanel(condition = "input.graphs=='hist'",
                       selectInput(inputId = "column", label = "Choose variable", choices = list("")),
                       sliderInput(inputId = "bins", label = "Select number of bins:", value = 5, min = 2, max = 30)
                       ),
      conditionalPanel(condition = "input.graphs=='boxplot'",
                       selectInput(inputId = "boxcol", label = "Choose variable", choices = list(""), multiple = TRUE)
                       ),
      conditionalPanel(condition = "input.graphs=='scatter'",
                       selectInput(inputId = "var1", label = "Select variable 1", choices = list("")),
                       selectInput(inputId = "var2", label = "Select variable 2", choices = list("")),
                       sliderInput(inputId = "point", label = "Select point for plot:", value = 1, min = 1, max = 20)
                       ),
      colourInput(inputId = "cols", label = "Choose colour:", value = "blue", allowTransparent = TRUE, palette = "limited"),
      h3("Stdent's t-test"),
      selectInput(inputId = "ttestcol", label = "Choose variable", choices = list(""), multiple = TRUE),
      radioButtons(inputId = "hypo", label = "Alernative hypothesis:", choices = list("Two sided"="two.sided", "Less than"="less", "Greater than"="greater"), inline = TRUE),
      numericInput(inputId = "mu", label = "mu:", value = 0, width = "50%"),
      numericInput(inputId = "conf.lvl", label = "Confidence level:", value = 0.95, width = "50%"),
      checkboxInput(inputId = "pair", label = "Paired", value = FALSE),
      checkboxInput(inputId = "var", label = "Equal variance", value = FALSE)    
      ),
    
    mainPanel(
      uiOutput("tableTitle"),
      tableOutput("preview"),
      uiOutput("graphTitle"),
      plotOutput("plots"),
      uiOutput("ttesttitle"),
      verbatimTextOutput("ttest")
    )
  )
))
