library(shiny)
# Read data
basketball <- read.csv('2021_NBA_Predictions.csv')
names_sorted <- sort(unique(basketball$Name))
teams_sorted <-  sort(c(unique(basketball$Team), 'ALL'))
stats <- c('Points', 'Rebounds', 'Assists', 'Steals', 'Blocks', 'Turnovers', 'Fantasy Score')

port <- Sys.getenv('PORT')

shiny::runApp(
  appDir = getwd(),
  host = '0.0.0.0',
  port = as.numeric(port)
)
