require("XML")
require("plyr")
require("ggplot2")
require("gridExtra")

data <- read.csv("/home/eduardo/events.csv", 
                 header=FALSE, sep = ";", 
                 colClasses= c("integer","character","character","integer","integer","integer"),
                 col.names=c("time","event","vehicle","last_position","duration","distance"))

data_car <- data[data$distance != 0, ]

data_bus <- data[data$distance == 0, ]


horas <- c(0,3600,7200,10800,14400,18000,21600,25200,28800,32400,36000,39600,43200,46800,50400,54000,57600,61200,64800,68400,72000,75600,79200,82800,86400)
time <- aggregate(data_bus$duration, list(cut(data_bus$time, breaks=horas)), FUN=mean)

distance <- aggregate(data_bus$distance, list(cut(data_bus$time, breaks=horas)), FUN=mean)


time$horas <- c(5,6,7,8,9,10,11,12,13,14,15,16,17,18,19,20,21,22,23)
time$distance <- distance$x / 10
time$tempo <- time$x

theme_set(theme_gray(base_size = 18))
png('travel_time_bus.png', width = 600, height = 400)
ggplot(time, aes(x = horas)) + 
  geom_line(aes(y = tempo, colour = "Tempo de Viagem")) +
  scale_colour_manual("Variable", 
                      breaks = c("Tempo Médio de Viagem"),
                      values = c("green")) +
  xlab("Hora do Dia") + ylab("Tempo Médio de Viagem")
dev.off()


