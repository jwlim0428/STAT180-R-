###LECTURE 12(P)###

#Text data handling

library(tidyverse)

x <- c("Seoul","Busan","Incheon","Daegu")

str_length(x)
str_to_upper(x)
str_to_lower(x)
str_sub(x,1,3)      #str_sub(대상,시작,끝)

str_c("University","of","Korea",sep=" ")  #string combine
str_c(x, collapse=", ")                   #str_c(대상, collapse(압축)=",")

text <- "Statistics, Mathematics, Computer Science"
str_split(text,", ")

#extracting numbers

phones <- c("User1: 010-1234-5678", "User2: 010-9876-5432")
str_extract(phones,"\\d{3}-\\d{4}-\\d{4}")

#\\d: digit
#{3} the number of repetitions
#str_extract(대상,pull하는 것)

#extract alphabetic words

str_extract_all("Welcome to Korea University in 2025!", "[A-Za-z]+")
text <- "The total score is 87 out of 100"
str_extract_all(text,"\\d")

#detecting strings starting/ending with specific letters
cities <- c("Seoul","Busan","Suwon", "Suncheon", "Sejong", "Jeju")
str_detect(cities,"^S")   #starts with "S" (T/F)
str_detect(cities,'on$')  #ends with "on" (T/F)
str_subset(cities,"Su")   #contains "Su"

#detecting and replacing missing text
names <- c("Kim","",NA,"Park")
#^는 문자열의 시작, $은 문자열의 끝, 둘이 이어진 것은 빈 공간 의미
str_detect(names,"^$")    #""가 있는 T/F

is.na(names)
replace_na(names,"Unknown")



#date and time data
#use lubridate package
library(tidyverse)
library(lubridate)
today()
now()
ymd("2025-03-01")
mdy("march 1 2025")
dmy("01-03-2025")

d <- ymd("2025,03,01")
year(d)
month(d)
day(d)
month(d,label=T)

wday(d)     #요일을 숫자로 변환한거
wday(d,label=T)

d <- today()
wday(d)
wday(d,label=T)

#d에다가 간단 계산하는 방법
d+days(10)
d-weeks(2)

interval(ymd("2025 01 01"),today())    #interval(start_date, end_date): 두 날짜 사이 시간 구간 정리
as.duration(interval(ymd("2025-01-01"),today()))

dt <- ymd_hms("2025-03-01 14:30:00")
dt+hours(2)
dt-minutes(45)

?make_date
#make_date(year, month = 1L, day = 1L) (1이 기본값)
airquality
airquality %>% 
  mutate(
    Date=make_date(1973,Month,Day)
  ) %>% 
  filter(Date>=ymd("1973-07-01")&Date<=ymd("1973-07-10")) %>% 
  select(Date,Ozone,Temp)


#Formatting and Parsing
format(today(), "%B %d %Y")
format(ymd("2025-04-01"),"%Y %m %d (%A)")
#format(대상,"% % %")
# %Y: 연도 4자리
# %y: 연도 2자리
# %m: 월 2자리
# %B: 월 이름 전체
# %b: 월 이름 영문 축약
# %d: 일 2자리
# %A: 요일 이름 전체
 

sales <- tibble(
  region=c("Seoul","Busan","Incheon"),
  date=ymd(c("2025-01-01","2025-02-01","2025-03-01")),
  revenue=c(120,95,105)
)
sales %>% 
  mutate(
    label=str_c(region,":",format(date,"%b %d"),"-> $", revenue, "k")
  )


#Practice Examples

#Example 1
product_codes<-c(
  "PRD-001-A","X-23","item#445","PRD-999-Z",
  "code:12-AB","INVALID","PRD-12-B2"
)
str_extract(product_codes,"PRD-[0-9]{3}-[A-Z]")

#Example 2
dates_raw<-c(
  "2025-03-01",
  "03/05/25",
  "March7,2025",
  "2025.03.08",
  "08-03-2025"
)
parsed<-parse_date_time(
  dates_raw,
  orders=c("Ymd","mdy","BdY","dmY")
)
parsed

#Example 3
students<-tibble(
  name=c("Kim","Lee","Park","Choi"),
  birth= ymd(c("2000-05-03","1999-12-20","2001-01-15","1998-07-09"))
)
students
students %>% 
  mutate(
    age=floor(
      interval(birth,today()) %>% time_length("years")
    )
  )
#floor은 소수점을 버리는 함수
#time_length("특정 단위로 환산")

#Example 4
log_times<-ymd_hms(c(
  "2025-03-01 02:15:00",
  "2025-03-01 09:30:00",
  "2025-03-01 16:45:00",
  "2025-03-01 22:10:00"
))

tibble(timestamp=log_times) %>% 
  mutate(
    hour=hour(timestamp),
    period=case_when(
      hour<6 ~ "Dawn",
      hour<12 ~ "Morning",
      hour<18 ~ "Afternoon",
      TRUE~ "Night"
    )
  )
