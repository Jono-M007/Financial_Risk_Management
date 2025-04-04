# Scenario analysis -  define a market shock scenario
shock_factors <- c(-0.05, 0.02 ,0.01)

# Compute stressed portfolio returns
stressed_returns <- returns %*% shock_factors

#Compare the normal portfolio return performance to the stressed return
original_portfolio_ret <- sum(weights * colMeans(returns))
stressed_portfolio_ret <- sum(weights * stressed_returns)

#Print the results 
cat("Original Portfolio Return:" , round(original_portfolio_ret * 100 ,2), "%\n")
cat("Stressed Portfolio Return:" , round(stressed_portfolio_ret * 100 ,2), "%\n")

