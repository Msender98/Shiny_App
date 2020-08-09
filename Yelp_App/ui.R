#
# This is the user-interface definition of a Shiny web application. You can
# run the application by clicking 'Run App' above.
#
# Find out more about building applications with Shiny here:
#
#    http://shiny.rstudio.com/
#

library(shinydashboard)
library(leaflet)
library(lubridate)
# Define UI for application that draws a histogram
shinyUI(dashboardPage(
    dashboardHeader(title= "Yelp"),
    dashboardSidebar(
        sidebarMenu(
            menuItem("Map", tabName = "map", icon = icon("map")),
            menuItem("Plots", tabName = 'plots', icon = icon('chart-bar')),
            menuItem("Data", tabName = "data", icon = icon("database")))
    ),
    dashboardBody(
        tabItems(
            tabItem(tabName = "map",
                   fluidRow(box(leafletOutput("map2")))
            
                   ),
            tabItem(tabName = "Business",
                    fluidPage(
                        plotOutput('plot'),
                        
                        selectizeInput('selected', 'Feature', choices = c('review_count', 'Income','Unemployment','Poverty')),
                        selectizeInput('category', 'Category', choices = category$categories),
                        checkboxInput('open','Is Open', value = TRUE)
                        )
                             
                    ),
            tabItem(tabName = "data",
                    "to be replaced with datatable"))
        
    )
))

