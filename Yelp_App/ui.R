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
            selectizeInput('category', 'Category', choices = category$categories),
            checkboxInput('open','Is Open', value = TRUE)
    ),
    dashboardBody(
        tabItems(
            tabItem(tabName = 'MAP',
                    fluidPage(
                        leafletOutput('map'),
                    #add checkboxes with different inputs or something
                        #plotOutput('hist'),
                        selectizeInput('business', 'Business Feature', choices = c('total_business','daily_checkins','review_count','avg_star_2019')),
                        selectizeInput('demo', 'Demographic', choices = c('Income','Unemployment','Poverty','TotalPop'))
                    )
                    ),
            tabItem(tabName = "business",
                    fluidPage(
                        
                        plotOutput('plot'),
                        fluidRow(
                            selectizeInput('selectedx', 'Feature_X', choices = c('review_count','daily_checkins', 'Income','Unemployment','Poverty')),
                            selectizeInput('selectedy', 'Feature_Y', choices = c('review_count','daily_checkins', 'Income','Unemployment','Poverty','avg_star_2019')),
                            checkboxInput('logx','Log_x', value = TRUE),
                            checkboxInput('logy','Log_y', value = FALSE)
                        ))
                             
                    ),
            tabItem(tabName = "data",
                    "to be replaced with datatable"))
        
    )
))

