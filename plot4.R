wd <- "/Users/dgregersen/Desktop/Coursera"
setwd(wd)

#DOWNLOAD
url <- "https://d396qusza40orc.cloudfront.net/exdata%2Fdata%2Fhousehold_power_consumption.zip"
file <- file.path(wd, "file.zip")
download.file(url = url, destfile = file, method = "curl")
#LOAD
data <- read.table(file = unz(file, "household_power_consumption.txt"), 
                   sep = ";", header = TRUE, na.strings = c("?"))

#MODIFICATIONS
data$timestamp <- paste(data$Date, data$Time)
data$Date <- strptime(data$Date, "%d/%m/%Y")
data <- subset(data, Date == strptime("01/02/2007", "%d/%m/%Y") | 
                       Date == strptime("02/02/2007", "%d/%m/%Y"))
data$timestamp <- strptime(data$timestamp, "%d/%m/%Y %H:%M:%S") 
data <- data[c("timestamp","Global_active_power","Global_reactive_power",
               "Voltage","Global_intensity","Sub_metering_1","Sub_metering_2",
               "Sub_metering_3")]

#EXPLORATION AND PLOTTING
png(filename = "plot4.png",
    width = 480, height = 480)
par("mfcol" = c(2,2))
plot(y = data$Global_active_power, 
     x = data$timestamp, 
     type = "l",
     ylab = "Global Active Power (kilowatts",
     xlab = ""
)
plot(y = data$Sub_metering_1, 
     x = data$timestamp, 
     type = "n",
     ylab = "Energy sub metering",
     xlab = ""
)
points(y = data$Sub_metering_1, 
       x = data$timestamp,
       type = "l",
       col = "black")
points(y = data$Sub_metering_2, 
       x = data$timestamp,
       type = "l",
       col = "red"
       )
points(y = data$Sub_metering_3, 
       x = data$timestamp,
       type = "l",
       col = "blue"
       )
legend("topright", 
       legend = c("Sub_metering_1","Sub_metering_2","Sub_metering_3"),
       col = c("black","red","blue"),
       lty = c(1,1),
       lwd = c(2,2),
       cex = 0.8)
plot(y = data$Voltage, 
     x = data$timestamp, 
     type = "l",
     ylab = "Voltage",
     xlab = "datetime"
)
plot(y = data$Global_reactive_power, 
     x = data$timestamp, 
     type = "l",
     ylab = "Global Reactive Power",
     xlab = "datetime"
)
dev.off()