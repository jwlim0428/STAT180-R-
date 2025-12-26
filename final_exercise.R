#final exercise


library(tidyverse)

#Problem 1 

log_data <- tibble(
  log_id = 1:5,
  date_str = c("2024-12-01", "2024-12-01", "2024-12-02", "2024-12-02", "2024-12-03"),
  time_str = c("09:30:00", "22:15:00", "14:00:00", "03:45:00", "18:20:00"),
  response_time_ms = c(120, 800, 45, 1500, 200)
)
glimpse(log_data)

log_data %>% view()

log_data %>% mutate(
  timestamp_q=paste(date_str, time_str),
  timestamp=ymd_hms(timestamp_q),
  hour_of_day=hour(timestamp),
  speed_category=case_when(
    response_time_ms>=1000 ~ "Slow",
    response_time_ms<1000 ~ "Fast"
  )
) %>% select(log_id,date_str,time_str,response_time_ms,timestamp,hour_of_day) %>% 
  view()



#Problem 2

scores<-tibble(
  student_id=1:5,
  Math_Score=c(80,90,75,60,95),
  English_Score=c(85,88,70, 65,92),
  Class= c("A","A","B","B", "A")
)
print(scores)

long_score <- scores %>% 
  pivot_longer(cols=c(Math_Score,English_Score),
               names_to="Subject",
               values_to="Score") %>% 
  mutate(Subject=str_remove(Subject,"_Score")) %>% view()
long_score %>% 
  group_by(Class,Subject) %>% 
  summarise(avg_score=mean(Score))
long_score %>% 
  ggplot(aes(x=student_id,y=Score,color=Subject))+
  geom_line()+
  theme_minimal()

#Problem 3

# 회원 정보
members <- tibble(
  member_ref = c("M001", "M002", "M003"),
  age_info = c("Age: 20s", "Age: 30s", "Age: 40s"),
  region = c("Seoul", "Busan", "Seoul")
)

# 구매 이력
orders <- tibble(
  order_id = 101:105,
  member_ref = c("M001", "M001", "M002", "M003", "M002"),
  amount = c(1000, 2000, 1500, 3000, 500)
)

joined <- orders %>% 
  left_join(members) %>% view()
joined %>% mutate(
  age_numeric=str_extract(age_info,"\\d{2}")
) %>% filter(region=="Seoul")

#Problem 4

house <- tibble(
  price = c(500, 600, 450, 700, 550, 800, 200, 650),
  size_sqm = c(50, 60, 45, 70, 55, 80, 40, 65),
  location = c("Gangnam", "Gangnam", "Gangbuk", "Gangnam",
               "Gangbuk", "Gangnam", "Gangbuk", "Gangbuk")
  ) %>% view()

quantile(house$price,0.3) 



house %>% 
  mutate(
    price_class=case_when(
      price>=quantile(house$price,0.3) ~"Expensive",
      T ~ "Normal"
    )
  )
model <- lm(price ~ size_sqm + location, data = house)
model
?quantile


#Problem 5
inventory <- tibble(
  entry_id = 1:5,
  raw_text = c(
    "Item: <Keyboard-K1> Price: $45.00 / Qty: 5",
    "Item: <Mouse-M2> Price: $20.50 / Qty: 10",
    "Item: <Monitor-D4> Price: $150.00 / Qty: 2",
    "Item: <Laptop-P9> Price: $1200.99 / Qty: 1",
    "Item: <Stand-S1> Price: $15.50 / Qty: 20"
  )
)
inventory %>% view()

inventory %>% 
  mutate(
    product_code=str_extract(raw_text,"<.+>"),
    product_code=str_remove_all(product_code,"<|>"),
    price_numeric=as.numeric(str_extract(raw_text,"\\d+.\\d+")),
    category=str_extract(product_code,"[A-Za-z]+")
  ) %>% view()


#Problem 6

raw_sales <- tibble(
  date = c("2025-05-01", "05/12/25", "2025.05.20", "May 25, 2025", "2025-06-01"),
  region_code = c("KR-Seoul", "US-NY", "KR-Busan", "US-LA", "KR-Seoul"),
  revenue = c("$2,000", "1500 USD", "$800", "Not Available", "3000")
) %>% view()

raw_sales %>% 
  mutate(
    date=parse_date_time(raw_sales$date,order=c("ymd","mdy","ymd","Bdy","ymd")),
    revenue=str_remove_all(raw_sales$revenue,"[^0-9]") %>% 
      as.numeric() %>% 
      replace_na(0),
    city=str_remove(raw_sales$region_code,"^[A-Z]{2}-")
  ) %>% group_by(city) %>% 
  summarise(total_revenue=sum(revenue)) %>% 
  arrange(desc(total_revenue)) %>% view()

#Problem 7

stock_prices <- tibble(
  company = c("A_Corp", "B_Inc", "C_Ltd"),
  `2025-01` = c(100, 200, 50),
  `2025-02` = c(110, 180, 55),
  `2025-03` = c(120, 190, 60)
) %>% view()

company_info <- tibble(
  company = c("A_Corp", "B_Inc", "C_Ltd"),
  sector = c("Tech", "Finance", "Energy")
) %>% view()

longer_stock <- stock_prices %>% 
  pivot_longer(cols=c('2025-01','2025-02','2025-03'),
               names_to="date",
               values_to="price")

longer_stock

joined_sector <-  company_info%>% 
  left_join(longer_stock) %>% view()

joined_sector %>% 
  mutate(
    before_stocks=lag(price,n=1),
    returns=((price-before_stocks)/before_stocks)
  ) %>% 
  select(company,sector,date,price,returns) %>% 
  arrange(desc(returns)) 

###########

joined_sector %>% 
  mutate(date=ym(date)) %>% 
  group_by(company) %>% 
  arrange(date) %>% 
  mutate(
    prev_price=lag(price,n=1),
    returns=(price-prev_price)/prev_price
  ) %>% ungroup() %>% 
  arrange(desc(date) %>% group_by(date))



mpg       
manufacturer<- mpg %>% group_by(manufacturer) %>% 
  summarise(avg_hwy=mean(hwy)) %>% 
  arrange(desc(avg_hwy)) %>% select(manufacturer)


?fct_reorder

mpg %>% mutate(
  manufacturer=fct_reorder(manufacturer,hwy,.fun=mean)) %>% 
  ggplot(aes(x=manufacturer,fill=class))+
  geom_bar(position="stack")+
  theme_minimal()


#Problem 8
mpg %>% ggplot(aes(x=displ,y=cty,color=drv))+
  geom_point(size=2,alpha=0.6)+
  facet_wrap(~class,ncol=2)+
  labs(title="Engine Displacement vs City MPG by Class",
       x="Displacement(L)",
       y="City MPG")+
  theme_bw()

economics %>% view()
economics %>% 
  mutate(date=ymd(date)) %>% 
  filter(date>=ymd("2000-01-01")) %>% 
  mutate(
    unemployment_rate=unemploy/pop
  ) %>% 
  ggplot(aes(x=date,y=unemployment_rate))+
  geom_line(color="darkred",linewidth=1)+
  geom_point(size=1,alpha=0.5)+
  labs(title="US Unemployment Rate Trends (Since 2000)",
       x="Year",
       y="Unemployment Rate")+
  theme_classic()

