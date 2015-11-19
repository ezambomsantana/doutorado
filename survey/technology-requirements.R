var.names <- c("Adaptation", "Interoperability", "Scalability", "Security and Privacy", 
               "Context-Awareness", "Extensibility", "Quality of Service", 
               "Availability", "Configurability")

var.order = seq(1:9)

values.a <- c(4, 7, 12, 4, 5, 6, 1, 1, 5)
values.b <- c(1, 4, 6, 5, 2, 4, 3, 3, 3)
values.c <- c(6, 11, 15, 8, 8, 8, 3, 3, 9)
values.d <- c(2, 1, 0, 0, 1, 1, 0, 0, 3)

group.names <- c("Big Data", "Internet of Things", "Cloud Computing", "CPS")


# (2) Create df1: a plotting data frame in the format required for ggplot2

df1.a <- data.frame(matrix(c(rep(group.names[1], 9), var.names), nrow = 9, ncol = 2), 
                    var.order = var.order, value = values.a)
df1.b <- data.frame(matrix(c(rep(group.names[2], 9), var.names), nrow = 9, ncol = 2), 
                    var.order = var.order, value = values.b)
df1.c <- data.frame(matrix(c(rep(group.names[3], 9), var.names), nrow = 9, ncol = 2), 
                    var.order = var.order, value = values.c)
df1.d <- data.frame(matrix(c(rep(group.names[4], 9), var.names), nrow = 9, ncol = 2), 
                    var.order = var.order, value = values.d)

df1 <- rbind(df1.a, df1.b, df1.c, df1.d)
colnames(df1) <- c("Technologies", "variable.name", "variable.order", "variable.value")

library(ggplot2)
ggplot(df1, aes(y = variable.value, x = reorder(variable.name, variable.order), 
                group = Technologies, colour = Technologies)) +
coord_polar() + geom_point() + geom_path() + ylab(label="Non-Functional Requirements") +
labs(x = NULL)