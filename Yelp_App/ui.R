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
            menuItem("Data", tabName = "data", icon = icon("database")))
    ),
    dashboardBody(
        tabItems(
            tabItem(tabName = "map",
                   fluidRow(box(leafletOutput("map2"))),
                   dateRangeInput('date_range',"Date Range:",
                                  start = '2019-01-01',
                                  end = '2019-02-01',
                                  min = '2019-01-01',
                                  max = '2019-05-01',
                                  format = 'mm-dd-yyyy',)
            
                   ),
            tabItem(tabName = "data",
                    "to be replaced with datatable"))
        
    )
))

