library(leaflet)
library(plotly)

library(shinydashboard)
library(leaflet)
library(lubridate)

yelp_nevada #save both as csv at the end, run all of the analysis on yelp_nevada2...
category #list of categories to filter by
nevada_geocodes

normalize = function(vector){
  return((vector-min(vector))/(max(vector)-min(vector)))
}
