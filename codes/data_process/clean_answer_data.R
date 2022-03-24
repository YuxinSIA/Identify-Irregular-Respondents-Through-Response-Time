### Arrange answer seires of id 0:180
## temporarily negelect info question because they are string
## 'all_process' include 20+9+10+4+177*6 questions; 'all_q1_process.csv' include 20+9+10+4+177 questions
library(sparklyr)
library(dplyr)

setwd('./data/answer_data')
user.log <- read.csv('./friendship.csv', sep=",")
user.log <- user.log[!is.na(user.log$mid),]
user.log <- user.log[, 1:9]
#summary(user.log)

user.log.all <- matrix(NA,nrow=181,ncol=177*6)
user.log.all.q1 <- matrix(NA,nrow=181,ncol=177)
for (i in 0:180){
  one.log <- user.log[user.log$mid==i, ]
  if(nrow(one.log)>0){
    for (j in 0:176){
      one.log2 <- one.log[one.log$oid==j,]
      if(nrow(one.log2)>0){
        one.log.line <- as.numeric(one.log2[which.max(one.log2$uniqueid),c(3:7,9)])#use the biggest uniqueid
        user.log.all[i+1,(j*6+1):(j*6+6)]<-one.log.line
        user.log.all.q1[i+1,j+1]<-one.log.line[1]
      }
    }
  }
}

bigfive <- read.csv('./bigfive.csv', sep=",")
#summary(bigfive)
re.bigfive <- matrix(NA,nrow=181,ncol=20)
for (i in 0:180){
  one.log <- bigfive[bigfive$mid==i, ]
  if(nrow(one.log)>0){
    re.bigfive[i+1,]<-as.numeric(one.log[-1])
  }
}

depression <- read.csv('./depression.csv', sep=",")
#summary(depression)
re.depression <- matrix(NA,nrow=181,ncol=9)
for (i in 0:180){
  one.log <- depression[depression$mid==i, ]
  if(nrow(one.log)>0){
    re.depression[i+1,]<-as.numeric(one.log[-1])
  }
}

lonely <- read.csv('./lonely.csv', sep=",")
#summary(lonely)
re.lonely <- matrix(NA,nrow=181,ncol=10)
for (i in 0:180){
  one.log <- lonely[lonely$mid==i, ]
  if(nrow(one.log)>0){
    re.lonely[i+1,]<-as.numeric(one.log[-1])
  }
}

happy <- read.csv('./happy.csv', sep=",")
#summary(happy)
re.happy <- matrix(NA,nrow=181,ncol=4)
for (i in 0:180){
  one.log <- happy[happy$mid==i, ]
  if(nrow(one.log)>0){
    re.happy[i+1,]<-as.numeric(one.log[-1])
  }
}

re.all <- cbind(re.bigfive,re.depression,re.lonely,re.happy,user.log.all)
write.csv(re.all, 'all_process.csv', row.names=F, quote=F)

re.all.q1 <- cbind(re.bigfive,re.depression,re.lonely,re.happy,user.log.all.q1)
write.csv(re.all.q1, 'all_q1_process.csv', row.names=F, quote=F)
