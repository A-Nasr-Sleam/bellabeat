------------------
#loading libraries
------------------
library (tidyverse)
library(lubridate)
library(dplyr)

-----------------------------------------------------------------------------------------
#importing csv files from working directory and implementing snake_case naming convention
-----------------------------------------------------------------------------------------
heart_rate_seconds <- read.csv("heartrate_seconds_merged.csv")
minute_sleep <- read.csv("minuteSleep_merged.csv")
sleep_day <- read.csv("sleepDay_merged.csv")
intensities_minute<- read.csv("minuteIntensitiesNarrow_merged.csv")
steps_minute <- read.csv("minuteStepsNarrow_merged.csv")
calories_minute <- read.csv("minuteCaloriesNarrow_merged.csv")
daily_activity <- read_csv("dailyActivity_merged.csv")

----------------------
#exploring data frames
----------------------
##using str() function to explore the data frame field names, data types, and format
str(heart_rate_seconds)
##counting number of NULL values in every field *repeat the flowing step with every field
sum(is.na(heart_rate_seconds$Id))

str(minute_sleep)
sum(is.na(minute_sleep$Id))

str(sleep_day)
sum(is.na(sleep_day$Id))

str(intensities_minute)
sum(is.na(intensities_minute$Id))

str(steps_minute)
sum(is.na(steps_minute$Id))

str(calories_minute)
sum(is.na(calories_minute$Id))

str(daily_activity)
sum(is.na(daily_activity$Id))


-------------------------------------------------------------------------
#transforming date fields from string datatype to POSIXct or date datatype
--------------------------------------------------------------------------
heart_rate_seconds$Time <-as.POSIXct(heart_rate_seconds$Time,format="%m/%d/%Y %I:%M:%S %p")

##using format() function after as.POSIXct() function to create time zone
minute_sleep$date <-as.POSIXct(minute_sleep$date,format="%m/%d/%Y %I:%M:%S %p")
minute_sleep$date <-format(minute_sleep$date,format = "%m/%d/%Y %H:%M:%S %Z")

##using as.data() function to format sleep day as date  
sleep_day$SleepDay <- as.POSIXct(sleep_day$SleepDay,format="%m/%d/%Y %I:%M:%S %p")
sleep_day$SleepDay <-as_date(sleep_day$SleepDay)

##using format() function after as.POSIXct() function to create time zone  
intensities_minute$ActivityMinute <-as.POSIXct(intensities_minute$ActivityMinute,format="%m/%d/%Y %I:%M:%S %p")
intensities_minute$ActivityMinute <-format(intensities_minute$ActivityMinute,format = "%m/%d/%Y %H:%M:%S %Z")
  
steps_minute$ActivityMinute <- as.POSIXct(steps_minute$ActivityMinute,format="%m/%d/%Y %I:%M:%S %p")
steps_minute$ActivityMinute <- format(steps_minute$ActivityMinute,format='%m/%d/%Y %H:%M')

##using format() function after as.POSIXct() function to create time zone 
calories_minute$ActivityMinute <-as.POSIXct(calories_minute$ActivityMinute,format="%m/%d/%Y %I:%M:%S %p")
calories_minute$ActivityMinute <- format(calories_minute$ActivityMinute, format = "%m/%d/%Y %H:%M:%S %Z")

#field ActivityDate from data frame daily_activity is recognized by BigQuery as date

----------------
#processing data
----------------
##creating data frame heart_rate_min
###turning time stamp format to end with minutes
heart_rate_seconds$Time <- format(heart_rate_seconds$Time,format='%m/%d/%Y %H:%M')

### creating empty table
heart_rate_min <- data.frame(Id=character(),
                             Time=as.POSIXct(factor()),
                             Value=double())

###summarizing heart rate for every Id for every min
heart_rate_min <-heart_rate_seconds %>%
                 drop_na() %>% 
                 group_by(Id,Time) %>%
                 summarise(avg_min_heart_rate=round(mean(Value),0))

----------------------------
#exporting cleaned csv_files
----------------------------
write.csv(minute_sleep,"minute_sleep.csv",row.names = FALSE)
write.csv(sleep_day,"sleep_day.csv",row.names=FALSE)
write.csv(heart_rate_min,"heart_rate_min.csv",row.names=FALSE)
write.csv(intensities_minute,"intensities_minute.csv",row.names=FALSE)
write.csv(steps_minute,"steps_minute.csv",row.names = FALSE)
write.csv(weightLogInfo_merged,"weight_log.csv",row.names = FALSE)
write.csv(calories_minute,"calories_minute.csv",row.names = FALSE)
write.csv(daily_activity,"daily_activity.csv",row.names = FALSE)

