require("ggplot2")
library(ggpubr)

data <- read.csv("/home/eduardo/events_complete.csv", 
                 header=FALSE, sep = ";", 
                 colClasses= c("integer","character","character","integer","integer","integer"),
                 col.names=c("time","event","vehicle","last_position","duration","distance"))

data_car <- data[data$distance != 0, ]
data_car$count = 1
data_car$speed = (data_car$distance / 1000) / ( data_car$duration / 3600)
#data_car <- data_car[grep("25475", data_car$vehicle, invert = TRUE) ,]




data_car_teste <- data_car[data_car$time > 3600,]
data_car_teste <- data_car_teste[data_car_teste$time < 10800,]


horas <- c(0,3600,7200,10800,14400,18000,21600,25200,28800,32400,36000,39600,43200,46800,50400,54000,57600,61200,64800,68400,72000,75600,79200,82800,86400)
time <- aggregate(data_car$duration, list(cut(data_car$time, breaks=horas)), FUN=mean)
distance <- aggregate(data_car$distance, list(cut(data_car$time, breaks=horas)), FUN=mean)
count <- aggregate(data_car$count, list(cut(data_car$time, breaks=horas)), FUN=sum)
speed <- aggregate(data_car$speed, list(cut(data_car$time, breaks=horas)), FUN=mean)


time$horas <- c(0,1,2,3,4,5,6,7,8,9,10,11,12,13,14,15,16,17,18,19,20,21,22,23)
time$distance <- distance$x / 1000
time$tempo <- time$x / 60
time$count <- count$x
time$speed <- speed$x

tempo_medio <- ggplot(time, aes(x = horas)) + 
  geom_line(aes(y = tempo), color="steelblue") +
  xlab("Hora do Dia") + 
  ylab("Duração Média (m)")

distancia <- ggplot(time, aes(x = horas)) + 
  geom_line(aes(y = distance), color='red') + 
  xlab("Hora do Dia") + 
  ylab("Distância por Viagem (km)")

count <- ggplot(time, aes(x = horas)) + 
  geom_line(aes(y = count), color='green') + 
  xlab("Hora do Dia") + 
  ylab("Veículos")

speed_graph <- ggplot(time, aes(x = horas)) + 
  geom_line(aes(y = speed), color='green') + 
  xlab("Hora do Dia") + 
  ylab("Velocidade Média (km/h)")

theme_set(theme_gray(base_size = 16))
png('time_distance_car.png', width = 800, height = 600)

ggarrange(tempo_medio, distancia, count, speed_graph,
          labels = c("a)", "b)", "c)", "d)"),
          ncol = 2, nrow = 2)
dev.off()
