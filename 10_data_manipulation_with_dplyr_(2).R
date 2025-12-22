###LECTURE 10###

library(tidyverse)
getwd()
setwd("C:/Users/jwlim/OneDrive/Desktop/1-2/통계소")
mobiles <- read_csv("Global_Mobile_Prices_2025_Extended.csv")

glimpse(mobiles)

mobiles %>% 
  group_by(brand) %>% 
  summarise(
    avg_price=mean(price_usd,na.rm=T),
    sd_price=sd(price_usd,na.rm=T),
    n_models=n()
  ) %>% 
  arrange(desc(avg_price))

mobiles
mobiles %>% 
  group_by(os,brand) %>% 
  summarise(
    avg_price=mean(price_usd,na.rm=T),
    avg_rating=mean(rating,na.rm=T),
    count=n()
  ) %>% 
  arrange(os,desc(avg_price))

mobiles %>% 
  mutate(
    performance_score=ram_gb*0.4+storage_gb/128+rating*0.6
  ) %>% 
  group_by(brand) %>% 
  summarise(
    avg_perf=mean(performance_score,na.rm=T),
    avg_price=mean(price_usd,na.rm=T)
  ) %>% 
  arrange(desc(avg_perf))


mobiles %>% 
  group_by(brand) %>% 
  summarise(
    avg_price=mean(price_usd,na.rm=T),
    median_price=median(price_usd,na.rm=T),
    min_price=min(price_usd,na.rm=T),
    max_price=max(price_usd,na.rm=T),
    avg_battery=mean(battery_mah,na.rm=T)
  ) %>% 
  arrange(desc(avg_battery))

##ROWWISE OPERATIONS

#Example1. Spec Index
mobiles %>% 
  rowwise() %>% 
  mutate(
    spec_index=mean(c(
      ram_gb,
      storage_gb/128,
      camera_mp/50,
      rating
    ),na.rm=T)
  ) %>% 
  ungroup() %>% 
  select(brand,model,price_usd,battery_mah,spec_index) %>% 
  head(10)

#my try
mobiles %>% 
  rowwise() %>% 
  mutate(
    spec_index=mean(c(ram_gb,
                             storage_gb/128,
                             camera_mp/50,
                             rating),na.rm=T)
  ) %>% 
  ungroup() %>% 
  select(brand, model,price_usd,battery_mah,spec_index) %>% 
  head(10)

#my second try
mobiles %>% 
  rowwise() %>% 
  mutate(
    spec_index=mean(c_across(c( ram_gb,
                                storage_gb / 128,
                                camera_mp / 50,
                                rating)),na.rm=T)
  ) %>% 
      ungroup() %>% 
      select(brand,model,price_usd,battery_mah,spec_index) %>% 
      head(10)
  


#Example2. Count How Many Specs Are "High-End"
mobiles %>% 
  mutate(
    high_ram=ram_gb>mean(ram_gb,a.rm=T),
    high_storage=storage_gb>mean(storage_gb,na.rm=T),
    high_rating=rating>mean(rating,na.rm=T)
  ) %>% 
  rowwise() %>% 
  mutate(
    high_spec_count=sum(c_across(c(high_ram, high_storage, high_rating)))
  ) %>% 
  filter(high_spec_count>=2) %>% 
  select(brand,model,ram_gb,storage_gb,rating,high_spec_count)

#my try

mobiles %>% 
  mutate(high_ram=ram_gb>mean(ram_gb,na.rm=T),
         high_storage=storage_gb>mean(storage_gb,na.rm=T),
         high_rating=rating>mean(rating,na.rm=T)) %>% 
  rowwise() %>% 
  mutate(
    high_spec_count=sum(c_across(c(high_ram,
                                 high_storage,
                                 high_rating)))
  ) %>% 
  filter(high_spec_count>=2) %>% 
  select(brand,model,ram_gb,storage_gb,rating,high_spec_count)


#Chaining Operations with %>% 
#example
mobiles %>% 
  filter(year==2025,os=="Android",price_usd<1200) %>% 
  mutate(
    perf_score = (0.5 * ram_gb) + (storage_gb / 128) + (0.8 * rating)
  ) %>% 
  group_by(brand) %>% 
  summarise(avg_perf=mean(perf_score,na.rm=T),
         avg_price=mean(price_usd,na.rm=T),
         avg_rating=mean(rating,na.rm=T),
         n_models=n()) %>% 
  arrange(desc(avg_perf)) 
  


mobiles %>% 
  filter(year==2025,os=="Android",price_usd<1200) %>% 
  mutate(perf_score=(0.5 * ram_gb) + (storage_gb / 128) + (0.8 * rating)) %>% 
  group_by(brand) %>% 
  summarise(avg_perf=mean(perf_score,na.rm=T),
            avg_price=mean(price_usd,na.rm=T),
            avg_rating=mean(rating,na.rm=T),
            n_models=n()) %>% 
  ungroup() %>% 
  arrange(desc(avg_perf))
  

###OPTIMAL VISUALIZATION

mobiles %>% 
  group_by(brand) %>% 
  summarise(
    avg_price=mean(price_usd,na.rm=T),
    avg_rating=mean(rating,na.rm=T)
  ) %>% 
  ggplot(aes(x=avg_price,y=avg_rating,label=brand))+
  geom_point(color="steelblue")+
  geom_text(vjust=-0.8,size=3)+
  labs(
    title="Average Price vs Rating by Brand",
    x="Average Price(USD)",
    y="Average Rating"
  )+
  theme_minimal()


