# Chelsea K Morris
# Spatial Statistics Project
#
# This scripts builds and fits some variograms for the soil moisture data at
# Harfod Farm.
#
setwd("~/Dropbox/Classwork/Spatial Statistics/project/")
library(sp)
library(gstat)
library(rgdal)
#
library(RColorBrewer)
library(classInt)
#
HF = read.csv("data/HartfordFarm_SMsamples_cleaned.csv", sep=",")
#
# # Describing the data
# sum(!is.na(HF$SM1))+sum(!is.na(HF$SM2))+sum(!is.na(HF$SM3))+sum(!is.na(HF$SM4))+
#   sum(!is.na(HF$SM5))+sum(!is.na(HF$SM6))+sum(!is.na(HF$SM7))
# #
coordinates(HF)=c("x_proj","y_proj")
#
boundary = readOGR("data/FarmBoundary", "farm_rev")
#
par(pty="s")
pal = brewer.pal(5,"Blues")
q5 = classIntervals(HF$Average, n=5, style="quantile")
q5Colors = findColours(q5,pal)
plot(boundary, lwd=2, axes=T)
plot(HF,col=q5Colors,pch=19,cex=1.25, axes=T, add=TRUE)
#legend("topleft",fill=attr(q5Colors,"palette"),
#       legend = names(attr(q5Colors,"table")),bty="n")
par(pty="m")
#
# Plotting All Observations by Date 
#
HF$Date = as.Date(HF$Date, format="%m/%d/%y")
DatesUnique = unique(HF$Date)
DatesUnique = DatesUnique[order(DatesUnique)]
#
hist(HF$Average)
hist(log(HF$Average), main="Log of Soil Moisture")
#
HF$logAverage = log(HF$Average)
#
# for (i in 1:length(DatesUnique)){
#   plot(boundary, lwd=2, axes=T)
#   plot(HF[which(HF$Date==DatesUnique[i]), ], col=q5Colors,pch=19,cex=1.5,
#        axes=T, add=T)
#   title(DatesUnique[i])
# #legend("bottomleft",fill=attr(q5Colors,"palette"),
# #       legend = names(attr(q5Colors,"table")),bty="n")
# }
#
# Plotting Observation by Date and Field
Field.List = list(F1 = c("HF007","HF008","HF009","HF010","HF019","HF031","HF032","HF034","HF035","HF036","HF037","HF038","HF039","HF040","HF041","HF042","HF043","HF056","HF057"), 
                        F2 = c("HF045","HF059","HF060","HF55","HF56","HF57","HF59","HF6","HF60"),
                        F3 = c("HF7","HF10","HF11","HF12","HF13","HF31","HF32","HF33","HF46","HF51","HF52","HF53","HF54"),
                        F4 = c("HF058","HF14","HF15","HF16","HF17","HF18","HF19","HF20","HF21","HF22","HF23","HF24","HF25","HF340","HF40","HF42","HF43","HF45","HF47","HF50","HF61","HF35","HF58"),
                        F5 = c("HF28","HF29","HF30","HF341","HF36","HF37","HF38","HF39","HF41","HF62"),
                        F6 = c("HF26","HF27"),
                        F7 = c("HF35", "HF38"),
                        F8 = c("HF046", "HF34", "HF48"),
                        F9 = c("HF13"),
                        F10 = c("HF045","HF059","HF060","HF55","HF56","HF6","HF60"),
                        F11 = c("HF058","HF14","HF15","HF16","HF17","HF18","HF19","HF20","HF21","HF22","HF23","HF24","HF25","HF340","HF40","HF42","HF43","HF45","HF47","HF50","HF61"))
