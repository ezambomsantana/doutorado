require("XML")
require("plyr")
require("ggplot2")
require("gridExtra")

library(data.table)

setwd("/home/eduardo/saidas")

xmlfile=xmlParse("events2.xml")

pointAttribs <- xpathSApply(doc=xmlfile, path="/events/event[@type='arrival']",  xmlAttrs)
# TRANSPOSE XPATH LIST TO DF 
df <- data.frame(t(pointAttribs))
# CONVERT TO NUMERIC
df[c('time', 'trip_time', 'distance', 'cost')] <- sapply(df[c('time', 'trip_time', 'distance','cost')],  function(x) as.numeric(as.character(x)))

df[c('action')] <- sapply(df[c('action')], function(x) factor(x))
df[c('legMode')] <- sapply(df[c('legMode')], function(x) factor(x))

hist(df$trip_time)

horas <- c(0,3600,7200,10800,14400,18000,21600,25200,28800,32400,36000,39600,43200,46800,50400,54000,57600,61200,64800,68400,72000,75600,79200,82800,86400)
time <- aggregate(df$trip_time, list(cut(df$time, breaks=horas)), FUN=mean)
mean(df$trip_time)

distance <- aggregate(df$distance, list(cut(df$time, breaks=horas)), FUN=mean)


time$horas <- c(0,1,2,3,4,5,6,7,8,9,10,11,12,13,14,15,16,17,18,19,20,21,22,23)
time$distance <- distance$x / 10
time$tempo <- time$x


png('time_distance.png')
ggplot(time, aes(x = horas)) + 
  geom_line(aes(y = tempo, colour = "Travel Time")) + 
  geom_line(aes(y = distance, colour = "Distance")) + 
  scale_colour_manual("Variable", 
                      breaks = c("Travel Time", "Distance"),
                      values = c("red", "green")) +
  xlab("Time of the Day") + ylab("Time (Seconds) and Distance (Meters * 10)")
dev.off()
