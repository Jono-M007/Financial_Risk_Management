#Installing the packages to create the Shiny app
install.packages("quantmod")
install.packages("PerformanceAnalytics")
install.packages("shiny")

library(shiny)
library(quantmod)
library(PerformanceAnalytics)

ui <- fluidPage(
  titlePanel("Portfolio Risk & Performance Dashboard"),
  sidebarLayout(
    sidebarPanel(
      sliderInput("w_SPY", "SPY Weight" , min = 0, max = 1 , value = 0.6),
      sliderInput("w_AGG", "AGG Weight", min = 0 , max = 1 , value = 0.3),
      sliderInput("w_GLD","GLD Weight", min = 0, max = 1, value = 0.1)
    ),
    mainPanel(plotOutput("riskPlot"), tableOutput("metricsTable")
  )
)
)

server <- function(input, output) {
  getSymbols(c("SPY", "AGG", "GLD"), from = "2020-01-01")
  prices <- merge(Cl(SPY), Cl(AGG), Cl(GLD))
  returns <- na.omit(ROC(prices, type = "discrete"))
  
  output$riskPlot <- renderPlot({
    weights <- c (input$w_SPY, input$w_AGG , input$w_GLD)
    port_returns <- Return.portfolio(returns, weights)
    chart.CumReturns(port_returns, main = "Portfolio Growth")
  })
  
output$metricsTable <- renderTable({
  weights <- c(input$w_SPY, input$w_AGG, input$w_GLD)
  port_returns <- Return.portfolio(returns, weights)
  vol <- sd(port_returns)
  sharpe <- mean(port_returns) / vol
  data.frame(Metric = c("Volatility", "Sharpe Ratio") , Value = round(c(vol,sharpe),4))
})  
}

shinyApp(ui = ui , server = server)





