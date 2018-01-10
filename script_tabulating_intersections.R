###################################################################################################
# Three options for tabulating point intersections in zones and exporting as shapefile 		#
# renatamuy@gmail.com													#
# Based on the tool from Arc Gis and from										#
# https://gis.stackexchange.com/questions/110117/counts-the-number-of-points-in-a-polygon-in-r    #
# Computes the intersection between two feature classes and cross-tabulates the 			#
# count of the intersecting feature 											#
###################################################################################################		

###############################################################################
#     Main Functions used							          #
#	Open and create points and zone file	   					    #
# getData(), spsample(), SpatialPointsDataFrame(),				    #
#	Tabulating intersections			   					    #
# Option 1: over(), table()								    #
# Option 2: poly.counts(), setNames()						    #
# Option 3: colSums(), gContains(), setNames()					    #
###############################################################################

# Set working directory

setwd("F:/__data/muylaert/Div_Reg_Brasil_2017/")

library("raster")
library("sp")

# Open the shapefile with polygons which represents the zones
x <- getData('GADM', country='BRA', level=1)

# Or open ir from the downloaded file
# x <- readRDS("BRA_adm1.rds")

set.seed(1)

# Getting the spatial points
# sample random points
p <- spsample(x, n=300, type="random")
p <- SpatialPointsDataFrame(p, data.frame(id=1:300))

plot(x)
plot(p, col="pink" , add=TRUE)

# Extracting number of points per zone

# Option 1

res <- over(p, x)

# Choose the zone (NAME_1)

count1 <- table(res$NAME_1) # count points
 
# Option 2

# install.packages("GISTools")
library(GISTools)

res2 <- poly.counts(p, x) 

# Choose the zone (NAME_1)

count2 <- setNames(res2, x@data$NAME_1)

# Option 3

res3 <- colSums(gContains(x, p, byid = TRUE))

# Choose the zone (NAME_1)
 
count3 <- setNames(res3, x@data$NAME_1)

# Incorporate data in SpatialPolygonsDataFrame 

countdf <- as.data.frame(count3)
countdf$NAME_1 <- c()
countdf$NAME_1 <- row.names(countdf)
colnames(countdf)<- c("point_count", "NAME_1")
countdf$point_pct <- 100*(countdf$point_count)/sum(countdf$point_count)

x_point_count <- x
x_point_count@data <- merge(x@data, countdf, by = "NAME_1")

# Export as shapefile

writeOGR(x_point_count, ".", driver ='ESRI Shapefile', "x_point_count")

# Plot

# Defining colors
hist(x_point_count@data$point_count)

x_point_count@data$COLOUR <- "#FFFFFF"
x_point_count@data$COLOUR[x_point_count@data$point_count == 0] <- "#6DAC8F"

# More than 0 less than 20

x_point_count@data$COLOUR[x_point_count@data$point_count > 0 &
x_point_count@data$point_count < 10		] <- "#31A354"
x_point_count@data$COLOUR[x_point_count@data$point_count >= 10 &
		x_point_count@data$point_count <= 20 ]  <- "#78C679"

# More than 20 and less than max

x_point_count@data$COLOUR[x_point_count@data$point_count > 20 &
		x_point_count@data$point_count < max(x_point_count@data$point_count) ]  <- "#C2E699"

# Max value

x_point_count@data$COLOUR[x_point_count@data$point_count == max(x_point_count@data$point_count) ] <- "#257A53" 

# Plot

plot(x_point_count, col=x_point_count@data$COLOUR, border=NA)

# Improve it!
legend("bottomright", legend= unique(x_point_count@data$COLOUR), 
       fill=x_point_count@data$COLOUR, 
       bty="n", # turn off the legend border
       cex=.8) # decrease the font / legend size

##############################################

