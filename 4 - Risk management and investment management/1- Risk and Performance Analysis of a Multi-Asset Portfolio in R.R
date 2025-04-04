# Installing the packages to retrieve price data
install.packages("quantmod")
install.packages("tidyquant")

library(quantmod)
library(tidyquant)
library(PortfolioAnalytics)

#Get the historical price data for the portfolio
tickers <- c("SPY", "AGG", "GLD")
getSymbols(tickers, from = "2020-01-01", to = "2025-01-01")

help("do.call")
help("lapply")
prices <- do.call(merge, lapply(tickers, function(x) Cl(get(x))))
returns <- na.omit(ROC(prices, type = "discrete"))

#Define portfolio weights & compute portfolio returns
weights <- c(0.6 , 0.3 , 0.1)
portfolio_returns <- Return.portfolio(returns, weights = weights)


#Calculate portfolio risk metrics
volatility <- sd(portfolio_returns)
var_95 <- VaR(portfolio_returns , p = 0.95 , method = "historical")
beta_calc <- CAPM.beta(portfolio_returns, returns$SPY.Close)

#Calculate risk-adjusted performance metrics
help("SortinoRatio")
sharpe_ratio <- SharpeRatio.annualized(portfolio_returns, Rf = 0.02/252)
sortino_ratio <- SortinoRatio(portfolio_returns, MAR = 0)
treynor_ratio <- mean(portfolio_returns) /  beta_calc

#Create a list of constraints and optimize the portfolio
help("portfolio.spec")
portfolio_spec <- portfolio.spec(assets = tickers)
portfolio_spec <- add.constraint(portfolio_spec , type = "full_investment")
portfolio_spec <- add.constraint(portfolio_spec , type = "long_only")
portfolio_spec <- add.constraint(portfolio_spec ,type = "risk", name = "StdDev")

opt_portfolio <- optimize.portfolio(returns, portfolio_spec , optimize_method = "ROI")

#Visualizations of the portfolio
chart.CumReturns(portfolio_returns, main  = "Portfolio Growth")
chart.RollingPerformance(portfolio_returns, width = 60)

