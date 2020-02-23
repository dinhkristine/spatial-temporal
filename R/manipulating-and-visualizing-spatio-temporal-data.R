

#### packages ---- 

library(sp)
library(tigris)
library(RColorBrewer)
library(maps)


#### data ---- 

graffiti <- read.csv("data/get_it_done_graffiti_removal_requests_datasd_v1.csv")

graffiti$POSIX_requested <- strptime(graffiti$date_requested, format = "%Y-%m-%dT%T", 
                                     tz = "America/Los_Angeles")

graffiti_sp19 <- graffiti[graffiti$POSIX_requested > "2019-03-21" & 
                            graffiti$POSIX_requested < "2019-06-22", ]


#### spatio ---- 

coordinates(graffiti_sp19) <- c("lng", "lat")


#### tracts ----- 

tracts_sd <- tracts(state = "CA", county = "San Diego")

plot(tracts_sd, xlim = c(-117.3, -116.8), ylim = c(32.5, 33))

points(graffiti_sp19, col = "darkred", pch = 16, cex = 0.3)


#### tracts ---- 

proj4string(graffiti_sp19) <- proj4string(tracts_sd)

graffiti_tract <- over(SpatialPoints(graffiti_sp19@coords), 
                       SpatialPolygons(tracts_sd@polygons))

graffiti_tract_table <- table(graffiti_tract)


#### GIS ---- 

GPT <- rep(0, length(tracts_sd))

GPT[as.numeric(names(graffiti_tract_table))] <- graffiti_tract_table

tracts_sd$GPT <- GPT

spplot(tracts_sd, zcol = "GPT", xlim = c(-117.3, -116.8), ylim = c(32.5, 33))


#### colors ---- 

map("county", "CA", fill = TRUE, lwd = 2, border = 7:10, col = 1:2)

spplot(tracts_sd, zcol = "GPT", xlim = c(-117.3, -116.8), ylim = c(32.5, 33),
       col.regions = brewer.pal(n = 9, name = "BuPu"), cuts = 8)


#### fort collins ---- 

fc <- tracts(state = "CO", county = "Larimer")

plot(fc, border = "black")

points(-105.0844, 40.5853, pch = 16, col = "darkgreen")



