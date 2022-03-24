library(dplyr)
library(changepoint)

# After the data filtering, I got some IDs which have relatively "good" surveys (according to the time_stamp completeness)
# Details can be referred from @cleaning.R 
good_id <- c(2, 5, 6, 7, 8, 10, 12, 13, 14, 15, 19, 24, 25, 29, 31, 33, 39, 43, 62, 65, 67, 73, 84, 99, 101, 102,  
           108, 112, 114, 117, 122, 127, 144, 148, 149, 154, 156, 160, 162, 163, 167, 169, 175)
###############################################################
# Aug--load data
aug <- read.csv("./data/processed_data/log_aug_processed_q1.csv")
log.aug <- list()
for (i in 1:length(good_id)){
  one.log <- aug[aug$mid==good_id[i], ]
  log.aug <- rbind(log.aug, one.log)
}

# Plot of Timestamp
plot(log.aug$time_stamp[log.aug$mid==169], type='l',lwd=2)

# Take one ID from the above index
one_id <- log.aug %>% filter(mid==169) 

################################################################
# Oct--load data
oct <- read.csv("./data/processed_data/log_oct_processed_q1.csv")
log.oct <- list()
for (i in 1:length(index)){
  one.log <- oct[oct$mid==index[i], ]
  log.oct <- rbind(log.oct, one.log)
}

# Plot of Timestamp
plot(log.oct$time_stamp[log.oct$mid==2], type='l',lwd=2)

# Take one ID from the above index
one_id <- log.oct %>% filter(mid==2) 
##################################################################


# Use difference method to calculate the response time (it seems that there's an R function can do this automatically)
response_time <- list()
for (i in 1:length(one_id$time_stamp)-1){
  response_time[i] = one_id$time_stamp[i+1] - one_id$time_stamp[i]
}
response_time <- append(response_time, NA) # the last question's response time is unknown, so I temporarily use NA
one_id$response_time <- response_time # add a new column of response time to the dataframe

# Use the mean value of response time in each individual part to replace NAs
# mid_complete <- list()
# for (i in 1:6){
#   one_test <- one_id %>% filter(test==i)
#   one_test_time <- as.numeric(one_test$response_time)
#   one_test_time[is.na(one_test_time)]=mean(one_test_time,na.rm=T)
#   mid_complete <- append(mid_complete, one_test_time)
# }

# Look at the friendship test
friend <- one_id %>% filter(test==6)
friend.ts <- as.numeric(friend$response_time)

# Find if there's negative ones
friend.ts[friend.ts < 0] <- NA

# Fill NA
friend.ts[is.na(friend.ts)]=mean(friend.ts,na.rm=T)

stat <- boxplot.stats(friend.ts)
boxplot(friend.ts)


for (i in 1:length(stat$out)) {
  for (j in 1:length(friend.ts)) {
    if (friend.ts[j] == stat$out[i]) {
      friend.ts[j] = mean(friend.ts,na.rm=T)
    }
  }
}

boxplot(friend.ts)


# Time series plot (Using the question number as dependent variable)
timeseries <- friend.ts
plot.ts(timeseries) # the x-axis (time) refers to question number

# SMA
# library(TTR)
# timeseriesSMA<-SMA(timeseries,n=3)
# plot.ts(timeseriesSMA)

# Change Point detection (in mean)
library("changepoint")
ts.bs <- cpt.mean(as.numeric(timeseries), method = "BinSeg", penalty="AIC") # Research later: the difference between different methods
plot(ts.bs, type = "l", cpt.col = "blue", xlab = "Index", , cpt.width = 4)
cpts(ts.bs)



# Detect change points (in variance)
ts.bs <- cpt.var(as.numeric(timeseries), method = "BinSeg")
plot(ts.bs, type = "l", cpt.col = "blue", xlab = "Index", cpt.width = 4)
cpts(ts.bs)

##################################################################################################

changepoints <- list()
for (i in 1:length(good_id)) {
  one_id <- log.aug %>% filter(mid==good_id[i]) 
  response_time <- list()
  for (k in 1:length(one_id$time_stamp)-1){
    response_time[k] = one_id$time_stamp[k+1] - one_id$time_stamp[k]
  }
  response_time <- append(response_time, NA) 
  one_id$response_time <- response_time
  friend <- one_id %>% filter(test==6)
  friend.ts <- as.numeric(friend$response_time)
  
  # Find if there's negative ones
  friend.ts[friend.ts < 0] <- NA
  
  # Fill NA
  friend.ts[is.na(friend.ts)]=mean(friend.ts,na.rm=T)
  
  stat <- boxplot.stats(friend.ts)
  
  for (i in 1:length(stat$out)) {
    for (j in 1:length(friend.ts)) {
      if (friend.ts[j] == stat$out[i]) {
        friend.ts[j] = mean(friend.ts,na.rm=T)
      }
    }
  }
  
  timeseries <- friend.ts
  
  ts.bs <- cpt.mean(as.numeric(timeseries), method = "BinSeg", penalty='AIC') 
  points <- cpts(ts.bs)
  changepoints <- c(changepoints, points)
}

getmode <- function(v) {
  uniqv <- unique(v)
  uniqv[which.max(tabulate(match(v, uniqv)))]
}

hist(as.numeric(changepoints), col="tan", xlab = 'Time')
abline(v = getmode(as.numeric(changepoints)), col="red", lwd=3)
getmode(as.numeric(changepoints))





