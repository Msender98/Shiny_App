library(tidyverse)
#Initialize data

yelp_business = read.csv2('./data/yelp_business.csv', stringsAsFactors = FALSE, header = TRUE)
yelp_checkins = read.csv2('./data/yelp_checkins.csv', stringsAsFactors = FALSE, header = TRUE)
yelp_reviews = read.csv2('./data/yelp_reviews.csv', stringsAsFactors = FALSE, header = TRUE)
yelp_tips = read.csv2('./data/yelp_tips.csv', stringsAsFactors = FALSE, header = TRUE)
yelp_user = read.csv2('./data/yelp_user.csv', stringsAsFactors = FALSE, header = TRUE)


#censusTract data, and bounding boxes!! 
business_tract = read.csv('./data/business_census_tract.csv')
nevada_geocodes = read.csv('./data/nevada_bbox.csv')
nevada_geocodes = nevada_geocodes %>% mutate(bbox = lapply(str_split(bbox,','), function(x) as.numeric(gsub('\\[|\\]| ',"", x)))) %>% select(CensusTract, bbox)

#acs_census data :)))
census_2017 = read.csv('./data/acs2017_census_tract_data.csv')

unpack_bbox = function(x,n){unlist(x[n])}

nevada_geocodes = nevada_geocodes %>% mutate(lng1 = unlist(lapply(bbox, function(x) x[1])), lat1 = unlist(lapply(bbox, function(x) x[4])), lng2 = unlist(lapply(bbox, function(x) x[3])), lat2 = unlist(lapply(bbox, function(x) x[2]))) %>% left_join(., census_2017, by = c('CensusTract' = 'TractId'))

nevada_geocodes = nevada_geocodes %>% mutate(., centerlat = (lat1+lat2)/2, centerlng = (lng1+lng2)/2) 

library(lubridate)

split_category = function(category){
  categories = strsplit(category, ',')
  return(lapply(categories, str_trim))
}
annual_analysis = function(yelp_data, year_,id){
  review_sum = yelp_reviews %>% filter(., year(date) <= year_) %>% group_by_at(id) %>% 
    summarize(!!sprintf('num_review_%s',year_) := n(), 
              !!sprintf('avg_star_%s',year_) := mean(stars), 
              !!sprintf('sd_%s',year_) := sd(stars))
  
  return(yelp_data %>% left_join(.,review_sum, by = id))
  
}
#filter to Nevada and add censusTract and census data:
yelp_nevada = yelp_business %>% filter(., state == 'NV') %>% 
  mutate(.,categories = split_category(categories)) %>%
  inner_join(., business_tract, by = 'business_id') %>% 
  inner_join(., census_2017, by = c('CensusTract' = 'TractId')) %>%
  annual_analysis(., 2019, 'business_id') %>%
  mutate(latitude = as.numeric(latitude), longitude = as.numeric(longitude))
#tidy up checkin data and filter to Nevada 2019
yelp_nevada_checkins = yelp_checkins %>% 
  inner_join(., select(yelp_nevada, 'business_id', 'latitude','longitude'), by = 'business_id') %>%
  mutate(date = str_split(date,','))  %>% 
  unnest(date) %>% 
  filter(year(date) >=2019) %>%
  mutate(longitude = as.numeric(longitude), latitude = as.numeric(latitude)) %>% 
  mutate(date = parse_datetime(date)) %>%
  filter(!is.na(latitude) | !is.na(longitude))
#Add average daily checkins value
yelp_nevada = yelp_nevada_checkins %>% 
  mutate(date = ymd(sprintf('%s/%s/%s',year(date),month(date),day(date)))) %>%
  group_by(business_id, date) %>% count() %>% group_by(business_id) %>% 
  summarise(daily_checkins =  mean(n)) %>% 
  right_join(., yelp_nevada, by = 'business_id')

category = yelp_nevada %>% select(-starts_with("hours"), -starts_with("attribute")) %>%
  unnest(categories) %>%
  select(name, categories) %>%
  count(categories) %>%
  arrange(desc(n)) %>% 
  slice_max(., n, n = 10) %>% 
  transmute(categories)

#Add center of census tract:
nevada_geocodes = nevada_geocodes %>% mutate(., centerlat = (lat1+lat2)/2, centerlng = (lng1+lng2)/2)