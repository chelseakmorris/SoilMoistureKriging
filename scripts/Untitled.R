# Chelsea K Morris
# Spatial Statistics Project
#
# This script is for looking at STI and SM relationships
library(raster)
#
# See STI.TI.r and variogram.r to set up data
STI= raster("~/Dropbox/N Budget @ Harford Farm/DataFromJanet/sti_10_usgsfi")
HF$STI = extract(STI, HF)
plot(HF$logAverage~HF$STI, xlab= "Soil Topographic Index", 
     ylab="log(Average Soil Moisture)")
abline(lm(HF$logAverage~HF$STI))
#
HF$Slope=extract(slope, HF)
HF$Trans=extract((Ksat * SoilDep), HF)
#
Field=4
print(paste("Mean Slope Field", Field, ":", 
            mean(HF$Slope[which(HF$ID %in% Field.List[[Field]])]), sep=""))
print(paste("Mean Trans Field", Field, ":", 
            mean(HF$Trans[which(HF$ID %in% Field.List[[Field]])]), sep=""))

#
# Mixed Effects Model
#
library(nlme)
#
HF.gls = gls(logAvg~SD+STI,data=HF)
summary(coal.gls)
#
# Let me try this... may have to think about it more
#
gls.resid=resid(coal.gls)
gls.vgram = variogram(gls.resid~1,data=coal.ash)
#
# I set psill to Residual Standard Error from summary() is that right?
# range and nugget from summary() too
#
gls.eye = vgm(model="Sph",psill=1.12,range=1.377,nugget=0.093)
plot(gls.vgram,gls.eye,pch=16,cex=1.5,lwd=2)
