#install.packages("XML")
#install.packages("plyr")
#install.packages("ggplot2")
#install.packages("gridExtra")

require("XML")
require("plyr")
require("ggplot2")
require("gridExtra")


library(data.table)

setwd("C:/dev/")

xmlfile=xmlParse("events_normal.xml")

pointAttribs <- xpathSApply(doc=xmlfile, path="/events/event[@type='arrival']",  xmlAttrs)
# TRANSPOSE XPATH LIST TO DF 
df <- data.frame(t(pointAttribs))
# CONVERT TO NUMERIC
df[c('time', 'trip_time', 'distance', 'cost')] <- sapply(df[c('time', 'trip_time', 'distance','cost')], 
                                                 function(x) as.numeric(as.character(x)))

df[c('action')] <- sapply(df[c('action')], function(x) factor(x))


hist(df$trip_time)

xmlfile2 = xmlParse("events_novo.xml")

pointAttribs2 <- xpathSApply(doc=xmlfile2, path="/events/event[@type='arrival']",  xmlAttrs)
# TRANSPOSE XPATH LIST TO DF 
df2 <- data.frame(t(pointAttribs2))
# CONVERT TO NUMERIC
df2[c('time', 'trip_time', 'distance', 'cost')] <- sapply(df2[c('time', 'trip_time', 'distance', 'cost')], 
                                                 function(x) as.numeric(as.character(x)))

df2[c('action')] <- sapply(df2[c('action')], function(x) factor(x))


mean(df$cost)
mean(df2$cost)

mean(df$trip_time)

mean(df2$trip_time)
