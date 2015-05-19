# WHO
# server.R

library(shiny)
library(googleVis)
library(plyr)
library(ggplot2)
library(stringr)



## shinyServer ###################################################

shinyServer(function(input, output) {
  # Analysis Tab
  # Scatterplot
  output$splot <- renderPlot({

    X <- str_replace_all(input$spVar1,"([-(%)&=$ ;])",".")
    Y <- str_replace_all(input$spVar2,"([-(%)&=$ ;])",".")
    
    ggplot(WHO.subset2, aes_string(x=X, y=Y), environment=environment()) +
      geom_point(size=5, colour="#4eb3d3", alpha = 0.4)+
      xlab(input$spVar1)+
      ylab(input$spVar2)+
      theme(panel.background=element_rect(fill="white"),
            axis.line=element_line(size=0.1))
  })
  
  # Maps
  # Maps label
  mapAlabel <- reactive({
    cat(input$spVar1)
  })
  
  output$labelA <- renderPrint({
    mapAlabel()
  })
  
  mapBlabel <- reactive({
    cat(input$spVar2)
  })
  
  output$labelB <- renderPrint({
    mapBlabel()
  })
  
  # Plot maps
  output$mapA <- renderGvis({

    ## Color brewer
    colorbrewer <- "{minValue:0,colors:['#F7FCF0', '#E0F3DB', '#CCEBC5', '#A8DDB5', '#7BCCC4', '#4EB3D3', '#2B8CBE', '#0868AC', '#084081']}"
    # defaultColor = color for unspecified/null value
    gvisGeoChart(WHO,
                 locationvar="Country", colorvar=input$spVar1,
                 options=list(colorAxis=colorbrewer,defaultColor='#F5F5F5'))     
  })

   output$mapB <- renderGvis({

    colorbrewer <- "{minValue:0,colors:['#F7FCF0', '#E0F3DB', '#CCEBC5', '#A8DDB5', '#7BCCC4', '#4EB3D3', '#2B8CBE', '#0868AC', '#084081']}"

    # defaultColor = color for unspecified/null value
    gvisGeoChart(WHO,
                 locationvar="Country", colorvar=input$spVar2,
                 options=list(colorAxis=colorbrewer,defaultColor='#F5F5F5'))     
  })
  
  # Correlation test
  ci <- reactive({
    X <- quote(str_replace_all(input$spVar1,"([-(%)&=$ ;])","."))
    Y <- quote(str_replace_all(input$spVar2,"([-(%)&=$ ;])","."))

    corr <- cor.test(WHO.subset2[,eval(X)], WHO.subset2[,eval(Y)])

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

  output$ci.out <- renderPrint({
    ci()
    })
  
  # Correlation table tab
  output$corrtable <-renderDataTable({
    WHO.cor
  }, options = list(orderClasses=TRUE, pageLength=10)
  )
  

})

