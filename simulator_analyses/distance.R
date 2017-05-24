#install.packages("XML")
#install.packages("plyr")
#install.packages("ggplot2")
#install.packages("gridExtra")

require("XML")
require("plyr")
require("ggplot2")
require("gridExtra")


library(data.table)

setwd("C:/Users/ezamb/Desktop/scenario")

xmlfile=xmlParse("Log1.xml")


pointAttribs <- xpathSApply(doc=xmlfile, path="/events/event[@type='arrival']",  xmlAttrs)
  # TRANSPOSE XPATH LIST TO DF 
df <- data.frame(t(pointAttribs))
  # CONVERT TO NUMERIC
df[c('time', 'trip_time', 'distance')] <- sapply(df[c('time', 'trip_time', 'distance')], 
                                       function(x) as.numeric(as.character(x)))

df[c('action')] <- sapply(df[c('action')], function(x) factor(x))
 
boxplot( df$distance ~ df$action,data=df)
