library(ggmap)

data1 <- read.csv("/home/eduardo/Doutorado/sbrc/test_clean.ns3", 
                  header=FALSE, sep = ";", 
                  colClasses= c("integer","integer","integer","numeric","numeric","character","integer"),
                  col.names=c("time","time_origin","id","lat","long","mac", "number"))


time <- aggregate(data1$number, list(data1$time), mean)



theme_set(theme_gray(base_size = 18))
png('num_conexoes.png', width = 800, height = 600)
ggplot(data=time, aes(x=Group.1, y=x, group=1)) +
  geom_line(stat="identity", color="steelblue") +
  xlab("Minutos da Simulação") + ylab("Número Médio de Conexões")
dev.off()


theme_set(theme_gray(base_size = 16))
png('num_conexoes_box_plot.png', width = 800, height = 600)
boxplot(data1$number)
dev.off()
