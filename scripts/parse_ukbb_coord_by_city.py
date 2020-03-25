#!/usr/bin/env python
import sys
import numpy as np # linear algebra
import pandas as pd # data processing, CSV file I/O (e.g. pd.read_csv)

if len(sys.argv[1:]) < 3:
	sys.stderr.write("ERROR: missing argument\nUsage:\npython plot_basemap.py <file.tab> <file_with_coord.txt> <outname>\n\n")
	sys.exit(1)
	

filea,coord_uk,outname = sys.argv[1:]
filea = pd.read_csv(filea,sep='\t')
coord_uk = pd.read_csv(coord_uk,sep='\t')


#example with london
cities = pd.unique(coord_uk.City)
total_samples_captured = 0
haplo_series = pd.DataFrame(['H','I','J','K','T','U','V','W','X'])
haplo_series.columns = ['Haplogroups']
df = pd.DataFrame()
print "Calculate percentages of individuals for each of these cities:\n\n"
for i in cities:
	print i,'\n'
	min_long = coord_uk[coord_uk.City==i].Long.min()
	max_long = coord_uk[coord_uk.City==i].Long.max()
	min_lat = coord_uk[coord_uk.City==i].Lat.min()
	max_lat = coord_uk[coord_uk.City==i].Lat.max()
	iix_long = (filea.WGS84_east.values>=min_long) & (filea.WGS84_east.values<=max_long)
	iix_lat = (filea.WGS84_north.values>=min_lat) & (filea.WGS84_north.values<=max_lat)
	subset = filea[(iix_long & iix_lat)]
	print 'found {0} individuals at {1} coordinates...\n\n'.format(str(subset.shape[0]),i)
	total_samples_captured += subset.shape[0]
	df_tmp = pd.DataFrame(subset.groupby('Macro_haplo').count().iloc[:,0])
	df_tmp.insert(0,'Haplogroups',df_tmp.index)
	#calculate percentage
	s = sum(subset.groupby('Macro_haplo').count().values[:,0])
	fr = map(lambda x:round(float(x)/s,2),subset.groupby('Macro_haplo').count().values[:,0])
	df_tmp.insert(1,'Fractions_per_Haplogroup',fr)
	df_tmp.insert(0,'City',i)
	df_tmp = pd.merge(haplo_series,df_tmp,on=['Haplogroups'],how='left')
	df = pd.concat([df, df_tmp], axis=0)
	
p_total = round((float(total_samples_captured)/filea.shape[0])*100,2)
print "Total samples captures by these coordinates is {0}, which corresponds to {1} percentage of samples\n".format(str(total_samples_captured),str(p_total))

df.columns=['Haplogroups','City','Haplo_Fraction','Haplo_Counts']

df.to_csv(outname,header=True,index=None,sep='\t',na_rep=0)
