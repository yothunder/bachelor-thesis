import os
os.environ['PROJ_LIB']='C:/Anaconda3/pkgs/basemap-1.2.0-py37h4e5d7af_0/Lib/site-packages/mpl_toolkits/basemap'
import matplotlib.pyplot as plt
from netCDF4 import Dataset as netcdf_dataset
import numpy as np
import matplotlib.colors as colors
from cartopy import config
import cartopy.crs as ccrs
import cartopy.mpl.ticker as cticker
import matplotlib.patches as mpatches
from mpl_toolkits.basemap import Basemap
from matplotlib.patches import Polygon
from matplotlib.collections import PatchCollection
from matplotlib.patches import PathPatch

sf = ('D:/APP/datadasarGIS/DATA_SIG/idn-ADM/IDN_adm1')

# make a colormap that has land and ocean clearly delineated and of the
# same length (256 + 256)
colors_undersea = plt.cm.terrain(np.linspace(0, 0.17, 256))
colors_land = plt.cm.terrain(np.linspace(0.25, 1, 256))
all_colors = np.vstack((colors_undersea, colors_land))
terrain_map = colors.LinearSegmentedColormap.from_list('terrain_map',
    all_colors)

# make the norm:  Note the center is offset so that the land has more
# dynamic range:
divnorm = colors.TwoSlopeNorm(vmin=-6000, vcenter=0, vmax=3000)

# get the path of the file. It can be found in the repo data directory.
fname = os.path.join(config["repo_data_dir"],
#                     'netcdf', 'D:/APP/GRADS/topografi.nc'
                     'netcdf', 'D:/script/CS/#OLAH/data/etopo/hawaii_soest_bc8b_7e44_d573_b923_1dc8_5ee3.nc'
                     )
#fname = os.path.join(config["repo_data_dir"],
#                     'netcdf', 'D:/APP/etopo/ETOPO1_Ice_g_gmt4.grd'
#                     )
fig = plt.figure(figsize=(11,8.5), dpi=300)
#fig, (ax1, ax2) = plt.subplots(1, 2)
dataset = netcdf_dataset(fname)
dset = netcdf_dataset(fname)
topo = dataset.variables['b_bathy'][0, :, :]
#b_bathy
lats = dataset.variables['latitude'][:]
lons = dataset.variables['longitude'][:]
ax1 = plt.subplot(1, 2, 1, projection=ccrs.PlateCarree())
ax2 = plt.subplot(1, 2, 2, projection=ccrs.PlateCarree())
#ax1 = plt.axes(projection=ccrs.PlateCarree())
#ax2 = plt.axes(projection=ccrs.PlateCarree())

gl1 = ax1.gridlines(crs=ccrs.PlateCarree(),draw_labels=False, 
                  linewidth=1, color='gray', alpha=0.5, linestyle='--')
gl1.xlabels_top = False
gl1.ylabels_right = False
gl1.xlines = False
gl1.ylines = False

gl2 = ax2.gridlines(crs=ccrs.PlateCarree(),draw_labels=False, 
                  linewidth=1, color='gray', alpha=0.5, linestyle='--')
gl2.xlabels_top = False
gl2.ylabels_right = False
gl2.xlines = False
gl2.ylines = False
      
def plot_cities(ax1):
    # plot city dots with annotation, finalize plot
    # lat/lon coordinates of five cities in Bangladesh
    lats = [3.91206, -2.17, -6.1234, -0.14206]	
    lons = [108.39, 106.13, 106.652, 109.45]
    cities = ['WION', 'WIKK', 'WIII', 'WIOO']
    for lon, lat, city in zip(lons, lats, cities):
        ax1.plot(lon, lat, 'ro', zorder=5, markersize=6, transform=ccrs.PlateCarree())
        ax1.text(lon +0.6, lat-0.4, city, fontsize="xx-small", visible=True, fontfamily="serif", 
                color='black', bbox=dict(facecolor='white', edgecolor='None', pad=1.0),
                transform=ccrs.PlateCarree())
def plot_labelregion(ax):
    # plot city dots with annotation, finalize plot
    # lat/lon coordinates of five cities in Bangladesh
    lats = [17, 7, 1.6, -4.5]	
    lons = [110, 105, 105, 111.5]
    cities = ['(A)', '(B)', '(C)', '(D)']
    for lon, lat, city in zip(lons, lats, cities):
        #ax1.plot(lon, lat, 'ro', zorder=5, markersize=6, transform=ccrs.PlateCarree())
        ax.text(lon +0.6, lat-0.4, city, fontsize="medium", visible=True, fontfamily="serif", 
                color='black', bbox=dict(facecolor='white', edgecolor='None', pad=1.0),
                transform=ccrs.PlateCarree())

