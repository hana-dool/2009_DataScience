###### BHC 판매 건수 ######
library(readxl)
setwd("C:/Users/gsw05/OneDrive - 연세대학교 (Yonsei University)/기타/Statistics")
##### Excel sheet names list #####
# 1510 ~ 2009 Daily 데이터 로딩 (60개월)

s1 <- c( rep(15,3), rep(16:19, each=12), rep(20,9) )
s2 <- c( 10:12, rep(c(paste('0', 1:9, sep=''), 10:12), 4), paste('0', 1:9, sep='') )

s3 <- paste(s1, s2, ".xlsx", sep='')
length(s1) ; length(s2) ; length(s3)

##
numeric.day <- function(x){
  x$일 <- as.numeric(x$일)
  return(x) }
##

Xlist <- paste('X', 1:60, sep='')
for(i in 1:60) assign(Xlist[i], numeric.day(as.data.frame(read_xlsx( paste("daily(new)/", sep='', s3[i] )))))
X1    #1510.xlsx


date.to.x <- function(date){
  dex = which(s4==date)
  date = paste('X', dex, sep='')
  return(date)
}

head(X1) ; head(X60)

#전처리 함수 chicken()
chicken <- function(x){
  nobs = nrow(x)
  x <- x[1:(nobs-1),] # 합계행 제거
  x <- x[,c("일","요일","객수")]
}

##### data combining #####
bhc_list = paste("chicken(","X", 1:60,")", sep='')

bhc <- data.frame()
for(i in 1:length(bhc_list)) 
  bhc <- rbind( bhc, eval(parse(text=bhc_list[i])) )


dim(bhc)  # 1683행 데이터(NA 포함)


# 월 column 추가
{ month <- as.numeric(s2) # 60개월(10~9월)
  nobs = nrow(bhc)
  bhc <- (cbind(월=NA, bhc))
  
  j=1
  
  for (i in 1:nobs){
    if (i==1) bhc$월[i] <- month[j] 
    else if (as.numeric(bhc[i-1,]$일) > as.numeric(bhc[i,]$일)) j <- j+1  #몇월인가  
    bhc$월[i] <- as.numeric(month[j])  #월 추가
  } }


# 연도 column 추가
{ bhc <- cbind(연=NA, bhc)
  years = c(2015:2020) ; j=1  # 2015~2020년도
  nobs = nrow(bhc)
  for (i in 1:nobs){
    if (i==1) bhc$연[i] <- years[j]
    else if (as.numeric(bhc[i-1,]$월) > as.numeric(bhc[i,]$월)) j <- j+1  #몇년인가
    bhc$연[i] <- years[j]
  } 
}

# Date column 추가
bhc = cbind(날짜 = as.Date(paste(bhc$연,bhc$월,bhc$일,sep='-'),'%Y-%m-%d'), bhc)
bhc = bhc[,c("날짜","요일","객수")]

head(bhc)
tail(bhc)

write.csv(bhc, "C:/Users/gsw05/OneDrive - 연세대학교 (Yonsei University)/수업/데이터사이언스(1);데이터통합과정보보호(임종호)/팀프로젝트/데이터/BHC 판매 건수.csv", row.names=F)
