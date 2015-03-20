## Spatial Statistics Project
# Calculating TI and STI
# 12 April 2014
#
require(raster)
require(rgdal)
#
# Input Files:
# elev = elevation raster, m
# contrib = upslope contributing area, dimensionless
# slope = slope raster, rise over run
# Ksat = saturated hydraulic conductivity raster, microm/s
# SoilDep = depth to restrictive layer raster, cm
#
watershed = "south"
s.elev = raster(paste("~/Dropbox/GIS/Harford Area DEM/", watershed, "dem", sep=""))
s.contrib = raster(paste("~/Dropbox/GIS/Harford Area DEM/", watershed, "flow", sep=""))
s.slope = raster(paste("~/Dropbox/GIS/Harford Area DEM/", watershed, "Slope", sep=""))
s.Ksat = 86.4 * raster(paste("~/Dropbox/GIS/Harford Farm/Soils/", watershed, "ksat", sep=""))
s.SoilDep = 0.01 * raster(paste("~/Dropbox/GIS/Harford Farm/Soils/", watershed, "soildep", sep=""))
#
watershed="north"
n.elev = raster(paste("~/Dropbox/GIS/Harford Area DEM/", watershed, "dem", sep=""))
n.contrib = raster(paste("~/Dropbox/GIS/Harford Area DEM/", watershed, "flow", sep=""))
n.slope = raster(paste("~/Dropbox/GIS/Harford Area DEM/", watershed, "Slope", sep=""))
n.Ksat = 86.4 * raster(paste("~/Dropbox/GIS/Harford Farm/Soils/", watershed, "ksat", sep=""))
n.SoilDep = 0.01 * raster(paste("~/Dropbox/GIS/Harford Farm/Soils/", watershed, "soildep", sep=""))
#
elev=merge(s.elev, n.elev)
contrib=merge(s.contrib, n.contrib)
slope=merge(s.slope, n.slope)
Ksat=merge(s.Ksat, n.Ksat)
SoilDep=merge(s.SoilDep, n.SoilDep)
#
# Resample Soils Rasters to Match Rasters Derived from DEM
Ksat = resample(Ksat, slope, method="bilinear")
SoilDep = resample(SoilDep, slope, method="bilinear")
#
# Change zero slope to a very small slope
slope[slope%in%0] = 0.1
# Topographic Index
TI = log ( contrib / tan(slope) )
# Soil Topographic Index
STI = log ( contrib / (Ksat * SoilDep* tan(slope)) )
#
# Write Rasters to file
writeRaster(TI, filename=paste("~/Dropbox/Classwork/Spatial Statistics/project/data/", 
                               watershed, "_TI.grd", sep=""), overwrite=TRUE)
writeRaster(STI, filename=paste("~/Dropbox/Classwork/Spatial Statistics/project/data/", 
                               watershed, "_STI.grd", sep=""), overwrite=TRUE)
####
#
# Field Properties

