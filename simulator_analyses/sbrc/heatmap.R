
library(ggmap)

data1 <- read.csv("/home/eduardo/Doutorado/sbrc/events_lat_long.", 
                 header=FALSE, sep = ",", 
                 colClasses= c("integer","character","character","numeric","numeric"),
                 col.names=c("time","event","vehicle","lat","long"))


tartu_map <- get_map(location = "são paulo", maptype = "roadmap", zoom = 14)
ggmap(tartu_map, extent = "device") +
  geom_density2d(data = data1, 
                 aes(x = long, y = lat), size = 0.3) + stat_density2d(data = data1, 
                      aes(x = long, y = lat, fill = ..level.., alpha = ..level..), size = 0.01, 
           bins = 16, geom = "polygon") + scale_fill_gradient(low = "green", high = "red") + 
  scale_alpha(range = c(0, 0.3), guide = FALSE)
