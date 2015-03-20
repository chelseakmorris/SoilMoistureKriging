# Figures and tables

# Table data
setwd("~/Dropbox/Classwork/Spatial Statistics/project/")
HF = read.csv("data/HartfordFarm_SMsamples_cleaned.csv", sep=",")
HF$Date = as.Date(HF$Date, format="%m/%d/%y")
Weather = read.csv("data/HarfordFarmClimate.csv", sep=",")
Weather$DATE = as.Date(Weather$DATE)

Field=2
Fieldset = HF[which(HF$ID %in% Field.List[[Field]]), ]
FieldDatesUnique = unique(Fieldset$Date)
FieldDatesUnique = FieldDatesUnique[order(FieldDatesUnique)]
date=12
n=which(Weather$DATE == FieldDatesUnique[date])
t = Fieldset[which(Fieldset$Date == FieldDatesUnique[date]),]
d =c(t$SM1, t$SM2, t$SM3, t$SM4, t$SM5, t$SM6, t$SM7)
FieldDatesUnique[date]
sum(Weather$PRCP[(n-7):(n-1)])
mean(d, na.rm=TRUE)
sd(d, na.rm=TRUE)
sum(!is.na(d))

DatesUnique = unique(HF$Date)
DatesUnique = DatesUnique[order(DatesUnique)]
Conditions = list()
date=2
n=which(Weather$DATE == DatesUnique[date])
t = HF[which(HF$Date == DatesUnique[date]),]
d =c(t$SM1, t$SM2, t$SM3, t$SM4, t$SM5, t$SM6, t$SM7)
Conditions= data.frame(Date = c(DatesUnique[date]), Precip = c(sum(Weather$PRCP[(n-7):(n-1)])), AvgVWC = c(mean(d, na.rm=TRUE)), SDVMC = c(sd(d, na.r8m=TRUE)), Size = c(sum(!is.na(d))))

# Field Locations
par(pty="s")
png("~/Dropbox/Classwork/Spatial Statistics/project/images/FieldLoc.png", width=500)
plot(boundary, lwd=2, axes=T)
plot(HF, pch=16, axes=T, cex=1, add=T)
plot(HF[which(HF$ID %in% Field.List[[1]]), ],
     col="#2c7fb8", pch=16, axes=T, cex=1, add=T)
plot(HF[which(HF$ID %in% Field.List[[2]]), ],
     col="#7fcdbb",pch=16, axes=T, cex=1, add=T)
legend("bottomleft", legend=c("1", "2"), col=c("#2c7fb8", "#7fcdbb"), bty="n", pch=c(16, 16))
dev.off()
par(pty="m")

# Topographic Index Figure
par(pty="s")
png("~/Dropbox/Classwork/Spatial Statistics/project/images/STILoc.png", height=400)
plot(HF[which(HF$ID %in% Field.List[[1]] | HF$ID %in% Field.List[[2]] ), ],
    pch=1, axes=T, cex=1)
plot(STI, add=T)
plot(HF[which(HF$ID %in% Field.List[[1]] | HF$ID %in% Field.List[[2]] ), ],
     pch=1, axes=T, cex=1, add=T)
legend("bottomleft", legend=c("Sample Locations"), col=c("black"), bty="n", pch=c(1))
dev.off()
par(pty="m")