#
Field = 1 # Field number in Field.List
par(pty="s")
Fieldset = HF[which(HF$ID %in% Field.List[[Field]]), ]
DatesUnique = unique(Fieldset$Date)
for (i in 1:length(DatesUnique)){
  plot(boundary, lwd=2, axes=T)
  q5 = classIntervals(HF$logAverage, n=5, style="quantile")
  q5Colours = findColours(q5,pal)
  plot(HF[which( HF$Date==DatesUnique[i] & HF$ID %in% Field.List[[Field]]), ],
       col=q5Colours,pch=19,axes=T, cex=3, add=T)
  #legend("topleft",fill=attr(q5Colours,"palette"),
        # legend = names(attr(q5Colours,"table")),bty="n")  
  title(paste(DatesUnique[i], ": Field ", Field, sep=""))
}
par(pty="m")
#  
# Empirical Variogram
#
# Variogram by Date
vario.date = function(FullDataset, Date){
  subset = FullDataset[which(FullDataset$Date==Date), ]
  vario = variogram(logAverage~1, data=subset)
return (vario)
}
#
for (i in 1:length(DatesUnique)){
  Date = DatesUnique[i]
  assign(paste("DV", format(Date,"%Y%m%d"), sep="."),vario.date(HF, Date))
}
#
# Plot the Date Variograms
plot.vario = function(vario, date, field="All"){
  plot(vario, main=paste(date, field, sep=":"), col="blue", pch=19, cex=2)
}
plot.vario(DV.20120823, date=DatesUnique[1])
plot.vario(DV.20120906, date=DatesUnique[2])
plot.vario(DV.20120919, date=DatesUnique[3])
plot.vario(DV.20121024, date=DatesUnique[4])
plot.vario(DV.20121102, date=DatesUnique[5])
plot.vario(DV.20121109, date=DatesUnique[6])
plot.vario(DV.20121116, date=DatesUnique[7])
plot.vario(DV.20121130, date=DatesUnique[8])
plot.vario(DV.20130419, date=DatesUnique[9])
plot.vario(DV.20130516, date=DatesUnique[10])
plot.vario(DV.20130627, date=DatesUnique[11])
plot.vario(DV.20130718, date=DatesUnique[12])
plot.vario(DV.20130815, date=DatesUnique[13])
plot.vario(DV.20131026, date=DatesUnique[14])
#
# Fit the model
my.psill = 0.17
my.range = 250
my.nugget = 0.05
assign(paste("DV.20130815", "fit", sep="."), 
       fit.variogram(DV.20130815, vgm(model="Sph",psill=my.psill,range=my.range,
                                      nugget=my.nugget), fit.method=1))
plot(DV.20130815,DV.20130815.fit,pch=20,cex=1.5, main=paste("2013-08-15"))
plot(DV.20130815,DV.20130815.fit,pch=20,cex=1.5, main=paste("2013-08-15"))
#
# Variogram by Date and Field
#
vario.field = function(FullDataset, Date, Field.List, Field){
  Fieldset = FullDataset[which(FullDataset$ID %in% Field.List[[Field]]), ]
  #DatesUnique = unique(Fieldset$Date)
  #for (i in 1:length(DatesUnique)){
    subset = Fieldset[which(Fieldset$Date == Date),]
    #assign(paste("FV", format(DatesUnique[i],"%Y%m%d"), 
     #            Field, sep="."), variogram(logAverage~1, data=subset))
    vario=variogram(logAverage~1, data=subset)
  #}
  return (vario)
}
#
for (j in 1:length(Field.List)){
    Field = j
    Fieldset = HF[which(HF$ID %in% Field.List[[Field]]), ]
    DatesUnique = unique(Fieldset$Date)
    for (i in 1:length(DatesUnique)){
    assign(paste("FV", Field, format(DatesUnique[i],"%Y%m%d"), sep="."),
           vario.field(HF, DatesUnique[i], Field.List, Field))
    }
}
#
# Plot the Field Variograms
plot.vario(FV.4.20121130, date="20121130", field="4")
#
# Fit the Field Variograms
my.psill = 5
my.range = 5
my.nugget = 0.2
assign(paste("FV.20121109", "fit", sep="."), 
       fit.variogram(FV.20121109, vgm(model="Sph",psill=my.psill,range=my.range,
                                      nugget=my.nugget), fit.method=1))
plot(FV.20121109,FV.20121109.fit,pch=20,cex=1.5)