library(jsonlite)

setwd("C:/Users/msend/Projects/NYC_DSA/Shiny")


yelp_business = stream_in(file('./data/yelp_academic_dataset_business.json'))
yelp_checkins = stream_in(file('./data/yelp_academic_dataset_checkin.json'))
yelp_reviews = stream_in(file('./data/yelp_academic_dataset_review.json'))
yelp_tips = stream_in(file('./data/yelp_academic_dataset_tip.json'))
yelp_user = stream_in(file('./data/yelp_academic_dataset_user.json'))

