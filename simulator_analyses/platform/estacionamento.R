library(ggmap)

data1 <- read.csv("/home/eduardo/Doutorado/vagas.csv", 
                  header=FALSE, sep = ";", 
                  colClasses= c("character","character","numeric","numeric"),
                  col.names=c("time","event","lat","long"))


tartu_map <- get_map(location = "são paulo", maptype = "roadmap", zoom = 12)


png('mapa_calor.png', width = 600, height = 600)
ggmap(tartu_map, size = c(600, 600)) +
  geom_density2d(data = data1, 
                 aes(x = long, y = lat), size = 0.3) + stat_density2d(data = data1, 
                                                                      aes(x = long, y = lat, fill = ..level.., alpha = ..level..), size = 0.01, 
                                                                      bins = 16, geom = "polygon") + scale_fill_gradient(low = "green", high = "red") + 
  scale_alpha(range = c(0, 0.3), guide = FALSE)

dev.off()
