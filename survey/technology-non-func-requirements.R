var.names <- c("Data Management", "App Run-time", "WSN Management", "Data Processing", 
               "Data Access API", "Service Management", "SE Tools", 
               "Definition of a City Model")

var.order = seq(1:8)

values.a <- c(12, 4, 4, 9, 10, 10, 3, 2)
values.b <- c(7, 4, 6, 3, 7, 5, 2, 0)
values.c <- c(18, 7, 9, 12, 16, 14, 4, 3)
values.d <- c(2, 1, 1, 2, 1, 2, 0, 1)

group.names <- c("Big Data", "Internet of Things", "Cloud Computing", "CPS")


# (2) Create df1: a plotting data frame in the format required for ggplot2

df1.a <- data.frame(matrix(c(rep(group.names[1], 8), var.names), nrow = 8, ncol = 2), 
                    var.order = var.order, value = values.a)
df1.b <- data.frame(matrix(c(rep(group.names[2], 8), var.names), nrow = 8, ncol = 2), 
                    var.order = var.order, value = values.b)
df1.c <- data.frame(matrix(c(rep(group.names[3], 8), var.names), nrow = 8, ncol = 2), 
                    var.order = var.order, value = values.c)
df1.d <- data.frame(matrix(c(rep(group.names[4], 8), var.names), nrow = 8, ncol = 2), 
                    var.order = var.order, value = values.d)

df1 <- rbind(df1.a, df1.b, df1.c, df1.d)
colnames(df1) <- c("Technologies", "variable.name", "variable.order", "variable.value")

library(ggplot2)
ggplot(df1, aes(y = variable.value, x = reorder(variable.name, variable.order), 
                group = Technologies, colour = Technologies)) +
  coord_polar() + geom_point() + geom_path() + ylab(label="Functional Requirements") +
  labs(x = NULL)