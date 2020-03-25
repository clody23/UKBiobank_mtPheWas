#!/usr/bin/env python

import sys
import pandas as pd
import reverse_geocoder as rg
#from geopy.geocoders import Nominatim
#geolocator = Nominatim(timeout=100)
#geolocator = Nominatim(user_agent="cc926")
#from geopy.extra.rate_limiter import RateLimiter
#geocode = RateLimiter(geolocator.geocode, min_delay_seconds=1)

ifile,outfile = sys.argv[1:]
ifile = pd.read_csv(ifile,sep='\t',header=None)

lat=2
lon=1

coord = zip(ifile[lat],ifile[lon])
results = rg.search(coord)
UK_region = map(lambda x:x['admin1'],results)
UK_county = map(lambda x:x['admin2'],results)
UK_city = map(lambda x:x['name'],results)

df=pd.DataFrame(UK_region)
ifile.insert(3,'UK_region',UK_region)
ifile.insert(4,'UK_county',UK_county)
ifile.insert(5,'UK_city',UK_city)
ifile.columns = ['FID','WGS84_east','WGS84_north','UK_region','UK_county','UK_city']
ifile.to_csv(outfile,sep='\t',header=True,index=None,na_rep="NA")


