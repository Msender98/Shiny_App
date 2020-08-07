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

shinyServer(function(input, output, session) {
    
    datesFiltered = reactive({
        yelp_checkin_long_filt %>% filter(.,date >= input$date_range[1] & date <= input$date_range[2]) %>% 
        transmute(long = as.numeric(longitude), lat = as.numeric(latitude)) %>% cbind(.$long,.$lat)
        
      })
    
    output$map2 <- renderLeaflet({
        leaflet() %>% addTiles() %>% 
            addMarkers(data = datesFiltered())
    })

})
