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
    
    output$plot <- renderPlot({
          ggplot(data = dat(), aes_string(x = input$selected, y = 'stars')) + geom_boxplot() + ggtitle('Stars')
    })
})


