require("ggplot2")
library(ggpubr)

data <- read.csv("C:/dev/events_complete/events_complete.csv", 
                 header=FALSE, sep = ";", 
                 colClasses= c("integer","character","character","integer","integer","integer"),
                 col.names=c("time","event","vehicle","last_position","duration","distance"))

data_bus <- data[data$distance == 0, ]
data_bus <- data_bus[data_bus$duration < 8000, ]
data_bus$count = 1

horas <- c(0,3600,7200,10800,14400,18000,21600,25200,28800,32400,36000,39600,43200,46800,50400,54000,57600,61200,64800,68400,72000,75600,79200,82800,86400)
time <- aggregate(data_bus$duration, list(cut(data_bus$time, breaks=horas)), FUN=mean)
count <- aggregate(data_bus$count, list(cut(data_bus$time, breaks=horas)), FUN=sum)

time$horasb <- c(5,6,7,8,9,10,11,12,13,14,15,16,17,18,19,20,21,22,23)
time$tempo <- time$x / 60
time$count <- count$x

tempo_medio <- ggplot(time, aes(x = horasb)) + 
  geom_line(aes(y = tempo), color="steelblue") +
  xlab("Hour") + 
  ylab("Average Time (m)") +
  ylim(30, 90)

count <- ggplot(time, aes(x = horasb)) + 
  geom_line(aes(y = count), color='green') + 
  xlab("Hour") + 
  ylab("Trip Count") +
  ylim(2000, 5500)

theme_set(theme_gray(base_size = 18))
png('C:/dev/events_complete/time_distance_bus.png', width = 800, height = 400)

ggarrange(tempo_medio, count,
          labels = c("a)", "b)"),
          ncol = 2, nrow = 1)
dev.off()
