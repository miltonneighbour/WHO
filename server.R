# WHO
# server.R

library(shiny)
library(googleVis)
library(plyr)
library(ggplot2)
library(stringr)



##### shinyServer #####

shinyServer(function(input, output) {
  
  ##### Correlation test #####
  # Variables for test are based on variables selected by user
  # Reactive expression is used to customized verbatim output 
  ci <- reactive({

    # Regex is used to replace all specified characters with "."
    # cor.test() does not allow variables (or column names) with space and special characters
    X <- quote(str_replace_all(input$spVar1,"([-(%)&=$ ;])","."))
    Y <- quote(str_replace_all(input$spVar2,"([-(%)&=$ ;])","."))

    # Save results of cor.test() to call for its value in customized output
    corr <- cor.test(WHO.subset2[,eval(X)], WHO.subset2[,eval(Y)])

    # cat() - concatenate and print
    cat(
      "Correlation between:", "\n",
      input$spVar1, " & ", input$spVar2, "\n",
      "Method: ", corr$method, "\n",
      "Null hypothesis: ", "True correlation equal to zero", "\n",
      "Degree of freedom: ", corr$parameter, "\n",
      "Correlation coefficient: ", corr$estimate, "\n",
      "95% Confidence Inverval [lower, upper]: ", corr$conf.int, "\n",
      "p-value: ", corr$p.value)
    })

  # Print ci() in output
  output$ci.out <- renderPrint({
    ci()
    })
  
  ##### Scatterplot #####
  output$splot <- renderPlot({

    # Regex is required, space and special characters are not allowed in specifying column names using ggplot
    # Regex: Replace specified characters with "."
    # Variables selected are referred to WHO.subset2, where column names have no space nor special characters
    X <- str_replace_all(input$spVar1,"([-(%)&=$ ;])",".")
    Y <- str_replace_all(input$spVar2,"([-(%)&=$ ;])",".")
    
    # Scatterplot by ggplot2
    # Horizontal x-axis as Variable1 (from input selection)
    # Vertical y-axis as Variable2 (from input selection)
    ggplot(WHO.subset2, aes_string(x=X, y=Y), environment=environment()) +
      geom_point(size=5,aes(colour=factor(WHO$Continent)), alpha = 0.8)+
      scale_colour_manual(values=c('#7fc97f','#beaed4', '#fdc086','#ffff99','#386cb0','#f0027f','#bf5b17'))+
      xlab(input$spVar1)+
      ylab(input$spVar2)+
      theme(panel.background=element_rect(fill="white"),
            axis.line=element_line(size=0.1))
  })
  
  
  ##### Maps #####
  # Maps label
  # Reactive expression is used to avoid label being quoted

  # Map A
  mapAlabel <- reactive({
    cat(input$spVar1)
  })
  
  output$labelA <- renderPrint({
    mapAlabel()
  })
  
  # Map B
  mapBlabel <- reactive({
    cat(input$spVar2)
  })
  
  output$labelB <- renderPrint({
    mapBlabel()
  })

  # ===== Plot map A =====
  # Variable 1 from input selection
  # The value from data frame WHO is mapped to world map based on countries
  # The map is colored sequentially based on scale. The sequence is based on the sequence of color code in "colorbrewer"
  # defaultColor = color for unspecified/null value (pale orange)
  output$mapA <- renderGvis({

    gvisGeoChart(WHO,
      locationvar="Country", colorvar=input$spVar1,
      options=list(colorAxis=colorbrewer,defaultColor='#fdae61'))
    })

  # ===== Plot map B =====
  # Variable 2 from input selection
  output$mapB <- renderGvis({
    gvisGeoChart(WHO,
      locationvar="Country", colorvar=input$spVar2,
      options=list(colorAxis=colorbrewer,defaultColor='#fdae61'))     
  })
  
  ##### Country Continent table #####
  output$cctable <-renderDataTable({
    CountryContinent
  }, options = list(orderClasses=TRUE, pageLength=10)
  )
  

  ##### Correlation table #####
  output$corrtable <-renderDataTable({
    WHO.cor
  }, options = list(orderClasses=TRUE, pageLength=10)
  )
  

})

