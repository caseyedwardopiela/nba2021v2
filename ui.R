####################################
# Casey Opiela                  #
####################################


# Import libraries
library(shiny)
library(shinythemes)
library(data.table)
library(ggplot2)

# Read data
basketball <- read.csv('2021_NBA_Predictions.csv')
names <- sort(unique(basketball$Name))
teams_sorted <-  sort(c(unique(basketball$Team), 'ALL'))
stats <- c('Points', 'Rebounds', 'Assists', 'Steals', 'Blocks', 'Turnovers', 'Fantasy Score')


####################################
# User interface                   #
####################################

ui <- fluidPage(theme = shinytheme("cyborg"),
                navbarPage('2020-2021 NBA Projections: ',
                           tabPanel('Individual Information',
                                    
                                    # Page header
                                    
                                    headerPanel('Player Projections'),
                                    
                                    # Input values for player stats
                                    
                                    sidebarPanel(
                                      tags$img(src = 'Luka.jpg', height = 200, width = 300),
                                      HTML("<h3> Pick a Player </h3>"),
                                      
                                      selectInput("player", label = "Player:", 
                                                  choices = names_sorted, 
                                                  selected = "LeBron James"),
                                      selectInput("stat", label = "Stat:",
                                                  choices = stats,
                                                  selected = 'Points'),
                                      selectInput('projections', label = 'Actual or Projected?',
                                                  choices = c('Actual', 'Projected', 'Both'),
                                                  selected = 'Projected'),
                                      
                                      actionButton("submitbutton", "Submit", class = "btn btn-primary")
                                    ),
                                    
                                    mainPanel(
                                      tags$label(h3('Status/Output')), # Status/Output Text Box
                                      verbatimTextOutput('contents'),
                                      tableOutput('tabledata'), # Prediction results table
                                      plotOutput(outputId = 'distPlot'
                                      )
                                    )
                                    
                           ),              
                           tabPanel('Team Information',
                                    # Page header
                                    headerPanel('Team Projections'),
                                    
                                    # Input values for team stats
                                    
                                    tags$img(src = 'kings.jpeg', height = 200, width = 300),
                                    HTML("<h3> Pick a Team </h3>"),
                                    selectInput("team", label = "Team:", 
                                                choices = teams_sorted, 
                                                selected = "LAL"),
                                    selectInput("stat2", label = "Stat:",
                                                choices = stats,
                                                selected = 'Points'),
                                    selectInput('projections2', label = 'Actual or Projected?',
                                                choices = c('Actual', 'Projected'),
                                                selected = 'Projected'),
                                    actionButton("submitbutton2", "Submit", class = "btn btn-primary"),
                                    mainPanel(
                                      tags$label(h3('Status/Output')), # Status/Output Text Box
                                      verbatimTextOutput('contents2'),
                                      tableOutput('tabledata2'), # Prediction results table
                                      
                                    )
                           ),
                           
                           tabPanel('Position Information',
                                    headerPanel('Position Projections'),
                                    
                                    tags$img(src = 'giannis.jpeg', height = 200, width = 300),
                                    HTML("<h3> Pick a Position </h3>"),
                                    
                                    # Input values for position stats
                                    
                                    selectInput("position", label = "Position:", 
                                                choices = c('PG', 'SG', 'SF', 'PF', 'C'), 
                                                selected = "SF"),
                                    selectInput("stat3", label = "Stat:",
                                                choices = stats,
                                                selected = 'Points'),
                                    selectInput('projections3', label = 'Actual or Projected?',
                                                choices = c('Actual', 'Projected'),
                                                selected = 'Projected'),
                                    actionButton("submitbutton3", "Submit", class = "btn btn-primary"),
                                    
                                    mainPanel(
                                      tags$label(h3('Status/Output')), # Status/Output Text Box
                                      verbatimTextOutput('contents3'),
                                      tableOutput('tabledata3'), # Prediction results table
                                      
                                    )
                           )
                           
                           
                )
)


