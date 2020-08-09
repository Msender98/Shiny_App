import requests

def get_block_fips(latitude,longitude):
    '''
    Gets the census block_fips of a latitude and longitude using: 
    https://geo.fcc.gov/api/census/#!/area/get_area
    '''
    r = requests.get(f'https://geo.fcc.gov/api/census/area?lat={latitude}&lon={longitude}&format=json')
    if(r.status_code==200):
        try :
            r.json()['results']
            return(r.json()['results'][0]['block_fips'][0:11])
        except (KeyError, IndexError):
            return None
    else:
        return None
    