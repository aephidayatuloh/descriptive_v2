
library(shiny)
library(colourpicker)

  shinyServer(function(input, output, session){
    dataset <- reactive({
      if(is.null(input$file)){return(NULL)}
      infile <- input$file
      read.delim(infile$datapath, header = input$header, sep = input$delim)
    })
    
    output$tableTitle <- renderUI({
      if(is.null(input$file)){return(NULL)}
      h3("Data preview")
    })
    
    output$preview <- renderTable({
      if(is.null(input$file)){return(NULL)}
      head(dataset())
    })
    
    observe({
      if(!is.null(input$file) & input$graphs=="hist"){
      vars <- names(dataset())
      updateSelectInput(session, inputId = "column", label = "Choose variable", choices = vars, selected = vars[1])
      updateSelectInput(session, inputId = "ttestcol", label = "Choose variable(s)", choices = vars, selected = vars[1])
    }
      else if(!is.null(input$file) & input$graphs=="boxplot"){
        vars <- names(dataset())
        updateSelectInput(session, inputId = "boxcol", label = "Choose variable", choices = vars, selected = vars[1])
      }
      else if(!is.null(input$file) & input$graphs=="scatter"){
        vars <- names(dataset())
        updateSelectInput(session, inputId = "var1", label = "Select variable 1", choices = vars, selected = vars[1])
        updateSelectInput(session, inputId = "var2", label = "Select variable 2", choices = vars, selected = vars[2])
      }
    })
    
    output$graphTitle <- renderUI({
      if(is.null(input$file)){return(NULL)}
      h3("Graphics")
    })
    
    output$plots <- renderPlot({
      if(is.null(input$file)){return(NULL)}
      x <- dataset()
      
      if(input$graphs=="hist"){
        bins <- seq(min(x[,input$column]), max((x[,input$column])), length.out = input$bins + 1)
        hist(x[,input$column], breaks = bins, col = input$cols, main = paste("Histogram of", input$column), xlab = input$column)
      }
      else if(input$graphs=="boxplot"){
        boxplot(x[, input$boxcol])
      }
      else if(input$graphs=="scatter"){
        plot(x[,c(input$var1, input$var2)], pch = input$point, xlab = input$var1, ylab = input$var2, col = input$cols)
      }
    })

    output$ttesttitle <- renderUI({
      if (is.null(input$file)) {return(NULL)}
      h3("Student's t-test")
    })
    
    output$ttest <- renderPrint({
      if (is.null(input$file)) {return(NULL)}
      if(length(input$ttestcol)==1){
        var1 <- dataset()[,input$ttestcol]
        var2 <- NULL
      }
      else if(length(input$ttestcol)==2){
        var1 <- dataset()[,input$ttestcol[1]]
        var2 <- dataset()[,input$ttestcol[2]]
      }
      else{return(NULL)}
      t.test(var1, var2, alternative = input$hypo, mu = input$mu, conf.level = input$conf.lvl, paired = input$pair, var.equal = input$var)
    })
    
    # session$onSessionEnded(function(){
    #   stopApp()
    #   q("no")
    # })
  })