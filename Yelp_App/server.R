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
      yelp_nevada %>% filter(unlist(lapply(.$categories, function(x) input$category %in% x))) %>%
        filter(is_open == input$open)
    })
    
    color_data = reactive({
      nevada_geocodes %>% 
        mutate(color = select(.,contains(input$demo))[[1]]) 
    })
    
    
    output$map <- renderLeaflet({
      leaflet(options = leafletOptions(minZoom = 10)) %>% addTiles() %>% fitBounds(-115.49, 35.9, -114.8, 36.44)  
 
    })
    
    
    output$plot <- renderPlot({
          g = ggplot(data = dat(), aes_string(x = input$selectedx, y = input$selectedy)) + geom_point() + ggtitle('Stars')
          if(input$logx){g = g + scale_x_log10()}
          if(input$logy){g = g + scale_y_log10()}
          g
    })
    
    
    observe({
      
      if(input$business == 'total_business'){
        dat = dat()
        filt_data = dat %>% group_by(CensusTract) %>%
                            select(.,CensusTract,'business_id') %>%
                            count %>% transmute(total_business = n)
        min_n = min(filt_data$total_business)
        max_n = max(filt_data$total_business)
        filt_data = filt_data %>% mutate(colum = total_business) %>% mutate(normalized_colum = (total_business-min_n)/(max_n-min_n))
        
      }else{
        dat = dat()
        filt_data = dat %>% mutate(., colum = select(.,contains(input$business))[[1]]) %>%
                            group_by(CensusTract) %>% 
                            filter(!is.na(colum)) %>%
                            summarise(colum = mean(colum)) %>% 
                            mutate(normalized_colum = normalize(colum))
      }
      
      geo_color = color_data()
      
      pal = colorBin("plasma", geo_color$color)
     
      
      
      geo_data = geo_color %>% left_join(.,filt_data, by = 'CensusTract')
       
      leafletProxy('map', data = geo_data) %>% clearShapes() %>% clearControls() %>%
            addCircles(lat = geo_data$centerlat, lng = geo_data$centerlng, 
                       radius = geo_data$normalized_colum*2500, 
                       fillColor = ~pal(geo_data$color), 
                       fillOpacity = .5,
                       stroke = FALSE,
                       label = paste(sprintf('%s: %.0f',input$business, geo_data$colum)," | ",sprintf('%s: %.0f',input$demo, geo_data$color))
                         ) %>% 
            addLegend(position = 'topright',
                      pal = pal,
                      values = geo_color$color,
                      title = input$demo)
            
      #add circles with heat maps at each location instead. Circle radius represent business (# of business. Or #of checkins. Or avg stars.)
      #Colored by demographic. Income, ...
    })
    
    
    
}) 


