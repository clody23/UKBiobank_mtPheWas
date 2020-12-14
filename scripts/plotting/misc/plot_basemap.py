#!/usr/bin/env python
import sys
import numpy as np # linear algebra
import pandas as pd # data processing, CSV file I/O (e.g. pd.read_csv)

import matplotlib as matpl
matpl.use('Agg')
import matplotlib.pyplot as plt
import matplotlib.cm

from mpl_toolkits.basemap import Basemap
from matplotlib.patches import Polygon
from matplotlib.collections import PatchCollection
from matplotlib.colors import Normalize

import matplotlib.pyplot as plt
import matplotlib.cm
 
from mpl_toolkits.basemap import Basemap
from matplotlib.patches import Polygon
from matplotlib.collections import PatchCollection
from matplotlib.colors import Normalize
import matplotlib.patches as mpatches


plt.rcParams['font.size'] = 14
plt.rcParams['font.family'] = ['sans-serif']
plt.rcParams['font.sans-serif'] = ['Helvetica']
########################################################################
if len(sys.argv[1:]) < 3:
	sys.stderr.write("ERROR: missing argument\nUsage:\npython plot_basemap.py <file.tab>  <legend_file.txt> <outname> \n")
	sys.exit(1)
	
	
df,lgd_file,outname = sys.argv[1:]

df = pd.read_csv(df,sep='\t')
lgd_file = pd.read_csv(lgd_file,sep='\t')

#prepare legend
handles = []
for i in xrange(lgd_file.shape[0]):
	patch=mpatches.Patch(color=lgd_file.iloc[i,1],label=lgd_file.iloc[i,0])
	handles.append(patch)
	
	

#prepare plot
fig, ax = plt.subplots(figsize=(8,8))
m = Basemap(llcrnrlon=-7.5600,llcrnrlat=49.7600,
            urcrnrlon=2.7800,urcrnrlat=60.840,
            resolution='i', # Set using letters, e.g. c is a crude drawing, f is a full detailed drawing
            projection='tmerc', # The projection style is what gives us a 2D view of the world for this
            lon_0=-4.36,lat_0=54.7, # Setting the central point of the image
            epsg=27700) # Setting the coordinate system we're using

m.drawmapboundary(fill_color='#e6f9ff') # Make your map into any style you like
m.fillcontinents(color='#f9f9eb',lake_color='#e6f9ff',zorder=1)
m.drawcoastlines(linewidth=1)
#m.drawrivers(linewidth=0.5) # Default colour is black but it can be customised
m.drawcountries(linewidth=1)

#plot each point onto map
for i in xrange(df.shape[0]):
	x = df.Easting[i]
	y = df.Northing[i]
	print i,df.Color[i]
	m.plot(x,y,marker = 'o',color=None,markersize=3,alpha=0.5,latlon=False,markeredgecolor="black", markerfacecolor=df.Color[i],markeredgewidth=0.2)
	
ax.legend(handles=handles,markerscale=2,borderpad=0.2,labelspacing=0.5,loc='right',fontsize=14,ncol=1,bbox_to_anchor=(1.3,0.5),fancybox=True,shadow=False,frameon=True,framealpha=0.7)

#save plot
plt.savefig(outname+".png", format='png', dpi=300)
fig.savefig(outname+'.pdf')
