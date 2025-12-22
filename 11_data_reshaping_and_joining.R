###LECTURE 11###

library(tidyverse)
getwd()
mobiles <- read_csv("Global_Mobile_Prices_2025_Extended.csv")

mobiles

price_trend <- tibble(
  brand = c("Samsung", "Apple", "Xiaomi"),
  price_jan = c(900, 1100, 700),
  price_feb = c(880, 1080, 680),
  price_mar = c(860, 1060, 650)
)
price_trend


price_long <- price_trend %>%
  pivot_longer(
    cols = starts_with("price_"),
    names_to = "month",
    values_to = "price"
  )
price_long

price_trend%>%
  gather(key='month',value='price',
         price_jan:price_mar)

price_long%>%
  spread(key='month',value='price')


df1 <- tibble(brand = c("Samsung", "Apple"), price = c(950, 1100))
df2 <- tibble(brand = c("Xiaomi", "Oppo"), price = c(700, 600))
bind_rows(df1, df2)
rbind(df1,df2)

#rbind와 bind_row의 차이?
#개수가 맞지 않는 경우
df1 <- tibble(brand = c("Samsung", "Apple"), price = c(950, 1100), rate=c(5,5))
df2 <- tibble(brand = c("Xiaomi", "Oppo"), price = c(700, 600))
bind_rows(df1, df2)
rbind(df1,df2)   #rbind 불가!

df1 %>% bind_rows(df2)
df1 %>% rbind(df2)


mobile_specs <- mobiles %>%
  select(model, brand, ram_gb, storage_gb, os) %>%
  slice(1:6)

mobile_specs <- mobiles %>%
  select(model, brand, ram_gb, storage_gb, os) %>%
  .[1:6,]


mobile_price <- mobiles %>%
  select(model, price_usd, rating) %>%
  slice(1:6)


mobile_price

mobile_specs %>% left_join(mobile_price,by="model")
mobile_specs %>% right_join(mobile_price,by="model")
#left join은 왼쪽에 있는 데이터 기준
#mobile_specs는 그대로 둔 채 옆에 새 데이터 붙이기


mobile_specs %>%
  inner_join(mobile_price, by = "model")
mobile_specs %>%
  full_join(mobile_price, by = "model")

survey <- tibble(
  respondent = c("A", "B", "C"),
  satisfaction_jan = c(4, 5, 3),
  satisfaction_feb = c(5, 4, 4),
  satisfaction_mar = c(5, 3, 4)
)

survey_long <- survey %>%
  pivot_longer(
    cols = starts_with("satisfaction_"),
    names_to = "month",
    values_to = "score"
  ) %>%
  mutate(month = str_remove(month, "satisfaction_"))
survey_long

month_lookup <- tibble(
  month=c("jan","feb","mar"),
  month_num=1:3
)

survey_long %>%
  left_join(month_lookup, by = "month")






###나의 LECTURE 11 정리라고 쓰고 공부###

library(tidyverse)
getwd()
mobiles <- read_csv("Global_Mobile_Prices_2025_Extended.csv")


price_trend <- tibble(
  brand=c("Samsung","Apple","Xiaomi"),
  price_jan=c(900,1100,700),
  price_feb=c(880,1080,680),
  price_mar=c(860,1060,650)
)
price_trend


#PIVOT_LONGER, PIVOT_WIDER

price_long <- price_trend %>% 
  pivot_longer(
    cols=starts_with("price_"),
    names_to="month",    #column name의 새로운 var
    values_to="price"    
  )
?pivot_longer
price_long

billboard
billboard %>%
  pivot_longer(
    cols = starts_with("wk"),
    names_to = "week",
    names_prefix = "wk",
    values_to = "rank",
    values_drop_na = TRUE
  )

price_long %>% 
  mutate(month=str_remove(month,"price_"))
#str_remove() = 문자열에서 특정 패턴을 한 번 제거하는 함수
#month에서 price_를 제거하라는 (수정) 명령
#mutate는 추가도 되지만 기존의 것을 수정하는데에도 사용!!


price_long %>% 
  pivot_wider(
    names_from=month,
    values_from=price
  )

#GATHER():pivot_longer, SPREAD():pivot_wider

price_trend %>% 
  gather(key="month",value="price",price_jan:price_mar)
#price_jan부터 mar까지 month라는 이름으로 price를 value로 저장
#gather(key,value,col의 범위)   순서 지켜야함

price_long %>% 
  spread(key=month,value=price)

#COMBINING AND MERGING DATA
df1 <- tibble(brand=c("Samsung","Apple"),
              price=c(950,1100))
df2 <- tibble(brand=c("Xiaomi","Oppo"),
              price=c(700,600))
