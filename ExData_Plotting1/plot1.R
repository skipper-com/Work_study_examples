# Download zip-data
download.file("https://d396qusza40orc.cloudfront.net/exdata%2Fdata%2Fhousehold_power_consumption.zip", "household_power_consumption.zip")

# Unzip data and read to data.frame while replacing '?' by NA and matching col classess
hpc <- read.table(unz("household_power_consumption.zip", "household_power_consumption.txt"),
                  sep = ";",
                  header = TRUE,
                  na.strings = "?",
                  colClasses = c("character", "character", "numeric", "numeric", "numeric", "numeric", "numeric", "numeric", "numeric"))
# Make column with daetime object                
hpc$Date_Time <- paste(hpc$Date, hpc$Time)
hpc$Date_Time <- strptime(hpc$Date_Time, format = "%e/%m/%Y %H:%M:%S")

# Filter rows only for two days
hpc_selected <- hpc[hpc$Date_Time >= as.POSIXlt("2007-02-01 00:00:00") & hpc$Date_Time < as.POSIXlt("2007-02-03 00:00:00"), ]

# Plot 1
par(mfrow = c(1,1))
png(filename = "plot1.png", width = 480, height = 480, units = "px")
hist(hpc_selected$Global_active_power, col = "red", xlab = "Global Active Power (kilowatts)", main = "Global Active Power")
dev.off()