library(viridis)
library(shinydashboard)
library(leaflet)
library(lubridate)
library(tidyverse)
library(DT)


split_category = function(category){
  categories = strsplit(category, ',')
  return(lapply(categories, str_trim))
}

yelp_nevada = read.csv2('./data/yelp_nevada.csv', stringsAsFactors = FALSE, header = TRUE)
yelp_nevada = yelp_nevada %>% mutate(.,categories = split_category(categories)) %>% filter(review_count >5)

category = read.csv('./data/category.csv')
nevada_geocodes = read.csv('./data/nevada_geocodes.csv')

normalize = function(vector){
  return((vector-min(vector))/(max(vector)-min(vector)))
}
