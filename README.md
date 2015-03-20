# SoilMoistureKriging
Spatial Statistics Class Project

###Introduction

Soil moisture patterns are important to predicting water quality of the runoff generated. Much
attention in hydrology is paid to soil moisture as a risk indicator of surface runoff generation e.g.
Pearce et al. (1986); Bronstert and Plate (1997); Meyles et al. (2003). Surface runoff quickly transports
water to streams causing pulses of high flow that increase flooding potential, impact wildlife
habitat, and transport sediment and dissolved contaminants from the land surface. The ability to
predict where and when runoff is likely to be generated guides the planning and implementation
of management practices that reduce these negative impacts.


Traditionally, the temporal and spatial variability of soil moisture patterns is identified through
two approaches. Complex, distributed hydrologic models such as the Soil Moisture Routing
model Frankenberger et al. (1999) predict patterns fairly well, but require climate and landscape
data at fine resolutions to be reliable. In contrast, indices that draw on watershed-level hydrologic
drivers such as terrain and soil properties can provide fast, simple estimates of soil moisture patterns.
These topographic indices, originally developed by Beven and Kirkby (1979), can be used
to quickly estimate patterns in regions where soil moisture spatial variability is driven by topographic
changes and shallow soil depths. In the Northeastern United States, topographic indices
have been shown to work well to predict soil moisture patterns Buchanan et al. (2013).
Soil moisture measurements can be collected rapidly and easily in the field, however due to
signfiicant spatial and temporal variability, achieving a coverage for watersheds is a time-intensive
endevor. Remote sensing techniques are in development, but the resolution of their predicitions is
too coarse for meaningful guidance in management practices Wagner et al. (2007). In this project
we are interested in using geostatistics and the topographic index models to extroplate soil moisture
measurements for comparison with patterns predicted by a more complicated, uncalibrated
hydrologic model. To do this, we use a geostatistical tool for characterizing spatial patterns, the
semivariogram model. Semivariograms quantify the change in variance between two points in
a field based on their distance. The sill represents the distance at very large distances (large being
relative to the data). The distance at which the sill is stable is considered the range. At this
distance, spatial correlation no longer exists. The variance in repeated measurements at the same
location is given as the nugget of the semivariogram.


Kriging is a geostatistical technique that makes use of the semivariogram for interpolating data
where it does not exist. Kriging with additional information, such as the output of the topographic
index models, can be used to influence the spatial pattern. This is particularly useful where linear
distance is not the only important correlation for a spatial pattern. In the case of soil moisture, a
location in a stream may be continually saturated to a similar degree as a location far downstream
that is also along a high accumalting flowpath. A location much closer in spatial distance to the
saturated area may be significantly drier, perhaps because of a steep slope that transmits water
away quickly. For this reason, straight kriging with the soil moisture data will present limited
spatial results. In some variograms the range will occur at very close distances or spatial correlation
will not be apparent. In this project we investigate the locations and dates where good spatial
correlation is evident and use topographic index information to improve kriging predictions.

###Methods
####Study area
This project concerns an agricultural watershed in Central New York (Figure 1). Soil moisture
measurements were taken in several fields owned and managed by a dairy farm. The fields are
moderately sloping (% range TBD) with silty loam soils underlaid by a shallow restrictive layer,
often called a frangipan (average depth TBD). The low permeability of this restrictive layer prevents
water in the shallow subsurface from draining rapidly and sets up conditions for overland
runoff by a saturation-excess process Walter et al. (2003); Easton et al. (2008).

####Field Data
A total of 1,956 volumetric water content measurements at 81 locations were taken using a Time
Domain Reflectrometry (TDR) probe across transects of agricultural fields. The sampling design
was clustered in 9 fields. For this project, two individual fields were evaluated, as their clustering
design more reliably showed spatial correlation. (Figure 2). At least three readings per location
were taken. Their position was recorded using GPS units with horizontal accuracy to about 3
meters. Measurements were collected fall of 2012 and spring, summer, and fall of 2013. Measurements
were made at least 24 hours after larger storm events (when precipitation exceeded 6
mm).

####Source Data
Terrain and soil characteristics were obtained from publicly available sources at United States
Geological Survey (USGS) and United States Department of Agriculture Natural Resource Conservation
Service (USDA-NRCS), respectively. 10-meter digital elevation maps (DEMs) from the
National Elevation Dataset were processed to calculate local slope and area upslope contributing
to shallow subsurface flow. Saturated hydraulic conductivity and soil depth to the restrictive
layer were taken from the Soil Survey Geographic (SSURGO) database. The soil data was used to
calculate the soil’s transmissivity properties.

####Variograms
The empirical variogram characterizes the spatial variability in the soil moisture data. A variogram
for each sampling date (n=14) and each field cluster (n=9) were plotted and a spherical
model fitted the variogram. The variograms by date are used in the kriging methods to define
the measure of spatial correlation. Variogram parameters consist of a nugget (the variance of a
repeated measurement in the same location), sill (the limit of the variance), and the range (the
distance at which spatial correlation has a declining effect). Because of the clustered sampling
procedure, the range of the variogram occurs much closer than the farthest distance between two
points. Observations outside of the cluster are deemed to have very little effect on the local conditions.
