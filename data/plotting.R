oxygen_average <- read.csv(file='average.csv', sep=',', header=FALSE)
A <- seq(from = 0, to = (72*5), by = 5)
A <- (A/60)
matplot(A, oxygen_average, type = "l", pch=1, lty=1, col = 1:6, axes=F, ann=F, ylim=c(0,25))
#legend("topright", legend = 1:24, col=1:6, pch=1)
axis(1, cex.axis=1.2)
axis(2, cex.axis=1.2)
title(ylab="Oxygen Concentration (%)", xlab="Time (hours)", cex.lab=1.5)
std <- read.csv(file='std.csv', sep=',', header=FALSE)
for ( i in seq(1,length( std ),1) ) arrows(A, oxygen_average[,i]-std[,i], A, oxygen_average[,i]+std[,i], length=0.03, angle=90, code=3)

row1_range <- paste("V", 1:6, sep="")
row1 <- oxygen_average[row1_range]
row2_range <- paste("V", 7:12, sep="")
row2 <- oxygen_average[row2_range]
row3_range <- paste("V", 13:18, sep="")
row3 <- oxygen_average[row3_range]
row4_range <- paste("V", 19:24, sep="")
row4 <- oxygen_average[row4_range]

matplot(A, row2, type = "l", pch=1, lty=1, col = 1:6, axes=F, ann=F, ylim=c(0,25))
legend("topright", c("well 1","well 2","well 3","well 4","well 5", "well 6"), col=1:6, lty=1, )
axis(1, cex.axis=1.2)
axis(2, cex.axis=1.2)
title(ylab="Oxygen Concentration (%)", xlab="Time (hours)", cex.lab=1.5)
for ( i in seq(7, 12, 1) ) arrows(A, oxygen_average[,i]-std[,i], A, oxygen_average[,i]+std[,i], length=0.04, angle=90, code=3)
