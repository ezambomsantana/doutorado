
require("XML")
require("plyr")
require("ggplot2")
require("gridExtra")

library(dplyr)
library(data.table)

setwd("/home/eduardo/")


xmlfile = xmlParse("saidas/events_normal.xml")
#xmlfile=xmlParse("events_normal_just_arrivals.xml")

pointAttribs <- xpathSApply(xmlfile, "/events/event[@type='arrival']",  xmlAttrs)

# TRANSPOSE XPATH LIST TO DF 
df <- data.frame(t(pointAttribs))

# CONVERT TO NUMERIC
df[c('time')] <- sapply(df[c('time')],  function(x) as.numeric(as.character(x)))

data_start_travel_time <- data.frame(Start_Travel_Time = df$time / 3600)
names <- c("Start Travel Time")
colors <- c("#56B4E9")
  
theme_set(theme_gray(base_size = 18))
png('hist_cost_diff.png')
ggplot(melt(data_start_travel_time), aes(value, fill=variable)) + geom_histogram(binwidth=1, position="dodge") +
  scale_fill_manual("Scenarios", labels = names, values = colors) +
  xlab("Financial cost gain (BRL)") + ylab("Number of Persons") +
  theme(legend.position="bottom")
dev.off()


mode = c("Car", "Bus", "Walk", "Subway")
count = c(dim(filter(hflights_df, legMode == "car"))[1], dim(filter(hflights_df, legMode == "bus"))[1],
      dim(filter(hflights_df, legMode == "walk"))[1], dim(filter(hflights_df, legMode == "metro"))[1])

count_data_car <- data.frame( mode, count)

colors <- c("#999999", "#E69F00", "#56B4E9", "#009E73")

theme_set(theme_gray(base_size = 18))
png('bar_mode.png')
ggplot(data=count_data_car, aes(x=mode, y=count)) +
  geom_bar(stat="identity", fill= colors)+
  xlab("Travel Mode") + ylab("Number of Persons") + 
  theme(legend.position="bottom")
dev.off()
