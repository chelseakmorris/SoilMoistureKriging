# Chelsea K Morris
# Spatial Statistics Project
#
# This script is for cokriging the soil moisture data 
#
# Multivariate plots using lattice library
#
library(lattice)
library(sp)
data(meuse)
coordinates(meuse)=c("x","y")
#
# What does the meuse dataset contain?
#
names(meuse)
#
# Histograms of original data
#
par(mfrow=c(2,2))
hist(meuse$cadmium,main="Cadmium")
hist(meuse$copper,main="Copper")
hist(meuse$lead,main="Lead")
hist(meuse$zinc,main="Zinc")
par(mfrow=c(1,1))
#
# Histograms of log data
#
par(mfrow=c(2,2))
hist(log(meuse$cadmium),main="log(Cadmium)")
hist(log(meuse$copper),main="log(Copper)")
hist(log(meuse$lead),main="log(Lead)")
hist(log(meuse$zinc),main="log(Zinc)")
par(mfrow=c(1,1))
#
# Add log versions to meuse data object
#
meuse$LogCadmium = log(meuse$cadmium)
meuse$LogCopper = log(meuse$copper)
meuse$LogLead = log(meuse$lead)
meuse$LogZinc = log(meuse$zinc)
#
# Take a look at the datasets together
#
library(RColorBrewer)
library(classInt)
#
pal = brewer.pal(5,"Blues")
par(mfrow=c(2,2),mar=c(0,0,0,0)+.5)
#
q5 = classIntervals(meuse$LogCadmium, n=5, style="quantile")
q5Colors = findColours(q5,pal)
plot(meuse,col=q5Colors,pch=19,axes=F)
title("LogCadmium")
#
q5 = classIntervals(meuse$LogCopper, n=5, style="quantile")
q5Colors = findColours(q5,pal)
plot(meuse,col=q5Colors,pch=19,axes=F)
title("LogCopper")
#
q5 = classIntervals(meuse$LogLead, n=5, style="quantile")
q5Colors = findColours(q5,pal)
plot(meuse,col=q5Colors,pch=19,axes=F)
title("LogLead")
#
q5 = classIntervals(meuse$LogZinc, n=5, style="quantile")
q5Colors = findColours(q5,pal)
plot(meuse,col=q5Colors,pch=19,axes=F)
title("LogZinc")
#
par(mfrow=c(1,1),mar=c(5, 4, 4, 2) + 0.1)
#
# Create multivariate variograms
#
library(gstat)
#
# Append the information together
#
g = gstat(NULL,"LogCd",LogCadmium~1,meuse)
g = gstat(g,"LogCu",LogCopper~1,meuse)
g = gstat(g,"LogPb",LogLead~1,meuse)
g = gstat(g,"LogZn",LogZinc~1,meuse)
#
vm = variogram(g)
#
vm.fit = fit.lmc(vm, g, vgm(1,"Sph",800,1))
#
plot(vm,vm.fit)
#
#
# Now we do cokriging
#
data(meuse.grid)
coordinates(meuse.grid)=c("x","y")
#
cok.maps = predict(vm.fit, meuse.grid)
#
# Examine what is contained in prediction object
#
names(cok.maps)
#
# Plot just the predictions
#
spplot(cok.maps,c("LogCd.pred","LogCu.pred","LogPb.pred","LogZn.pred"))
#
# I don't like the scaling of the responses
# So I do each individually here
#
spplot(cok.maps,c("LogCd.pred"),pch=15,
   scale=list(draw=T),key.space=list(x=0.1,y=.95,corner=c(0,1)),
   main="LogCd")
#
spplot(cok.maps,c("LogCu.pred"),pch=15,
   scale=list(draw=T),key.space=list(x=0.1,y=.95,corner=c(0,1)),
   main="LogCu")
#
spplot(cok.maps,c("LogPb.pred"),pch=15,
   scale=list(draw=T),key.space=list(x=0.1,y=.95,corner=c(0,1)),
   main="LogPb")
#
spplot(cok.maps,c("LogZn.pred"),pch=15,
   scale=list(draw=T),key.space=list(x=0.1,y=.95,corner=c(0,1)),
   main="LogZn")



