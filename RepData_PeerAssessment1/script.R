Sys.setlocale("LC_TIME", "English")

## Load libraries
library(ggplot2)
library(dplyr)
library(mice)


## Download and import data
download.file("https://d396qusza40orc.cloudfront.net/repdata%2Fdata%2Factivity.zip", "activity.zip")
df <- read.table(unz("activity.zip", "activity.csv"),
                 sep = ",",
                 header = TRUE,
                 colClasses = c("numeric", "Date", "numeric"))

## First task
daily <- df %>% 
    group_by(date) %>% 
    summarise(sum = sum(steps, na.rm = TRUE),
              avg = mean(steps, na.rm = TRUE), 
              median = median(steps, na.rm = TRUE))
g <- ggplot(data = daily, aes(x = sum))
g + geom_histogram(bins = 50)
daily[,c(1, 3, 4)]


## Second task
intervaly <- df %>% 
    group_by(interval) %>% 
    summarise(avg = mean(steps, na.rm = TRUE))
g <- ggplot(data = intervaly, aes(x = interval, y = avg))
g + geom_line()
which.max(intervaly$avg)
intervaly[which.max(intervaly$avg), 1]


## Third task
sum(is.na(df))
df_imp <- df %>% 
    mutate(date = as.factor(date)) %>% 
    mice(m=1, maxit = 10, method = 'pmm', seed = 500) %>%
    complete(1) %>% 
    mutate(date = as.Date(date))

sum(is.na(df_imp))

daily_imp <- df_imp %>% 
  group_by(date) %>% 
  summarise(sum = sum(steps, na.rm = TRUE), 
            avg = mean(steps, na.rm = TRUE), 
            median = median(steps, na.rm = TRUE))
g <- ggplot(data = daily_imp, aes(x = sum))
g + geom_histogram(bins = 50)
daily_imp[,c(1, 3, 4)]


## Fourth task
df_week <- df_imp
df_week$weekend <- "weekday"
df_week$weekend[weekdays(df_week$date) == "Saturday" | weekdays(df_week$date) == "Sunday"] <- "weekend"
df_week$weekend <- as.factor(df_week$weekend)
weekend <- df_week %>% 
  group_by(weekend, interval) %>% 
  summarise(avg = mean(steps, na.rm = TRUE))
g <- ggplot(data = weekend, aes(x = interval, y = avg))
g + geom_line() + facet_grid(weekend ~ .)