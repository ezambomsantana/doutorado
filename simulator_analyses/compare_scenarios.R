#install.packages("XML")
#install.packages("plyr")
#install.packages("ggplot2")
#install.packages("gridExtra")

require("XML")
require("plyr")
require("ggplot2")
require("gridExtra")


library(data.table)

setwd("/home/eduardo/saida")

xmlfile=xmlParse("events_normal.xml")

pointAttribs <- xpathSApply(doc=xmlfile, path="/events/event[@type='arrival']",  xmlAttrs)
# TRANSPOSE XPATH LIST TO DF 
df <- data.frame(t(pointAttribs))
# CONVERT TO NUMERIC
df[c('time', 'trip_time', 'distance', 'cost')] <- sapply(df[c('time', 'trip_time', 'distance','cost')],  function(x) as.numeric(as.character(x)))

df[c('action')] <- sapply(df[c('action')], function(x) factor(x))
df[c('legMode')] <- sapply(df[c('legMode')], function(x) factor(x))

xmlfile2 = xmlParse("events_novo.xml")

pointAttribs2 <- xpathSApply(doc=xmlfile2, path="/events/event[@type='arrival']",  xmlAttrs)
# TRANSPOSE XPATH LIST TO DF 
df2 <- data.frame(t(pointAttribs2))
# CONVERT TO NUMERIC
df2[c('time', 'trip_time', 'distance', 'cost')] <- sapply(df2[c('time', 'trip_time', 'distance', 'cost')], 
                                                          function(x) as.numeric(as.character(x)))

df2[c('action')] <- sapply(df2[c('action')], function(x) factor(x))
df2[c('legMode')] <- sapply(df2[c('legMode')], function(x) factor(x))

df = df[!(apply(df, 1, function(y) any(y == 0))),]
df2 = df2[!(apply(df2, 1, function(y) any(y == 0))),]

sum(df$cost)
sum(df2$cost)

mean(df$trip_time)
mean(df2$trip_time)

df_normal = df
df_novo = df2

keeps <- c("person")
df_normal = df_normal[keeps]

df_novo = df_novo[keeps]

require(sqldf)

a1NotIna2 <- sqldf('SELECT distinct substr(person,0,4) FROM df')
a1NotIna3 <- sqldf('SELECT * FROM df_normal EXCEPT SELECT * FROM df_novo')
a1NotIna4 <- sqldf('SELECT * FROM df_novo EXCEPT SELECT * FROM df_normal')

boxplot(df$cost ~ df$legMode)


boxplot(df2$cost ~ df2$legMode)
