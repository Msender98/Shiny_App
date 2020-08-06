library(jsonlite) 

jsonfile = 'yelp_academic_dataset_business.json'

yelp_business = stream_in(file(jsonfile))
yelp_checkins = stream_in(file('yelp_academic_dataset_checkin.json'))

str(yelp_business)
head(yelp_business)
str(yelp_reviews)
