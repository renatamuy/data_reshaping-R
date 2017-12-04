####################################################
# Reshape 2 quick guidelines
# http://seananderson.ca/2013/10/19/reshape.html
####################################################

######################### Wide to long: melt

require(reshape2)

data(airquality)

head(airquality)

# To lower case with the colnames

names(airquality) <- tolower(names(airquality))

head(airquality)

# To long without reference
# mixes everything in classes with values.. ozone, day, temp...

aql <- melt(airquality)

head(aql)

# id.vars willt tell what each row will contain
# the id.vars will form unique combinations if
# there are more than 2 equal combinations?

aql <- melt(airquality, id.vars = c("month", "day"))
head(aql)
tail(aql)

# Now lets say that wind, temp, and solar rays are the 
# "climate variables" we measured, just changing
# the names of the variable and value for a 
# more specific name
# It seems to be a silly step, but it is usef

head(airquality)
aql <- melt(airquality, id.vars = c("month", "day"),
  variable.name = "climate_variable", 
  value.name = "climate_value")
head(aql)

######################### Long to wide: cast

# Long to wide is not so simple..
# Head scratching you will do ---- :D
# dcast is for dataframes
# Use trial and error to your favor!

# So we have a melted data

aql <- melt(airquality, id.vars = c("month", "day"))

head(aql)
nrow(aql)

# Lets make it wide, putting the climate variables in different columns

aqw <- dcast(aql, month + day ~ variable)

head(aqw)
nrow(aqw) 

# Look! 
nrow(airquality)

# So ~ variable is what you want to be in columns (swing)!

# CAUTION
# If I don´t say the both ids, it will work as a table() for all measurements per month..

dcast(aql, month ~ variable)
nrow(dcast(aql, month ~ variable))

dcast(aql, day ~ variable)
nrow(dcast(aql, day ~ variable))

# So let´s make a summary!

dcast(aql, month ~ variable, fun.aggregate = mean, 
  na.rm = TRUE)

dcast(aql, day ~ variable, fun.aggregate = mean, 
  na.rm = TRUE)




