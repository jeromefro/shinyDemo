library(shiny)
library(shinythemes)
library(rCharts)
library(shinyjs)
library(data.tree)
library(networkD3)
library(DT)

shinyUI(fluidPage(theme = shinytheme("cosmo"),
  shinyjs::useShinyjs(),                
                  
  titlePanel("Booz | Allen | Hamilton"),
  h4("Cloud Analytics Life Science Sandbox"),
                  
  fluidRow(
    column(4,
      wellPanel(
        textInput("selection", label = h5("Indication of Interest"), value = ""),
        helpText("Enter a term above to search for compounds of interest.", align = "center", style = "font-size:11px"),
        hidden(actionButton("submit", "Search"))
      ),
      
      conditionalPanel(condition = 'input.submit > 0',
                       
                       column(width = 6, 
                              wellPanel(
                                uiOutput("ui1")
                              )
                       ),
                       
                       column(width = 6, 
                              wellPanel(
                                uiOutput("ui2")
                              )
                       )
                       
    )
      
    ),
    column(8,    
      conditionalPanel(condition = 'input.submit > 0',  

        tabsetPanel(
          tabPanel(div(img(src="mesh_logo.gif", height=24, width=24), "Overview") 
        
          ),
          tabPanel(div(img(src="clinicaltrials_logo.png", height=14, width=60), "Clinical Trials"),
            DT::dataTableOutput(outputId="clinicalTrialTable")         
          ),
#           tabPanel(div(img(src="fda_logo.png", height=24, width=36), "Safety"),
#             tabsetPanel(
#               tabPanel("Event",
#                 showOutput("myEventChart", "nvd3")
#               ),
#               tabPanel("Country",
#                        showOutput("myCountryChart", "nvd3")
#               ),
#               tabPanel("Indication",
#                        showOutput("myIndicationChart", "nvd3")
#               )
#             )
#           ),
          tabPanel(div(img(src="NIH_logo.svg", height=28, width=28), "NIH Funding"),
                   hierNetworkOutput("myNetwork")         
          )
        )
      )
    )
  )
  
))
