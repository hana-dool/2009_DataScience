# load packages

suppressWarnings({
  
  library(glue)
  
  library(dplyr)
  
  library(httr)
  
  library(rjson)
  
  library(stringr)
  
})



api.key <-
  
  'M%2FJ5hqI3zQ4VFHX8rilg19NvRhs%2B0XJu6OAPU%2Fun06I6SoaPvT7MbSmBlHa1iVW7%2FfcJiVgaSXUze1qCRULaMQ%3D%3D'

url.format <- 
  
  'http://apis.data.go.kr/B090041/openapi/service/SpcdeInfoService/getRestDeInfo?serviceKey={key}&solYear={year}&solMonth={month}'



holiday.request <- function(key, year, month) glue(url.format)

holidays <- data.frame(name=character(), day=integer(), stringsAsFactors=FALSE)



# request and read data

for(y in 2015:2020){
  
  for(m in 1:12){
    
    items <- 
      
      holiday.request(api.key, y, str_pad(m, 2, pad=0)) %>% 
      
      GET %>%
      
      content(as='text', encoding='UTF-8') %>%
      
      fromJSON %>%
      
      .$response %>%
      
      .$body %>%
      
      .$items
    
    
    
    if(items != ''){ # empty items check
      
      if(is.null(names(items$item))){ # many item case
        
        for(i in 1:length(items$item)){
          
          item <- items$item[[i]]
          
          if(item$isHoliday == 'Y'){
            
            holidays <- 
              
              holidays %>% 
              
              rbind(data.frame(name=item$dateName, day=item$locdate, stringsAsFactors=FALSE))
            
          }
          
        }
        
      }else{ # just 1 item case
        
        item <- items$item
        
        if(item$isHoliday == 'Y'){
          
          holidays <- 
            
            holidays %>% 
            
            rbind(data.frame(name=item$dateName, day=item$locdate, stringsAsFactors=FALSE))
          
        }
        
      }
      
    }
    
  }
  
  
  
  holidays <- 
    
    holidays %>%
    
    rbind(data.frame(name='노동절', day=paste(y, '0501', sep='')))
  
}



holidays <- holidays %>% mutate(day = as.integer(as.character(day))) %>% arrange(day) 
holidays$day = as.Date(as.character(holidays$day), '%Y%m%d')

colnames(holidays) = c("이름", "날짜")

write.csv(holidays, "C:/Users/gsw05/OneDrive - 연세대학교 (Yonsei University)/수업/데이터사이언스(1);데이터통합과정보보호(임종호)/팀프로젝트/데이터/2015~2020 공휴일.csv", row.names=FALSE)



View(holidays)

#[출처] 공휴일 확인하기 : 공공데이터포털 API 예제|작성자 Curycu