# filter good ids (43)

# good ids are: 
## [1]   2   5   6   7   8  10  12  13  14  15  19  24  25  29  31  33  39  43  62
## [20]  65  67  73  84  99 101 102 108 112 114 117 122 127 144 148 149 154 156 160
## [39] 162 163 167 169 175


setwd('./data/processed_data')
log <- read.csv("./log_aug_processed.csv")

bad_id <- list()

### The first five parts have less than 6 NAs
first_five <- log %>% filter(test!=6)
na_num <-  list()
for (i in 1:180) {
  mid_i = first_five %>% filter(mid==i)
  na_num[i] = length(mid_i[(is.na(mid_i$time_stamp) | mid_i$time_stamp==""),]$time_stamp)
  if (na_num[i] >= 3) {  ## Why >= '3': if more than 3, response time will have more than 6 NAs
    bad_id <- c(bad_id, i)
  }
}


### For ‘friendship’, qid = 1 has no NAs
friend <- log %>% filter(test==6)
q1_friend <- friend %>% filter(qid==1)
num_good_friend <- list()
for (i in 1:180) {
  mid_i = q1_friend %>% filter(mid==i)
  num_good_friend[i] = length(mid_i[!(is.na(mid_i$time_stamp) | mid_i$time_stamp==""),]$time_stamp)
  if(num_good_friend[i] < 176) {
    bad_id <- c(bad_id, i)
  }
}


### For ‘friendship’, we assume it’s normal that one person know at least 10 other people, so all qid = 2-6 should have at least 50 data (not NA) 
### other_friend <- friend %>% filter(qid!=1)
num_good_friend_other <- list()
for (i in 1:180) {
  mid_i = other_friend %>% filter(mid==i)
  num_good_friend_other[i] = length(mid_i[!(is.na(mid_i$time_stamp) | mid_i$time_stamp==""),]$time_stamp)
  if(num_good_friend_other[i] < 50) {
    bad_id <- c(bad_id, i)
  }
}

bad_id <- unique(bad_id)
bad_id <- as.numeric(bad_id)
good_id <- setdiff(c(1:180), bad_id)
