# Read data
basketball <- read.csv('2021_NBA_Predictions.csv')
names_sorted <- sort(unique(basketball$Name))
teams_sorted <-  sort(c(unique(basketball$Team), 'ALL'))
stats <- c('Points', 'Rebounds', 'Assists', 'Steals', 'Blocks', 'Turnovers', 'Fantasy Score')

####################################
# Server                           #
####################################

server <- function(input, output, session) {
  
  # Input Data for player stats
  datasetInput <- reactive({  
    
    # create data frame of input values
    df <- data.frame(
      Name = c('player', 'stat', 'projections'),
      value = as.character(c(input$player, input$stat, input$projections)),
      stringsAsFactors = FALSE
    )
    
    response <- basketball %>%
      filter(Name == df[[1,2]]) 
    
    if (df[[2,2]] == 'Rebounds') {
      df[[2,2]] = paste0('Total_', df[[2,2]])
    } else if (df[[2,2]] == 'Fantasy Score') {
      df[[2,2]] = 'Per_Game_Fantasy_Score'
    }
    stat_est <- paste0('EST_', df[[2,2]])
    
    results <- response %>%
      select(Name, df[[2,2]], stat_est)
    
    mean_st <- basketball %>%
      select(df[[2,2]])
    
    results['Mean'] = mean(mean_st[[1]])
    send = results
    
    if (df[[3,2]] == 'Actual') {
      send <- send %>% select(1,2,4)
      colnames(send) = c('Player', gsub('_', ' ', paste('Actual', df[[2,2]])), 'League Average')
    } else if (df[[3,2]] == 'Projected') {
      send <- send %>% select(1,3,4)
      colnames(send) = c('Player', gsub('_', ' ', paste('Projected', df[[2,2]])), 'League Average')
    } else {
      colnames(send) = c('Player', gsub('_', ' ', paste('Actual', df[[2,2]])), 
                         gsub('_', ' ', paste('Projected', df[[2,2]])), 'League Average')
    }
    return(send)
  })
  
  output$distPlot <- renderPlot({
    df <- data.frame(
      Name = c('player', 'stat', 'projections'),
      value = as.character(c(input$player, input$stat, input$projections)),
      stringsAsFactors = FALSE
    )
    
    response <- basketball %>%
      filter(Name == df[[1,2]]) 
    
    key_stat = df[[2,2]]
    
    if (df[[2,2]] == 'Rebounds') {
      df[[2,2]] = paste0('Total_', df[[2,2]])
    } else if (df[[2,2]] == 'Fantasy Score') {
      df[[2,2]] = 'Per_Game_Fantasy_Score'
    }
    stat_est <- paste0('EST_', df[[2,2]])
    
    x    <- basketball[df[[2,2]]][[1]]
    x <- x[x>0]
    
    
    hist(x, col = "#FFA500", border = "blue",
         xlab = paste(key_stat, 'Per Game'),
         ylab = 'Number of Players',
         breaks = 50,
         main = paste0("Distribution of ", key_stat))
    c = req(datasetInput())
    abline(v = c, col = c('purple', 'blue', 'aquamarine'), lwd = 4)
  })
  
  
  # Input Data for team stats
  
  datasetInput2 <- reactive({
    # create data frame of input values
    df2 <- data.frame(
      Name = c('Team', 'Stat', 'Projections'),
      value = as.character(c(input$team, input$stat2, input$projections2)),
      stringsAsFactors = FALSE
    )
    if (df2[[2,2]] == 'Rebounds') {
      df2[[2,2]] = paste0('Total_', df2[[2,2]])
    } else if (df2[[2,2]] == 'Fantasy Score') {
      df2[[2,2]] = 'Per_Game_Fantasy_Score'
    }
    stat_to_search <- df2[[2,2]]
    if (df2[[3,2]] == 'Projected') {
      stat_to_search = paste0('EST_', stat_to_search)
    }
    
    to_present <- c()
    
    if (df2[[1,2]] != 'ALL') {
      to_present <- basketball %>%
        filter(Team == df2[[1,2]]) %>%
        select(Name, stat_to_search) 
    } else {
      to_present <- basketball %>%
        
        select(Name, stat_to_search) 
    }
    
    
    to_present <- to_present[order(to_present[,2], decreasing = TRUE),]
    to_present <- to_present[to_present[,2] > 0,]
    to_present <- na.omit(to_present)
    colnames(to_present) = c('Name', input$stat2)
    return(to_present)
  })
  
  # Input Data for position stats
  
  datasetInput3 <- reactive({
    # create data frame of input values
    df3 <- data.frame(
      Name = c('Position', 'Stat', 'Projections'),
      value = as.character(c(input$position, input$stat3, input$projections3)),
      stringsAsFactors = FALSE
    )
    if (df3[[2,2]] == 'Rebounds') {
      df3[[2,2]] = paste0('Total_', df3[[2,2]])
    } else if (df3[[2,2]] == 'Fantasy Score') {
      df3[[2,2]] = 'Per_Game_Fantasy_Score'
    }
    stat_to_search2 <- df3[[2,2]]
    if (df3[[3,2]] == 'Projected') {
      stat_to_search2 = paste0('EST_', stat_to_search2)
    }
    
    
    
    to_present2 <- basketball %>%
      filter(Position == df3[[1,2]]) %>%
      select(Name, stat_to_search2)
    
    
    
    to_present2 <- to_present2[order(to_present2[,2], decreasing = TRUE),]
    to_present2 <- to_present2[to_present2[,2] > 0,]
    to_present2 <- na.omit(to_present2)
    colnames(to_present2) = c('Name', input$stat3)
    return(to_present2)
  })
  
  
  
  # Status/Output Text Box for players
  output$contents <- renderPrint({
    if (input$submitbutton>0) { 
      isolate("Calculation complete.") 
    } else {
      return("Server is ready for calculation.")
    }
  })
  
  # Prediction results table for players
  output$tabledata <- renderTable({
    if (input$submitbutton>0) { 
      isolate(datasetInput()) 
    } 
  })
  
  # Status/Output Text Box for team
  output$contents2 <- renderPrint({
    if (input$submitbutton2>0) { 
      isolate("Calculation complete.") 
    } else {
      return("Server is ready for calculation.")
    }
  })
  
  # Prediction results table for team
  output$tabledata2 <- renderTable({
    if (input$submitbutton2>0) { 
      isolate(datasetInput2()) 
    } 
  })
  
  # Status/Output Text Box for position
  output$contents3 <- renderPrint({
    if (input$submitbutton3>0) { 
      isolate("Calculation complete.") 
    } else {
      return("Server is ready for calculation.")
    }
  })
  
  # Prediction results table for position
  output$tabledata3 <- renderTable({
    if (input$submitbutton3>0) { 
      isolate(datasetInput3()) 
    } 
  })
  
}
