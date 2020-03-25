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
import math


plt.rcParams['font.size'] = 14
plt.rcParams['font.family'] = 'sans-serif'
plt.rcParams['font.sans-serif'] = 'Helvetica'
plt.rcParams['font.weight'] = 'bold'
########################################################################
if len(sys.argv[1:]) < 5:
	sys.stderr.write("ERROR: missing argument\nUsage:\npython plot_basemap.py <file.tab> <file_with_locations.txt> <legend_file.txt> <title_legend> <outname> \n")
	sys.exit(1)
	
	
df,locations,lgd_file,t,outname = sys.argv[1:]

df = pd.read_csv(df,sep='\t')
locations = pd.read_csv(locations,sep='\t')
lgd_file = pd.read_csv(lgd_file,sep='\t')

#prepare legend
handles = []
for i in xrange(lgd_file.shape[0]):
	patch=mpatches.Patch(color=lgd_file.iloc[i,1],label=lgd_file.iloc[i,0])
	handles.append(patch)
	
	
fig = plt.figure(figsize=(8,8))
ax = plt.subplot(111)
m = Basemap(width=9000000,height=9000000,llcrnrlon=-7.5600,llcrnrlat=49.7600,
            urcrnrlon=2.7800,urcrnrlat=60.840,
            resolution='i', # Set using letters, e.g. c is a crude drawing, f is a full detailed drawing
            projection='tmerc', # The projection style is what gives us a 2D view of the world for this
            lon_0=-1.36,lat_0=54.7)# Setting the central point of the image
#            epsg=27700) # Setting the coordinate system we're using


m.drawmapboundary(fill_color='white',color='black') # Make your map into any style you like
m.fillcontinents(color="whitesmoke",lake_color='white',zorder=1)

m.drawcoastlines(linewidth=0.5,color='black')
m.drawcountries(linewidth=1,color='whitesmoke')

colors = ['orange','purple','red','gold','navy','thistle','green','dimgray','black']
#function to draw pies
def draw_pie(ax,counts=[0.1,0.1,0.1,0.1,0.1,0.1,0.1,0.1,0.1], X=0, Y=0, size = 1000):
    N = len(counts)
    counts = np.array(counts).astype(int)
    breakdown = [0] + list(np.cumsum(counts.tolist())* 1.0 / sum(counts))
    breakdown = map(lambda x:round(x,3),breakdown)
    #print breakdown
    for i in xrange(N):
        x = [0] + np.cos(np.linspace(2*math.pi*breakdown[i],2*math.pi*breakdown[i+1],20)).tolist()
        y = [0] + np.sin(np.linspace(2*math.pi*breakdown[i],2*math.pi*breakdown[i+1],20)).tolist()
        xy = zip(x,y)
        s1 = np.abs(xy).max()
        ax.scatter([X],[Y] , marker=(xy,0), s=size*s1**2, facecolor=colors[i],alpha=0.7,linewidths=0.8,zorder=2,edgecolor='black')
        
for c,long,lat in locations.values:
	print "Plotting pie chart for city {0}\n".format(c)
	subset = df[df.City==c]
	X,Y = m(long,lat)
	colors = subset.Color.values.tolist()
	#print colors
	draw_pie(ax,subset.Haplo_Counts.values.tolist(), X, Y,size=500)
	
#X,Y = m(-0.088180,51.489767)


#ax.legend(handles=handles,markerscale=1,borderpad=0.2,labelspacing=0.5,loc='lower center',fontsize=14,ncol=3,bbox_to_anchor=(0.5,-0.25),fancybox=True,shadow=False,frameon=True,framealpha=0.5,title=t)
ax.legend(handles=handles,markerscale=1,borderpad=0.2,labelspacing=0.5,loc='upper left',fontsize=18,ncol=1,bbox_to_anchor=(-0.6,0.8),fancybox=True,shadow=False,frameon=True,framealpha=0.5,title=t)
#save plot
plt.subplots_adjust(bottom=0.2)
plt.savefig(outname+".png", format='png', dpi=350)
fig.savefig(outname+".pdf",bbox_inches='tight')
