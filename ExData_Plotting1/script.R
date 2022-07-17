temp <- tempfile()
download.file("https://d396qusza40orc.cloudfront.net/exdata%2Fdata%2Fhousehold_power_consumption.zip", "household_power_consumption.zip")
hpc <- read.table(unz("household_power_consumption.zip", "household_power_consumption.txt"),
                  sep = ";",
                  header = TRUE,
                  na.strings = "?",
                  colClasses = c("character", "character", "numeric", "numeric", "numeric", "numeric", "numeric", "numeric", "numeric"))
unlink(temp)                
hpc$Date_Time <- paste(hpc$Date, hpc$Time)
hpc$Date_Time <- strptime(hpc$Date_Time, format = "%e/%m/%Y %H:%M:%S")
hpc_selected <- hpc[hpc$Date_Time >= as.POSIXlt("2007-02-01 00:00:00") & hpc$Date_Time < as.POSIXlt("2007-02-03 00:00:00"), ]

# Plot 1
par(mfrow = c(1,1))
hist(hpc_selected$Global_active_power, col = "red", xlab = "Global Active Power (kilowatts)", main = "Global Active Power")

# Plot 2
par(mfrow = c(1,1))
plot(hpc_selected$Date_Time, hpc_selected$Global_active_power, type = "n", ylab = "Global Active Power (kilowatts)", xlab = "")
lines(hpc_selected$Date_Time, hpc_selected$Global_active_power)

# Plot 3
par(mfrow = c(1,1))
plot(hpc_selected$Date_Time, hpc_selected$Sub_metering_1, type = "n", ylab = "Energy sub metering", xlab = "")
lines(hpc_selected$Date_Time, hpc_selected$Sub_metering_1)
lines(hpc_selected$Date_Time, hpc_selected$Sub_metering_2, col = "red")
lines(hpc_selected$Date_Time, hpc_selected$Sub_metering_3, col = "blue")
legend("topright", names(hpc_selected)[7:9], col = c("black", "red", "blue"), lty = c(1, 1, 1))

# Plot 4
par(mfrow = c(2,2))
plot(hpc_selected$Date_Time, hpc_selected$Global_active_power, type = "n", ylab = "Global Active Power (kilowatts)", xlab = "")
lines(hpc_selected$Date_Time, hpc_selected$Global_active_power)
plot(hpc_selected$Date_Time, hpc_selected$Voltage, type = "n", ylab = "Voltage", xlab = "datetime")
lines(hpc_selected$Date_Time, hpc_selected$Voltage)
plot(hpc_selected$Date_Time, hpc_selected$Sub_metering_1, type = "n", ylab = "Energy sub metering", xlab = "")
lines(hpc_selected$Date_Time, hpc_selected$Sub_metering_1)
lines(hpc_selected$Date_Time, hpc_selected$Sub_metering_2, col = "red")
lines(hpc_selected$Date_Time, hpc_selected$Sub_metering_3, col = "blue")
legend("topright", names(hpc_selected)[7:9], col = c("black", "red", "blue"), lty = c(1, 1, 1))
plot(hpc_selected$Date_Time, hpc_selected$Global_reactive_power, type = "n", ylab = names(hpc_selected)[4], xlab = "datetime")
lines(hpc_selected$Date_Time, hpc_selected$Global_reactive_power)