#my try 
library(tidyverse)
library(mobiles)

mobiles %>% 
  group_by(brand) %>% 
  summarise(
    avg_price=mean(price_usd,na.rm=T),
    avg_rating=mean(rating,na.rm=T)
  ) %>% 
  ggplot(aes(x=avg_price,y=avg_rating,label="brand"))+
  geom_pont(color="pink")
  geom_text(vjust=-0.8,size=3)+
  labs(
    title="Average Price vs Rating by Brand",
    x="Average Price(USD)",
    y="Average Rating"
  )+
  theme_minimal()


###정리본 
#%>%: 결과를 다음 함수의 첫 인자로 넘긴다 — df %>% head()
#filter(): 조건을 만족하는 행 선택 — filter(price < 1000)
#mutate(): 새 변수 생성/기존 변수 변형 — mutate(kpl = mpg * 0.425)
#summarise(): 그룹/전체 요약 통계 계산 — summarise(avg = mean(price))
#group_by(): 데이터를 그룹화한다 — group_by(brand)
#ungroup(): 그룹 상태 해제 — ungroup()
#arrange(): 변수 기준으로 정렬 — arrange(desc(price))
#desc(): 내림차순 정렬을 지정 — arrange(desc(rating))
#select(): 원하는 컬럼만 선택 — select(brand, model, price)
#everything(): 모든 컬럼을 의미 — select(model, everything())
#starts_with(): 특정 문자열로 시작하는 컬럼 선택 — select(starts_with("score"))
#ends_with(): 특정 문자열로 끝나는 컬럼 선택 — select(ends_with("gb"))
#contains(): 특정 문자열이 포함된 컬럼 선택 — select(contains("price"))
#rowwise(): 계산을 행(row) 기준으로 수행 — rowwise() %>% mutate(total = sum(c(A,B,C)))
#c_across(): rowwise에서 여러 컬럼을 벡터로 묶음 — c_across(c(A,B,C))
#n(): 그룹 내 행 개수 반환 — summarise(count = n())
#mean(): 평균 계산 — mean(rating, na.rm=TRUE)
#median(): 중앙값 계산 — median(price)
#min(): 최소값 계산 — min(battery_mah)
#max(): 최대값 계산 — max(camera_mp)
#sum(): 합계 계산 — sum(storage_gb)
#sd(): 표준편차 계산 — sd(price_usd)
#ifelse(): 조건에 따라 값 선택 — ifelse(rating > 4, "high", "low")
#case_when(): 다중 조건 분기 — case_when(price > 1000 ~ "premium")
#read_csv(): CSV 파일 불러오기 — read_csv("data/file.csv")
#tibble(): tibble 객체 생성 — tibble(a=1, b=2)
#glimpse(): 데이터 구조 미리보기 — glimpse(df)
#slice(): 특정 행 번호 선택 — slice(1:5)
#head(): 데이터 앞부분 n행 출력 — head(10)
#tail(): 데이터 뒷부분 n행 출력 — tail(10)
#pull(): 특정 컬럼을 벡터로 추출 — pull(price_usd)
#n_distinct(): 유니크한 값 개수 반환 — n_distinct(brand)
#ggplot(): ggplot 그래프 생성 시작 — ggplot(df, aes(x,y))
#aes(): 그래프에서 데이터와 시각 속성 매핑 — aes(x = price, y = rating)
#geom_point(): 산점도 추가 — geom_point()
#geom_text(): 텍스트 라벨 추가 — geom_text(label = brand)
#labs(): 제목·축 레이블 설정 — labs(title="Graph")
#theme_minimal(): 미니멀 테마 적용 — theme_minimal()


###LECTURE 10 연습문제 BY GPT!!###
  
#1
mtcars
mtcars %>% 
  group_by(cyl) %>% 
  summarise(avg_hp=mean(hp,na.rm=T),
            avg_mpg=mean(mpg,na.rm=T)) %>% 
  ungroup() %>% 
  arrange(desc(avg_hp))


#2
iris
iris %>% 
  rowwise() %>% 
  mutate(size_index=sum(c(Sepal.Length,Sepal.Width,Petal.Length,Petal.Width)/4)) %>% 
  ungroup() %>% 
  select(Sepal.Length, Petal.Length, Species, size_index) %>% 
  head(10)

#3
airquality
airquality %>% 
  filter(Month==7,Temp>=80) %>% 
  mutate(comfort_score=(Temp * 0.3) - (Wind * 0.2) + (Ozone / 10)) %>% 
  group_by(Month) %>% 
  summarise(
    avg_comfort_score=mean(comfort_score,na.rm=T),
    avg_Ozone=mean(Ozone,na.rm=T),
    n_data=n()
  ) %>% 
  ungroup() %>% 
  arrange(desc(avg_comfort_score)) 

#4
ToothGrowth
ToothGrowth %>% 
  group_by(supp) %>% 
  summarise(
    avg_len=mean(len),
    sd_len=sd(len)
  ) %>% 
  ungroup() %>% 
  ggplot(aes(x=supp,y=avg_len,label=supp))+
  geom_point(color="green")+
  geom_text(vjust=-0.5)+
  labs(
    title="Average Tooth Length by Supplement Type",
    x="supp",
    y="avg_len"
  )+
  theme_minimal()

