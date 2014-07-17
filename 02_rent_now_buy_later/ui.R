library(shiny)

googleAnalytics <- function(account="UA-52253018-1"){
  HTML(paste("<script>
               (function(i,s,o,g,r,a,m){i['GoogleAnalyticsObject']=r;i[r]=i[r]||function(){
                 (i[r].q=i[r].q||[]).push(arguments)},i[r].l=1*new Date();a=s.createElement(o),
                 m=s.getElementsByTagName(o)[0];a.async=1;a.src=g;m.parentNode.insertBefore(a,m)
               })(window,document,'script','//www.google-analytics.com/analytics.js','ga');
             
             ga('create', '",account,"', 'shinyapps.io');
             ga('send', 'pageview');
             
             </script>"))
}

# Define UI for application that draws a histogram
shinyUI(navbarPage(
  " "
  ,tabPanel("",
    titlePanel("Rent now, buy later"),
    sidebarLayout(
      sidebarPanel(""
                   ,sliderInput("frcstDur", "Forecast duration:", 
                               min=20, max=30, value=20, format="## years")
                   # Provide a ranges for rent of range
                   ,sliderInput("rnt", "Rent:",
                               min = 700, max = 3000, value = c(1000,2000),
                               format="£##,###" , step = 50)
                   ,sliderInput("mnthlCash", "Amount available for rent/mortgage and savings per month:",
                                min = 700, max = 3000, value = 2000,
                                format="£##,###", step = 50)
                   ,sliderInput("cashInHand", "Existing Savings:",
                                min = 20000, max = 500000, value = 100000,
                                format="£###,###", step=20000) 
                   ,sliderInput("dpstPercent", "% of Savings to use for deposit:",
                                min = 0, max = 1, value = .85,
                                format="#%", step=.05)  
                   ,sliderInput("hsPrice", "House Purchase Price:",
                                min = 200000, max = 1000000, value = 800000,
                                format="£###,###", step=25000)  
                   ,sliderInput("hsValChng", "House Value Change:",
                                min = -.5, max = .5, value = -.25,
                                format="#%", step=0.05)  
                   ,sliderInput("mrtgDur", "Mortgage Length:", 
                                min=15, max=25, value=20, format="## years", step=5)
                   ,sliderInput("mrtgRate", "Mortgage Rate:",
                                min = .01, max = .12, value = .05,
                                format="#%", step=0.01)                   
                   ,sliderInput("ntrstRate", "Interest Rate:",
                                min = .01, max = .12, value = .05,
                                format="#%", step=0.01)                   
                   ,sliderInput("txRate", "Savings Tax Rate:",
                                min = .20, max = .40, value = .20,
                                format="#%", step=.20)

                  
      ),
      mainPanel(plotOutput("rentOrBuy")
                ,"This is still work in progress. \n 
                  some tests are still failing so the output is not reliable for now"
                ,googleAnalytics()
      )
    )
  )
  
) 
)

