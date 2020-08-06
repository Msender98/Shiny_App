#
# This is the server logic of a Shiny web application. You can run the
# application by clicking 'Run App' above.
#
# Find out more about building applications with Shiny here:
#
#    http://shiny.rstudio.com/
#
#NOTES:  Choose a few cities. Analysis of that city/cities. User activity and/or ... closing...

library(leaflet)
set.seed(42)
yelp_business = sample_n(yelp_business, 1000)

points = cbind(as.numeric(yelp_business$longitude), as.numeric(yelp_business$latitude))

# Define server logic required to draw a histogram
shinyServer(function(input, output) {

    output$map2 <- renderLeaflet({
        leaflet() %>% addTiles() %>% 
            addMarkers(data = points, popup = yelp_business$name)
    })

})