#row로 묶기 때문에 vertically stack 하는 형태
bind_rows(df1,df2)

#dataframe으로 묶어야하기 때문에 tibble 사용
df3 <- tibble(storage=c(128,256,128,64))
bind_cols(bind_rows(df1,df2),df3)


#JOINING TABLE BY KEYS
mobile_specs <- mobiles %>% 
  select(model,brand,ram_gb,storage_gb,os) %>% 
  slice(1:6)
mobile_specs
mobile_price <- mobiles %>% 
  select(model,price_usd,rating) %>% 
  slice(1:6)
mobile_price


mobile_specs %>% 
  left_join(mobile_price,by="model")
mobile_specs %>% 
  inner_join(mobile_price,by="model")
mobile_specs %>% 
  right_join(mobile_price,by="model")
mobile_specs %>% 
  full_join(mobile_price,by="model")




#PRACTICAL EXAMPLE
#1
survey <- tibble(
  respondent=c("A","B","C"),
  satisfaction_jan=c(4,5,3),
  satisfaction_feb=c(5,4,4),
  satisfaction_mar=c(5,3,4)
)

survey_long <- survey %>% 
  pivot_longer(
    cols=starts_with("satisfaction_"),
    names_to="month",
    values_to="score"
  ) %>% 
  mutate(month=str_remove(month,"satisfaction_"))
survey_long

#2
month_lookup <- tibble(
  month=c("jan","feb","mar"),
  month_num=1:3
)
month_lookup
survey_long %>% 
  left_join(month_lookup,by="month")

#먼저 온 survey_long이 먼저

#CHAINING EVERYTHING TOGETHER

final_summary <- mobiles %>% 
  select(brand,model,price_usd,rating,ram_gb,storage_gb) %>% 
  filter(!is.na(price_usd)) %>% 
  mutate(price_category=case_when(
    price_usd>1000~"Premium",
    price_usd>600~"Mid~range",
    TRUE~"Budget"
  )) %>% 
  group_by(brand,price_category) %>% 
  summarise(
    avg_price=mean(price_usd,na.rm=T),
    avg_rating=mean(rating,na.rm=T),
    n_models=n()
  ) %>% 
  arrange(desc(avg_price))
final_summary  




###연습문제 풀기

sales_raw <- tibble(
  brand = c("Samsung", "Apple", "Xiaomi"),
  sales_jan = c(950, 880, 720),
  sales_feb = c(910, 860, 700),
  sales_mar = c(920, 870, 690)
)

new_sales <- sales_raw %>% 
  pivot_longer(cols=starts_with("sales_"),
               names_to="month",
               values_to="sales"
  ) %>% 
  mutate(month=str_remove(month,"sales_"),
         month_order=case_when(
           month=="jan"~1,
           month=="feb"~2,
           month=="mar"~3
         )) %>% 
  arrange(month_order) %>% 
  select(-month_order)
new_sales

#2

new_sales_df <- new_sales %>% 
  mutate(perf_score=sales/100) %>% 
  group_by(brand) %>% 
  summarise(
    avg_sales=mean(sales),
    avg_perf=mean(perf_score)
  ) %>% 
  arrange(desc(avg_sales))
new_sales_df

#3
spec_df <- tibble(
  brand = c("Samsung", "Apple", "Xiaomi"),
  ram_score = c(8, 7, 6),
  storage_score = c(7, 9, 5),
  camera_score = c(9, 8, 6)
)
new_sales_df %>% 
  left_join(spec_df,by="brand") %>% 
  rowwise() %>% 
  mutate(
    spec_avg=mean(c_across(c(ram_score,storage_score,camera_score)))
  ) %>% 
  ungroup %>% 
  arrange(desc(spec_avg)) %>% 
  view()

new_sales_df %>% 
  left_join(spec_df,by="brand") %>%
  view()

#4
region_A <- tibble(
  brand = c("Samsung", "Apple", "Xiaomi"),
  revenue_Q1 = c(12, 10, 8),
  revenue_Q2 = c(13, 11, 9)
)

region_B <- tibble(
  brand = c("Samsung", "Apple", "Xiaomi"),
  revenue_Q1 = c(11, 9, 7),
  revenue_Q2 = c(12, 10, 8)
)

region_a <- region_A %>% 
  mutate(region="A")
region_b <- region_B %>% 
  mutate(region="B")
binded <- bind_rows(region_a,region_b)
view(binded)

binded %>% 
  pivot_longer(col=starts_with("revenue_"),
               names_to="quarter",
               values_to="revenue") %>% 
  mutate(quarter=str_remove(quarter,"revenue_")) %>% 
  group_by(brand,quarter) %>% 
  summarise(avg_revenue=mean(revenue))
