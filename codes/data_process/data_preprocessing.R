### Data Preprocessing

library(sparklyr)
library(dplyr)

user.log <- read.csv('./data/raw_data/log-2019-Oct-16.csv', sep=",")
user.log <- user.log[!is.na(user.log$mid),]
user.log <- user.log %>%
  mutate(test = recode(curr_page, `info`=1, `my_bigfive`=2, `depression`=3, `lonely`=4, `happy`=5, `friendship`=6))
user.log <- user.log[, c(1, 2, 3, 4, 8, 9)]
user.log$mid <- as.numeric(as.character(user.log$mid)); user.log$oid <- as.numeric(as.character(user.log$oid)); user.log$qid <- as.numeric(as.character(user.log$qid))

user.log.all <- user.log.all.q1 <- NULL


for (i in 1:180){
  one.log <- user.log[user.log$mid==i, ]
  one.log.order <- rbind(
    one.log %>% filter(test==1) %>% arrange(qid),
    one.log %>% filter(test==2) %>% arrange(qid),
    one.log %>% filter(test==3) %>% arrange(qid),
    one.log %>% filter(test==4) %>% arrange(qid),
    one.log %>% filter(test==5) %>% arrange(qid),
    one.log %>% filter(test==6) %>% arrange(oid, qid)
  )
  
  one.log.order.q1 <- rbind(
    one.log %>% filter(test==1) %>% arrange(qid),
    one.log %>% filter(test==2) %>% arrange(qid),
    one.log %>% filter(test==3) %>% arrange(qid),
    one.log %>% filter(test==4) %>% arrange(qid),
    one.log %>% filter(test==5) %>% arrange(qid),
    one.log %>% filter(test==6, qid==1) %>% arrange(oid)
  )
  
  user.log.all <- rbind(user.log.all, one.log.order)
  user.log.all.q1 <- rbind(user.log.all.q1, one.log.order.q1)
}

write.csv(user.log.all, './data/processed_data/log_oct_processed.csv', row.names=F, quote=F)
write.csv(user.log.all.q1, './data/processed_data/log_oct_processed_q1.csv', row.names=F, quote=F)

## now get the data for bad responses
user.log <- read.csv('./data/raw_data/log-2019-Sep-02.csv', sep=",")
user.log <- user.log[!is.na(user.log$mid),]
user.log <- user.log %>%
  mutate(test = recode(curr_page, `info`=1, `my_bigfive`=2, `depression`=3, `lonely`=4, `happy`=5, `friendship`=6))
user.log <- user.log[, c(1, 2, 3, 4, 8, 9)]
user.log$mid <- as.numeric(as.character(user.log$mid)); user.log$oid <- as.numeric(as.character(user.log$oid)); user.log$qid <- as.numeric(as.character(user.log$qid))
#Notice the line above is necessary, otherwise mid, oid, qid are treated as categorical variable
user.log.all <- user.log.all.q1 <- NULL


for (i in 1:180){
  one.log <- user.log[user.log$mid==i, ]
  one.log.order <- rbind(
    one.log %>% filter(test==1) %>% arrange(qid),
    one.log %>% filter(test==2) %>% arrange(qid),
    one.log %>% filter(test==3) %>% arrange(qid),
    one.log %>% filter(test==4) %>% arrange(qid),
    one.log %>% filter(test==5) %>% arrange(qid),
    one.log %>% filter(test==6) %>% arrange(oid, qid)
  )
  
  one.log.order.q1 <- rbind(
    one.log %>% filter(test==1) %>% arrange(qid),
    one.log %>% filter(test==2) %>% arrange(qid),
    one.log %>% filter(test==3) %>% arrange(qid),
    one.log %>% filter(test==4) %>% arrange(qid),
    one.log %>% filter(test==5) %>% arrange(qid),
    one.log %>% filter(test==6, qid==1) %>% arrange(oid)
  )
  
  user.log.all <- rbind(user.log.all, one.log.order)
  user.log.all.q1 <- rbind(user.log.all.q1, one.log.order.q1)
}

write.csv(user.log.all, './data/processed_data/log_sept_processed.csv', row.names=F, quote=F)
write.csv(user.log.all.q1, './data/processed_data/log_sept_processed_q1.csv', row.names=F, quote=F)

## now get the data for Aug-30
user.log <- read.csv('./data/raw_data/log-2019-Aug-30.csv', sep=",")
user.log <- user.log[!is.na(user.log$mid),]
user.log <- user.log %>%
  mutate(test = recode(curr_page, `info`=1, `my_bigfive`=2, `depression`=3, `lonely`=4, `happy`=5, `friendship`=6))
user.log <- user.log[, c(1, 2, 3, 4, 8, 9)]
user.log$mid <- as.numeric(as.character(user.log$mid)); user.log$oid <- as.numeric(as.character(user.log$oid)); user.log$qid <- as.numeric(as.character(user.log$qid))

user.log.all <- user.log.all.q1 <- NULL


for (i in 1:180){
  one.log <- user.log[user.log$mid==i, ]
  one.log.order <- rbind(
    one.log %>% filter(test==1) %>% arrange(qid),
    one.log %>% filter(test==2) %>% arrange(qid),
    one.log %>% filter(test==3) %>% arrange(qid),
    one.log %>% filter(test==4) %>% arrange(qid),
    one.log %>% filter(test==5) %>% arrange(qid),
    one.log %>% filter(test==6) %>% arrange(oid, qid)
  )
  
  one.log.order.q1 <- rbind(
    one.log %>% filter(test==1) %>% arrange(qid),
    one.log %>% filter(test==2) %>% arrange(qid),
    one.log %>% filter(test==3) %>% arrange(qid),
    one.log %>% filter(test==4) %>% arrange(qid),
    one.log %>% filter(test==5) %>% arrange(qid),
    one.log %>% filter(test==6, qid==1) %>% arrange(oid)
  )
  
  user.log.all <- rbind(user.log.all, one.log.order)
  user.log.all.q1 <- rbind(user.log.all.q1, one.log.order.q1)
}

write.csv(user.log.all, './data/processed_data/log_aug_processed.csv', row.names=F, quote=F)
write.csv(user.log.all.q1, './data/processed_data/log_aug_processed_q1.csv', row.names=F, quote=F)