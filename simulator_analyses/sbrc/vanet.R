data1 <- read.csv("/home/eduardo/Doutorado/sbrc/test_clean.ns3", 
                  header=FALSE, sep = ";", 
                  colClasses= c("integer","integer","integer","numeric","numeric","character","integer"),
                  col.names=c("time","time_origin","id","lat","long","mac", "number"))

time <- aggregate(data1$number, list(data1$time), mean)

theme_set(theme_gray(base_size = 18))
png('num_conexoes.png')
  ggplot(data=time, aes(x=Group.1, y=x, group=1)) +
    geom_line(stat="identity", color="steelblue") +
    xlab("Tempo da Simulação") + ylab("Número Médio de Conexões")
dev.off()

data1$type <- "" 
theme_set(theme_gray(base_size = 18))
png('num_conexoes_box_plot.png')
  ggplot(data1, aes(x=type, y=number)) + geom_boxplot() +
    ylab("Média de Conexões dos Veículos") + xlab("")
dev.off()
