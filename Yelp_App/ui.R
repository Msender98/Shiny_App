#
# This is the user-interface definition of a Shiny web application. You can
# run the application by clicking 'Run App' above.
#
# Find out more about building applications with Shiny here:
#
#    http://shiny.rstudio.com/
#


# Define UI for application that draws a histogram

demographic_vars = c('Income','Unemployment','Poverty','TotalPop','IncomePerCap','Professional',
                     'Service','Office','Construction', 'Production',
                     'Drive','Carpool','Transit','Walk')

yelp_vars = c('total_business','daily_checkins','review_count','avg_star_2019','sd_2019')

analysis_vars = c('daily_checkins','review_count','avg_star_2019','sd_2019',demographic_vars)

shinyUI(dashboardPage(
    dashboardHeader(title= "Business in Vegas"),
    dashboardSidebar(
        sidebarMenu(
            menuItem('Map', tabName = 'MAP', icon = icon('map')),
            menuItem("Analysis", tabName = 'business', icon = icon('chart-bar'))), 
            h5('  Filter businesses by the selected category:'),
            selectizeInput('category', 'Business Type', choices = category$categories),
            h5('  Uncheck to list closed businesses:'),
            checkboxInput('open','Open Business', value = TRUE), 
            
            
        sidebarMenu( menuItem("Data", tabName = "data", icon = icon("database")),
                     menuItem("About", tabName = 'desc', icon = icon("file-alt")))
    ),
    dashboardBody(
        tabItems(
            tabItem(tabName = 'MAP',
                    fluidPage(
                        leafletOutput('map', height = 650),
                        fluidRow(column(4,
                                        selectizeInput('business', 'Yelp Feature', choices = yelp_vars, selected = 'review_count')
                                        ),
                                 column(4, 
                                        selectizeInput('demo', 'Demographic', choices = demographic_vars, selected = 'Income')
                                        )
                                 ),
                        p('The yelp feature aggregates the chosen yelp data for each region. The radius of the circles indicates 
                          the relative amount of that feature in each region. The demographic dropdown colors each region based on the corresponding demographic.
                           Scroll over a circle to see each feature in detail. 
                          '), br(),
                        h5('Data Dictionary:'), br(),
                        'total_business: The total amount of businesses', br(),
                        'daily_checkins: The average daily checkins for businesses in a region', br(),
                        'review_count: Average number of reviews for each business in a region', br(),
                        'avg_star_2019: Average yelp review stars', br(),
                        'Income: Median income in a region in $', br(),
                        'Unemployment: % Unemployed in a region', br(),
                        'Poverty: % living in poverty in a region', br(),
                        'TotalPop: Total poplution in a region', br(),
                        'IncomePerCap: Income per capita in $', br(),
                        'Professional: % of residents in management, business, science, and arts', br(),
                        'Service: % of residents working in service industry', br(),
                        'Office: % of residents employed in sales and office jobs', br(),
                        'Construction: % of residents employed in natural resources and construction', br(),
                        'Production: % of residents employed in production and transportation', br(),
                        'Drive: % of residents commuting alone in car, van or truck', br(),
                        'Carpool: % of residents carpooling in car, van or truck', br(),
                        'Transit: % of residents commuting on public transportation', br(),
                        'Walk: % of residents walking to work',br()
                        
                        
                    )
                    ),
            tabItem(tabName = "business",
                    fluidPage(
                        
                        plotOutput('plot'),
                        
                        fluidRow(
                            column(3,
                                   checkboxInput('smooth', 'Linear Best Fit', value = FALSE),
                                   checkboxInput('smooth_pm', 'Polynomial Best Fit', value = FALSE)
                                   ),
                            column(5, 
                                   sliderInput('opacity' ,'Opacity', min = 0, max = 1, value = 0.5), offset = 1
                                   ),
                            column(2,
                                   checkboxInput('jitter', 'Add Jitter', value = FALSE)
                                   )
                        ),
                        
                        fluidRow(
                            column(5,
                                   selectizeInput('selectedx', 'X - Axis', 
                                                  choices = analysis_vars),
                                   checkboxInput('logx','Log_x', value = FALSE)
                                   ),
                                
                            column(5,
                                   selectizeInput('selectedy', 'Y - Axis', choices = analysis_vars, selected = 'avg_star_2019'),
                                   checkboxInput('logy','Log_y', value = FALSE) )
                            ),
                        p('Study feature\'s relationships by choosing them in the corresponding dropdowns. Log_y and Log_x will scale the axis logarithmically.  
                           Best fit line draws a best fit line (using ggplot\'s built in geom_smooth function). 
                          '), br(),
                        h5('Data Dictionary'), br(),
                        'avg_star_2019: Average yelp review stars', br(),
                        'review_count: Number of yelp reviews', br(),
                        'daily_checkins: Average daily checkin for a business', br(),
                        'Income: Median income in the businesses reigon in $', br(),
                        'Unemployment: % Unemployed in a region', br(),
                        'Poverty: % living in poverty in a region', br(),
                        'TotalPop: Total poplution in a region', br(),
                        'IncomePerCap: Income per capita in $', br(),
                        'Professional: % of residents in management, business, science, and arts', br(),
                        'Service: % of residents working in service industry', br(),
                        'Office: % of residents employed in sales and office jobs', br(),
                        'Construction: % of residents employed in natural resources and construction', br(),
                        'Production: % of residents employed in production and transportation', br(),
                        'Drive: % of residents commuting alone in car, van or truck', br(),
                        'Carpool: % of residents carpooling in car, van or truck', br(),
                        'Transit: % of residents commuting on public transportation', br(),
                        'Walk: % of residents walking to work',br()
                        
                        )
                             
                    ),
            tabItem(tabName = "data",
                    fluidRow(box(DT::dataTableOutput("table"),
                                 width = '100%'))
                    
                    
                    ),
            tabItem(tabName = "desc",
                    
                    fluidPage(
                    h3("App Description:"),
                    p(
                        "This App was created while studying at the ",
                        a(href = 'https://nycdatascience.com/','NYC Data Science Academy.'),
                        "The data is sourced from:"),
                           
                        a(href = 'https://www.kaggle.com/yelp-dataset/yelp-dataset','Kaggle-Yelp \n'),br(),  
                        a(href = 'https://www.kaggle.com/muonneutrino/us-census-demographic-data','Kaggle-US-Census \n'),  br(),
                        a(href = 'https://geo.fcc.gov/api/census/#!/area/get_area','FCC Census Tract Data'), br(), br(),
                            
                        p(
                    "Yelp business data was joined to the US Census Tract data using the FCC's census API. The app focuses on data from
                    Las Vegas, NV because it is the most complete city in the Yelp Dataset. "
                        ), br(),
                    p("Checkout my code and other projects on my ", a(href = 'https://github.com/Msender98','Github'), '!'), 
                    br(),
                    'Created by Mike Sender'
        
                    
                    ))
            )
        
    )
))

