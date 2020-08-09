import pandas as pd
from fcc_api import get_block_fips


yelp_business = pd.read_csv('./data/yelp_business.csv',sep = ';',encoding = 'latin-1')