args = commandArgs(trailingOnly=TRUE)

if(length(args)!=2) {
  stop("At least two arguments must be supplied (working directory and input file)", call.=FALSE)
} else {
  setwd(args[1])
  data <- read.csv(args[2], header=TRUE, sep=',')
}


require("ggplot2")

data <- read.csv("/home/eduardo/response_time.csv", header=TRUE, sep=',',
                 colClasses= c("character","character","character","integer","character","numeric","numeric"),
                 )

data['request_sum'] <- 1
data['request_sum'] <- sapply(data['request_sum'], function(x) as.numeric(x))
horas <- c()
val <- min(data$request_time_mili)
for (x in 1:50) {
  horas <- c(horas, val)
  val <- val + 60000
}

time <- aggregate(data$request_sum, list(cut(data$request_time_mili, breaks=horas)), sum)

png('load.png')
ggplot(data=time, aes(x=Group.1, y=request_sum, group=1)) +
  geom_bar(stat="identity", fill="#56B4E9") +
  xlab("Hora do Dia") + ylab("Número de Viagens (x 1000)")
dev.off()

horas <- c()
val <- min(data$response_time_mili)
for (x in 1:50) {
  horas <- c(horas, val)
  val <- val + 60000
}

time <- aggregate(data$request_sum, list(cut(data$response_time_mili, breaks=horas)), sum)
time$horas <- c(1:43)

png('throughput.png')
ggplot(data=time, aes(x=horas, y=request_sum, group=1)) +
  geom_bar(stat="identity", fill="#56B4E9") +
  xlab("Hora do Dia") + ylab("Número de Viagens (x 1000)")
dev.off()





rate_data <- split(data, data$result)
success <- rate_data[['success']]
error <- rate_data[['error']]

success$response_time <- success$response_time_mili - success$request_time_mili

success['simulation_response'] <- success['simulation_time'] + success['response_time']
success['simulation_response'] <- sapply(success['simulation_response'], function(x) as.numeric(x))


horas <- c()
val <- min(data$request_time_mili)
for (x in 1:50) {
  horas <- c(horas, val)
  val <- val + 60000
}
time <- aggregate(success$response_time, list(cut(success$request_time_mili, breaks=horas)), mean)

png('response_time.png')
ggplot(data=time, aes(x=Group.1, y=x, group=1)) +
  geom_bar(stat="identity", fill="#56B4E9") +
  xlab("Hora do Dia") + ylab("Número de Viagens (x 1000)")
dev.off()

print("DONE")
