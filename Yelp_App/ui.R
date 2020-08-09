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
            menuItem('Map', tabName = 'MAP', icon = icon('map')),
            menuItem("Business", tabName = 'business', icon = icon('chart-bar')),
            menuItem("Data", tabName = "data", icon = icon("database"))),
            selectizeInput('category', 'Category', choices = category$categories)
    ),
    dashboardBody(
        tabItems(
            tabItem(tabName = 'MAP',
                    fluidPage(
                        leafletOutput('map')
                    #add checkboxes with different inputs or something
                    )
                    ),
            tabItem(tabName = "business",
                    fluidPage(
                        
                        plotOutput('plot'),
                        plotOutput('hist'),
                        fluidRow(
                        selectizeInput('selected', 'Feature', choices = c('review_count','daily_checkins', 'Income','Unemployment','Poverty')),
                        checkboxInput('log','Log_x', value = TRUE),
                        checkboxInput('open','Is Open', value = TRUE))
                        )
                             
                    ),
            tabItem(tabName = "data",
                    "to be replaced with datatable"))
        
    )
))

