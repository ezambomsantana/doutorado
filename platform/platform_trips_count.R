
require("XML")
require("plyr")
require("ggplot2")
require("gridExtra")


library(data.table)

xmlfile=xmlParse("/home/eduardo/trips.xml")

pointAttribs <- xpathSApply(doc=xmlfile, path="/scsimulator_matrix/trip",  xmlAttrs)
# TRANSPOSE XPATH LIST TO DF 
df <- data.frame(t(pointAttribs))
# CONVERT TO NUMERIC
df[c('start', 'count')] <- sapply(df[c('start', 'count')],  function(x) as.numeric(as.character(x)))

hours <- c()
val <- 0
interval <- 1800
n <- 20
for (x in 1:n) {
  hours <- c(hours, val)
  val <- val + interval
}

time <- aggregate(df$count, list(cut(df$start, breaks=hours)), sum)

time$horas <- c("6:00", "6:30","7:00", "7:30")
time$x <- time$x/1000

sum(time$x)
theme_set(theme_gray(base_size = 18))
png('trip_count.png')
ggplot(data=time, aes(x=horas, y=x, group=1)) +
  geom_bar(stat="identity", fill="#56B4E9") +
  xlab("Day Time") + ylab("Travel Count (x 1000)")
dev.off()
