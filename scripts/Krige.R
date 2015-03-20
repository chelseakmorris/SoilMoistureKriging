#
# Kriging applied to cadmium concentrations
# from Juradata data set (Goovaerts 1997)
# Sullivan
# 
# Set working directory
#
setwd("~/Dropbox/Classwork/Spatial Statistics/project")
#
# Spatial Library
#
library(sp)
#
# Read the data into R
#
HF = read.csv("data/HartfordFarm_SMsamples_cleaned.csv", sep=",")
head(HF)
coordinates(HF)=c("x_proj","y_proj")
#
# Do some simple exploratory analysis of the data
#
hist(HF$Average)
hist(log(HF$Average), main="Log of Soil Moisture")
#
HF$logAverage = log(HF$Average)
# Plot the sample locations
#
par(pty="s")
plot(y_proj~x_proj,data=HF)
title("Soil Moisture Locations")
par(pty="m")
#
#
# Examine the Cd concentrations over the area
#
library(RColorBrewer)
library(classInt)
#
# Plot a point at a location
# The color of the point corresponds to the
# Concentration of cadmium, as specified in the q5Colors object
#
pal = brewer.pal(5,"Blues")
q5 = classIntervals(HF$logAverage, n=5, style="quantile")
q5Colors = findColours(q5,pal)
plot(HF,col=q5Colors,pch=19,axes=T)
legend("bottomleft",fill=attr(q5Colors,"palette"),
	legend = names(attr(q5Colors,"table")),bty="n")
title("Soil Moisture Over Area")
#
#
# Kriging
#
library(gstat)
#
# Calculate the empirical variogram
#
source("scripts/variogram.R")
# SM.vario = variogram(logAverage~1,HF,cressie=F)
# #
# # Plot the empirical variogram
# #
# plot(SM.vario,pch=20,cex=1.5)
# #
# # Fit the model first by eye
# #
# my.psill=0.12
# my.range=450
# my.nugget=0.15
# #
# SM.eye = vgm(model="Sph",psill=my.psill,range=my.range,nugget=my.nugget)
# plot(SM.vario,SM.eye,pch=20,cex=1.5)
# #
# # Now use eye parameters to start fit of model
# #
# #
# SM.fit=fit.variogram(SM.vario,
# 	vgm(model="Sph",psill=my.psill,range=my.range,nugget=my.nugget),
# 	fit.method=1)
# #
# # Look at estimates
# #
# SM.fit
# SM.psill=SM.fit$psill[2]
# SM.range=SM.fit$range[2]
# SM.nugget=SM.fit$psill[1]
# #
# # Plot data, model and parameter estimates
# #
# plot(SM.vario,SM.fit,pch=20,cex=1.5)
# #
# text.x = 0.3*max(Cd.vario$dist)
# text.y = 0.8*max(Cd.vario$gamma)
# text(text.x,text.y,
# 	paste(
# 		"  Psill  = ",round(Cd.psill,2),"\n",
# 		" Range  = ",round(Cd.range,2),"\n",
# 		"Nugget = ",round(Cd.nugget,2),
# 		sep=""),		
# 	cex=1.2,adj=-1)
#
# Create a grid of points to predict over
#
library(geoR)
SM.grid = polygrid(
  xgrid=seq(bbox(boundary)[1,1],bbox(boundary)[1,2],length=50),
  ygrid=seq(bbox(boundary)[2,1],bbox(boundary)[2,2],length=50),
  boundary)
coordinates(SM.grid)=c("x","y")
SM.grid = as(SM.grid, "SpatialPixels")
# Now plot the data and overlay the prediction grid
#
plot(data.frame(SM.grid)$x,data.frame(SM.grid)$y,pch="+")  
points(Yloc~Xloc,cex=1.2,pch=20,col=2)
#
#
# Predict the value at all the points in the domain
#	
Date = DatesUnique[11]
subset = HF[which(HF$Date==Date), ] # Subset for Dates
subset = HF[which(HF$Date=="2012-11-02" & 
                    HF$ID %in% Field.List[[Field]]), ] #Subset for Fields
SM.ok = krige(logAverage~1, subset, SM.grid, DV.20121130.fit)	
#
# Plot the prediction
#
Xloc = data.frame(subset)$x_proj
Yloc = data.frame(subset)$y_proj
range(SM.ok$var1.pred)
pal = brewer.pal(5,"Blues")
q5 = classIntervals(subset$logAverage, n=5, style="quantile")
q5Colors = findColours(q5,pal)
image(SM.ok["var1.pred"],col=q5Colors,axes=T)
mtext(side=1,line=2,"Xloc")
mtext(side=2,line=2,"Yloc")
title("Predicted Soil Moisture Pattern: OK")
legend("topleft",fill=attr(q5Colors,"palette"),
       legend = names((attr(q5Colors,"table")),bty="n")
text(Xloc,Yloc,round(subset$Average))
#
# Plot variance
#
range(SM.ok$var1.var)
image(SM.ok["var1.var"],col=q5Colors,axes=T)
points(Xloc,Yloc,pch="+")
legend("topleft",legend=round(seq(.3,.5,length=4),2),fill=heat.colors(4),
	bty="n",title="Variance")
# points(data.frame(Cd.grid)$Xloc,data.frame(Cd.grid)$Yloc,pch="+")
title("Variance in Predictions: OK")
#

