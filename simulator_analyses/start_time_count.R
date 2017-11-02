
require("XML")
require("plyr")
require("ggplot2")
require("gridExtra")


library(data.table)

setwd("/home/eduardo/entrada/od")

xmlfile=xmlParse("trips2.xml")

pointAttribs <- xpathSApply(doc=xmlfile, path="/scsimulator_matrix/trip",  xmlAttrs)
# TRANSPOSE XPATH LIST TO DF 
df <- data.frame(t(pointAttribs))
# CONVERT TO NUMERIC
df[c('start', 'count')] <- sapply(df[c('start', 'count')],  function(x) as.numeric(as.character(x)))

hist(df$start)

horas <- c(0,3600,7200,10800,14400,18000,21600,25200,28800,32400,36000,39600,43200,46800,50400,54000,57600,61200,64800,68400,72000,75600,79200,82800,86400)
time <- aggregate(df$count, list(cut(df$start, breaks=horas)), sum)

time$horas <- c(0,1,2,3,4,5,6,7,8,9,10,11,12,13,14,15,16,17,18,19,20,21,22,23)
time$x <- time$x / 1000

ps <- data.frame(xspline(time[,1:2], shape=-0.2, lwd=2, draw=F))
ggplot(data=time, aes(x=horas, y=x, group=1)) +
  geom_bar(stat="identity", fill="#56B4E9") +
  xlab("Hour of the Day") + ylab("Number of People (x 1000)")
