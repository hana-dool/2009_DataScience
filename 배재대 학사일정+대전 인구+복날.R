library(lubridate)

###### 배재대 방학 ######
# 2015~2020 겨울, 여름 방학
# 출처 : 배재대학교 학사일정(https://guide.pcu.ac.kr/01-guide/guide-0101.html)
{ 개강들 = as.Date(c("2016-03-02","2016-08-29","2017-03-02","2017-08-28","2018-03-02",
                  "2018-09-03","2019-03-04","2019-09-02","2020-03-16","2020-09-01"))
종강들 = as.Date(c("2015-12-19","2016-06-23","2016-12-17","2017-06-23","2017-12-19",
                "2018-06-23","2018-12-22","2019-06-20","2019-12-20","2020-07-13"))
개강들 = as.character(개강들) ; 종강들 = as.character(종강들) }

name = paste(c(15, rep(16:19, each=2), 20), rep(c('년 겨울', '년 여름'),5), sep='')

paichai = data.frame(종강들, 개강들)
dimnames(paichai) = list(name, c("종강","개강"))

write.csv(paichai, "C:/Users/gsw05/OneDrive - 연세대학교 (Yonsei University)/수업/데이터사이언스(1);데이터통합과정보보호(임종호)/팀프로젝트/데이터/배재대 학사일정.csv")


###### 대전 인구 ######
s1 = paste(c( rep(2015,3), rep(2016:2019,each=12), rep(2020,8) ), "년", sep="")
s2 = paste(c( 10:12, rep(1:12,4), 1:8 ), "월 인구현황", sep="")

s3 = paste(s1, s2)
s3[1:44] = paste(s1[1:44], " ", s2[1:44], "(최종)", sep="")
s3[1:28] = paste(s3[1:28], ".xls", sep='')
s3[29:59] = paste(s3[29:59], ".xlsx", sep='')

setwd("C:/Users/gsw05/OneDrive - 연세대학교 (Yonsei University)/수업/데이터사이언스(1);데이터통합과정보보호(임종호)/팀프로젝트/대전시 인구")
library(readxl)

Xlist = paste("X", 1:59, sep='')

for (i in 1:59){
  if (i<=28) assign(Xlist[i], as.data.frame(read_xls(s3[i])))
  else assign(Xlist[i], as.data.frame(read_xlsx(s3[i])))}

trimming = function(x){
  x = x[,c(2,3,4,5,6,10,11)]
  colnames(x) = c("동이름", "세대수", "총인구수", "남성수", "여성수", "증감세대수", "증감인구수")
  x = subset(x, subset=(x$동이름=="도마1동"|x$동이름=="도마2동"|x$동이름=="변동"))
  return(x)
}
trimx = paste("trimming(X", 1:59, ")", sep='')

djpop = data.frame()
for (i in 1:59){
  djpop = rbind(djpop, eval(parse(text=trimx[i])))
}

dim(djpop)
s4 = sub(" 인구현황", "", paste(s1, s2))

djpop = cbind(날짜=rep(s4, each=3), djpop)

head(djpop)
tail(djpop)

write.csv(djpop, "C:/Users/gsw05/OneDrive - 연세대학교 (Yonsei University)/수업/데이터사이언스(1);데이터통합과정보보호(임종호)/팀프로젝트/데이터/2015~2020 도마동+변동 인구.csv", row.names=F)



###### 복날들 ######
{복날들 = c(seq(from=as.Date("2016-07-17"), by=10, length.out=4)[-3],   # 직접 추가
         seq(from=as.Date("2017-07-12"), by=10, length.out=4)[-3],
         seq(from=as.Date("2018-07-17"), by=10, length.out=4)[-3],
         seq(from=as.Date("2019-07-12"), by=10, length.out=4)[-3],
         seq(from=as.Date("2020-07-16"), by=10, length.out=4)[-3])
  복날들 = as.character(복날들)
  
  name_복날 = rep(c('초복','중복','말복'),5)}

bok = data.frame(복날들, name_복날)
colnames(bok) = c('날짜', "복날")

bok
write.csv(bok, "C:/Users/gsw05/OneDrive - 연세대학교 (Yonsei University)/수업/데이터사이언스(1);데이터통합과정보보호(임종호)/팀프로젝트/데이터/2015~2020 복날.csv", row.names=F)
