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
        filter(is_open == input$open) %>%
        select(stars, !!as.name(input$selected)) %>% 
        mutate(xaxis = !!as.name(input$selected)) 
    })
    
    output$plot <- renderPlot({
          ggplot(data = dat(), aes(x = xaxis, y = stars)) + geom_boxplot() + ggtitle('Stars')
    })
})