# MDN 98.67437, 3.56352, 
#plot_cities(ax1)
plot_labelregion(ax2)

ax1.text(95.2, 23.5, "(a)", fontsize="xx-large", visible=True, fontfamily="serif", 
                color='black', bbox=dict(facecolor='white', edgecolor='None', pad=1.0),
                transform=ccrs.PlateCarree())
ax2.text(95.2, 23.5, "(b)", fontsize="xx-large", visible=True, fontfamily="serif", 
                color='black', bbox=dict(facecolor='white', edgecolor='None', pad=1.0),
                transform=ccrs.PlateCarree())

level = [-4000, -2000, -1000, -100, 0, 100, 500, 1000, 2000, 3000]
level1 = np.linspace(0, 3000, 100)
peta1 = ax1.contourf(lons, lats, topo, 60,
             transform=ccrs.PlateCarree(), levels=level, norm=divnorm, cmap=terrain_map, extend='both')
peta2 = ax2.contourf(lons, lats, topo, 60,
             transform=ccrs.PlateCarree(), levels=level, norm=divnorm, cmap=terrain_map, extend='both')
#peta = plt.contourf(lons, lats, topo, transform=ccrs.PlateCarree())


lon_formatter = cticker.LongitudeFormatter()
lat_formatter = cticker.LatitudeFormatter()

ax1.set_extent([95, 125, -10, 25], crs=ccrs.PlateCarree())
ax1.coastlines()
ax1.set_xticks(np.arange(100,125,5), crs=ccrs.PlateCarree())
ax1.xaxis.set_major_formatter(lon_formatter)
ax1.set_yticks(np.arange(-5,25,5), crs=ccrs.PlateCarree())
ax1.yaxis.set_major_formatter(lat_formatter)

ax2.set_extent([95, 125, -10, 25], crs=ccrs.PlateCarree())
ax2.coastlines()
ax2.set_xticks(np.arange(100,125,5), crs=ccrs.PlateCarree())
ax2.xaxis.set_major_formatter(lon_formatter)
#ax2.set_yticks(np.arange(-5,25,5), crs=ccrs.PlateCarree())
#ax2.yaxis.set_major_formatter(lat_formatter)


ax1.add_patch(mpatches.Rectangle(xy=[110, 8], width=6, height=7,
                                edgecolor='red', facecolor='None', linewidth = 4.0,
                                alpha=1, rasterized=False,
                                transform=ccrs.PlateCarree()))
ax1.add_patch(mpatches.Rectangle(xy=[105, -5], width=5, height=5,
                                edgecolor='red', facecolor='None', linewidth = 4.0,
                               alpha=1, rasterized=False,
                                transform=ccrs.PlateCarree()))                               
ax2.add_patch(mpatches.Rectangle(xy=[110, 9], width=8, height=9,
                                edgecolor='yellow', facecolor='None', linewidth = 2.0,
                               alpha=1, rasterized=False,
                                transform=ccrs.PlateCarree()))
ax2.add_patch(mpatches.Rectangle(xy=[105, 3], width=7.5, height=5,
                                edgecolor='yellow', facecolor='None', linewidth = 2.0,
                               alpha=1, rasterized=False,                               
                                transform=ccrs.PlateCarree()))
ax2.add_patch(mpatches.Rectangle(xy=[105, -2.5], width=4, height=5,
                                edgecolor='yellow', facecolor='None', linewidth = 2.0,
                               alpha=1, rasterized=False,
                                transform=ccrs.PlateCarree()))
ax2.add_patch(mpatches.Rectangle(xy=[106.5, -6], width=8, height=2.5,
                                edgecolor='yellow', facecolor='None', linewidth = 2.0,
                               alpha=1, rasterized=False,     
                                transform=ccrs.PlateCarree()))
#ax1.set_xticks(ax1.get_xticks())
#ax1.set_yticks(ax1.get_yticks())
#plt.subplot(1,2,1)
#ax1.plot()
#plt.subplot(1,2,2)
#ax2.plot()
#plt.colorbar(peta1=peta2, label='(meter)', pad=0.04)
#cbar = plt.colorbar(ax=ax2)
#fig.tight_layout()
# Adjust the location of the subplots on the page to make room for the colorbar
fig.subplots_adjust(bottom=0.225, top=0.9, left=0.1, right=0.9,
                    wspace=0.02, hspace=0.02)

# Add a colorbar axis at the bottom of the graph
cbar_ax = fig.add_axes([0.2, 0.2, 0.6, 0.02])

# Draw the colorbar
cbar=fig.colorbar(peta1, cax=cbar_ax,orientation='horizontal',label='(meter)')

plt.savefig('D:/script/CS/#PROS/minprosOKsip.png',dpi=600)
plt.show()
