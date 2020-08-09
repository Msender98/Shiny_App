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
library(plotly)


shinyServer(function(input, output, session) {
    
    
    
    dat = reactive({
      yelp_nevada2 %>% filter(unlist(lapply(yelp_nevada2$categories, function(x) input$category %in% x))) %>%
        filter(is_open == input$open)
    })
    
    output$map <- renderLeaflet({
      leaflet() %>% addTiles() %>% fitBounds(-115.49, 35.9, -114.8, 36.44) 
      
    })
    
    output$plot <- renderPlot({
          g = ggplot(data = dat(), aes_string(x = input$selected, y = 'avg_star_2019')) + geom_point() + ggtitle('Stars')
          if(input$log){g = g + scale_x_log10()}
          g
    })
    
    observe({
      filtered_data = dat() %>% sample_n(., 100)
      leafletProxy('map') %>% clearShapes() %>% addMarkers(lng = filtered_data$longitude, lat = filtered_data$latitude)
      #add circles with heatmaps at each location instead 
    })
    
})


