##LECTURE 9###

#filter(): select ros that meet certain conditions
#arrange(): reorder rows
#select():choose columns
#mutate(): add or transform columns

library(tidyverse)
library(nycflights13)

flights <- nycflights13::flights
flights

#Logical Operators
flights %>% 
  filter(month==1,day==1) #1월 1일의 flight!

flights %>% 
  filter(carrier=="UA"&dep_delay>60)   #carrier는 항공사 코드 

flights %>% 
  filter(carrier %in% c("AA","DL","UA"))

#Missing values?

#filter()  automatically excludes NA 

flights %>% 
  filter(!is.na(dep_delay))  #NA가 아닌 것만 뽑기
flights %>% filter(dep_delay > 60)

##dep_delay > 60
##위의 조건을 평가할 때 NA는 TRUE/ FALSE로 판단할 수 없어서 자동으로 제외

#select()
flights %>% 
  select(year,month, day, carrier, dep_delay, arr_delay)
flights %>% 
  select(starts_with("dep"))
flights %>% 
  select(ends_with("delay"))
flights %>% 
  select(carrier,everything())  #carrier를 제일 앞으로 eveything()을 이용하여 나머지 column을 붙임
flights %>% 
  select(-year,-month,-day)     #다음 col들을 제외!

#arrange()
flights %>% 
    arrange(dep_delay)    #dep_delay가 오름차가 되도록 재배열
flights %>% 
  arrange(desc(dep_delay))
flights %>% 
  arrange(carrier,desc(dep_delay)) #일단 carrier을 오름차 순으로 그 같은 범주 안에서 delay를 내림차로

#mutate()

flights %>% 
  mutate(speed=distance/(air_time/60)) %>% 
  select(carrier, flight, distance, air_time, speed)


#Using multiple transformations
flights %>% 
  mutate(
    gain=dep_delay-arr_delay,
    total_delay=dep_delay+arr_delay
  ) %>% 
  select(carrier, dep_delay, arr_delay, gain, total_delay)

flights %>% 
  mutate(on_time=ifelse(arr_delay<=0, "On time", "Delayed")) %>% 
  select(flight, arr_delay, on_time)

#Combining Verbs in a Workflow

#1Find the top 10 fastest flights to LA in Feb
flights %>% 
  filter(dest=="LAX", month==2, !is.na(air_time)) %>% 
  mutate(speed=distance/(air_time/60)) %>% 
  select(year,month, day, carrier, flight, speed) %>% 
  head(10)

#2Find the top 8 flights that arrived earlier than scheduled(arr_delay<0), 
#but had a long flight distance(>1000miles), and compute their arrival speed
flights %>% 
  filter(arr_delay<0, distance>1000, !is.na(air_time)) %>% 
  mutate(speed=distance/(air_time/60)) %>% 
  select(year,month, carrier, flight, distance, arr_delay, speed) %>% 
  arrange(desc(speed)) %>% 
  head(8)


###MINI EXERCISE
#1 
flights %>% filter(carrier=="DL",month==6,dep_delay>2)
#2
flights %>% mutate(delay_diff=dep_delay-arr_delay)
flights <- flights %>% mutate(delay_diff=dep_delay-arr_delay)
#3
flights %>% arrange(desc(delay_diff)) %>% select(delay_diff,everything())
#4
flights %>% select(year,month,day,carrier,dep_delay,arr_delay)



