library(shiny)
library(dplyr)
library(rCharts)
library(data.table)
library(shinyjs)
library(networkD3)
library(data.tree)
library(stringr)
library(DT)

compounds <- read.csv("./Data/sampleCompoundData.csv", colClasses = "character")
similarCompounds <- read.csv("./Data/sampleSimilarData.csv", colClasses = "character")
adverseEvents <- read.csv("./Data/sampleAdverseData.csv", colClasses = "character")
funds <- read.csv("./Data/sampleFundsData.csv", 
                    colClasses = c("character", "character","numeric","character"))
trials <- read.csv("./Data/sampleTrialData.csv", colClasses = "character")

shinyServer(function(input, output, session) {
  
  observe({
    if (is.null(input$selection) || input$selection == "") {
      shinyjs::hide("submit")
    } else {
      shinyjs::show("submit")
    }
  })
  
  observeEvent(input$submit, {
    selectIso <- isolate(input$selection)
    
    output$ui1 <- renderUI({
      cb_options <- compounds %>% filter(indications == tolower(selectIso)) %>% .$drugs
      checkboxGroupInput("approvedCompounds", 
                         label = h5("Approved Compounds"), 
                         choices = cb_options,
                         selected = cb_options
      )
    })
      
    output$ui2 <- renderUI({
      cb_options <- similarCompounds %>% filter(drugs %in% input$approvedCompounds) %>% .$similar
      checkboxGroupInput("interestCompounds", 
                         label = h5("Compounds of Interest"), 
                         choices = cb_options,
                         selected = cb_options
      )
    })
  })
  
  observeEvent(input$submit, {
    
    output$clinicalTrialTable <- DT::renderDataTable({
      trials %>% filter(Drug %in% input$interestCompounds)
    })
    
  })
  
  observeEvent(input$submit, {
  
    output$myEventChart <- renderChart({
      df = adverseEvents %>% filter(drugs %in% input$interestCompounds) %>% select(drugs, event)
      df = as.data.table(df)
      setkey(df, drugs, event)
      df = df[CJ(unique(drugs), unique(event)), .N, by = .EACHI]
      
      p1 <- nPlot(N ~ event, group = "drugs", data = df, type = "multiBarChart")
      p1$addParams(dom = 'myEventChart')
      return(p1)
    })
  
  })
  
  observeEvent(input$submit, {
    
    output$myCountryChart <- renderChart({
      df = adverseEvents %>% filter(drugs %in% input$interestCompounds) %>% select(drugs, country)
      df = as.data.table(df)
      setkey(df, drugs, country)
      df = df[CJ(unique(drugs), unique(country)), .N, by = .EACHI]
      
      p1 <- nPlot(N ~ country, group = "drugs", data = df, type = "multiBarChart")
      p1$addParams(dom = 'myCountryChart')
      return(p1)
    })
    
  })
  
  observeEvent(input$submit, {
    
    output$myIndicationChart <- renderChart({
      df = adverseEvents %>% filter(drugs %in% input$interestCompounds) %>% select(drugs, indication)
      df = as.data.table(df)
      setkey(df, drugs, indication)
      df = df[CJ(unique(drugs), unique(indication)), .N, by = .EACHI]
      
      p1 <- nPlot(N ~ indication, group = "drugs", data = df, type = "multiBarChart")
      p1$addParams(dom = 'myIndicationChart')
      return(p1)
    })
    
  })
  
  observeEvent(input$submit, {
    
    output$myNetwork <- renderHierNetwork({
      df = funds %>% filter(indication == tolower(input$selection) & drug %in% input$interestCompounds) %>% select(drug, center, amount)
      df$amount = str_trim(sprintf("%7d",df$amount))
      
      df <- split(df, as.factor(df$center))
      for (i in 1:length(df)) {
        df[[i]]$center <- NULL
        df[[i]] <- split(df[[i]], as.factor(df[[i]]$drug))
        for (j in 1:length(df[[i]])) {
          df[[i]][[j]]$drug <- NULL
          df[[i]][[j]] <- df[[i]][[j]]$amount
        }
      }
      
      main <- Node$new(input$selection)
      for (i in 1:length(df)) {
        current <- main$AddChild(names(df)[i])
        for (j in 1:length(df[[i]])) {
          sub_current <- current$AddChild(names(df[[i]])[j])
          for (k in 1:length(df[[i]][[j]])) {
            sub_current$AddChild(df[[i]][[j]][[k]])
          }
        }
      }
      
#      hierNetwork(main$ToList(unname = TRUE), type = "tree.cartesian", zoomable = TRUE, collapsible = TRUE)
      hc = hclust(dist(mtcars))
      hierNetwork( as.treeNetwork(hc), type = "tree.cartesian", zoomable = T, collapsible = T )
    })
    
  })
  
})
