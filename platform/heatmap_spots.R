
library(ggmap)

data1 <- read.csv("/home/eduardo/park_teste.csv", 
                  header=FALSE, sep = ";", 
                  colClasses= c("character","character","numeric","numeric"),
                  col.names=c("time","event","lat","long"))


tartu_map <- get_map(location = c(lat = -23.572916, lon = -46.665779), maptype = "roadmap", zoom = 12)
ggmap(tartu_map, extent = "device") +
 # geom_point(aes(x = lon, y = lat), colour = "red", 
#                                                 alpha = 0.1, size = 0.5, data = data1)
  geom_density2d(data = data1, 
                 aes(x = long, y = lat), size = 0) + stat_density2d(data = data1,  
                                                                      aes(x = long, y = lat, fill = ..level.., alpha = ..level..), size = 0, show.legend = FALSE, 
                                                                      bins = 300, geom = "polygon") + scale_fill_gradient(low = "green", high = "red") + 
scale_alpha(range = c(0, 0.3), guide = FALSE)
