###LECTURE 13 (P)###
getwd()
setwd("C:/Users/jwlim/OneDrive/Desktop/1-2/통계소")
read.csv("starbucks_drinkMenu_expanded.csv")


#data: the dataset to visualize
#aes(): the aesthetic mapping: variables to visual attributes
#geom_(): geometric objects like points, lines, bars....
#the structure of a ggplot is 
# ggplot(data)+
#    aes(mapping)+
#    geom_()+
#    additional layers....


library(tidyverse)
library(ggplot2movies)

###DENSITY and HISTOGRAM

movies %>% view()
movies %>% ggplot(aes(x=rating))+
  geom_histogram()

#확률밀도 함수로 그리기
#color에 mpaa를 넣는 것 자체가 그것의 범주별로 색깔을 나눈다는 의미

movies %>% ggplot(aes(x=rating, color=mpaa))+  
  geom_density()  

#ggplot이 아니라 geom_함수 안에 color를 넣으면 전체를 계산하되 그 색을 지정하는 것뿐

movies %>% ggplot(aes(x=rating))+
  geom_density(color="blue",linewidth=0.8)

#binwidth는 간격, fill은 채우는 색, color은 테두리

movies %>% ggplot(aes(x=rating))+
  geom_histogram(binwidth = 0.5,
                 fill="steelblue",
                 color="white")+
  labs(title="Distribution of Movie Ratings")

#alpha는 투명도를 조정하는 역할

movies %>% ggplot(aes(x=rating))+
  geom_density(fill="lightblue",alpha=0.5)+
  labs(title="Rating Density")


###BARPLOT

#mpaa는 질적변수니까 histogram이나 density로 나타내지 않음!!!

movies %>% ggplot(aes(x=mpaa))+
  geom_bar(fill="darkgreen")+
  labs(title="MPAA Rating Frequency")

###BARPLOT(COL)

#reorder(범주변수, 기준이 되는 수치변수)
#pivot_longer/wider복습 시급,,,
#theme_minimal() 은 정리하는 역할

movies %>% 
  select(Action:Short) %>% 
  summarise(across(everything(),sum)) %>% 
  pivot_longer(cols=everything(),
               names_to="genre",
               values_to="count") %>% 
  ggplot(aes(x=reorder(genre,-count),y=count))+   #genre가 x축이지만 count가 descend reorder
  geom_col(fill="steelblue")+
  theme_minimal() #

genre_long <- movies %>% 
  pivot_longer(cols=Action:Short, names_to="genre",values_to="is_genre") %>% 
  filter(is_genre==1)

#자료 한 번 정리
#geom_bar과 geom_col의 차이? 
#bar은 이미 있는 걸 세어주는 그래프이고, col은 계산한 값을 나타내는 그래프!!!

genre_long %>% 
  group_by(genre) %>% 
  summarise(avg_length=mean(length,na.rm=T)) %>% 
  ggplot(aes(x=reorder(genre,-avg_length),y=avg_length))+
  geom_col(fill="darkgreen")+
  labs(title="Average Movie Length by Genre")+
  theme_minimal()

#SCATTRPLOT

#scale_x_log10()

movies %>% ggplot(aes(x=budget,y=rating))+
  geom_point(alpha=0.3)+
  scale_x_log10()+
  labs(title="Budget vs Rating (log scale)")

#0/1의 더미 변수를 이름으로 변환하는 과정을 거친다

movies %>% 
  mutate(is_comedy=ifelse(Comedy==1,"Comedy","Other")) %>% 
  ggplot(aes(x=is_comedy,y=rating,fill=is_comedy))+
  geom_boxplot(alpha=0.8)+
  labs(title="Ratings: comedy vs Non-comedy")

genre_long <- movies %>% 
  pivot_longer(cols=Action:Short,
               names_to="genre",
               values_to="is_genre") %>% 
  filter(is_genre==1)

ggplot(genre_long,aes(x=genre,y=rating))+
  geom_boxplot()+
  labs(title="Rating Distribution by Genre",x="Genre",y="Rating")+
  theme_minimal()+
  theme(axis.text.x=element_text(angle=45,hjust=1))


#theme() 의 역할은 그래프의 데이터와는 전혀 상관없이, 글자·선·여백·배치 같은 ‘디자인 요소’를 조절
#그래서 보통 가장 마지막에 위치
#위의 경우 text의 axis를 바꿈

#geom_line은 기본적으로 같은 '그룹'에 있는 함수를 이어줌
#이때 group=1이라는 코드로 현재 모든 관측치를 묶어주는 것
#size는 점의 크기를 조절 geom_point(size=)

starbucks %>% view()
starbucks <- read.csv("starbucks_drinkMenu_expanded.csv")
starbucks %>% 
  filter(Beverage=="Caffè Latte") %>% 
  ggplot(aes(x=Total.Fat..g.,y=Calories,group=1))+
  geom_line()+
  geom_point(size=3)+
  labs(title="Calories by Total Fat")

#년도 별 영화 장르의 변화

movies %>% 
  select(year,Action:Short) %>% 
  pivot_longer(cols=Action:Short,
               names_to="genre",
               values_to="is_genre") %>% 
  filter(is_genre==1) %>% 
  group_by(year, genre) %>% 
  summarise(count=n(),.groups="drop") %>% 
  ggplot(aes(x=year, y=count, color=genre))+
  geom_line()+
  labs(title="Genre Trends Over Time",x="Year",y="Number of Movies")+
  theme_minimal()

#FACETING

#facet_wrap는 하나의 그래프는 ~()의 범주별로 여러개로 나눠줌
#scales="free"는 각자 자기에게 맞는 축을 자유롭게 쓰라는 의미

movies %>% ggplot(aes(x=rating))+
  geom_histogram(binwidth=0.5,fill="purple",color="white") +
  facet_wrap(~mpaa,scales='free')+
  labs(title="Rating Distributions by MPAA")

#facet_wrap에 아무것도 안 적혀있으면 scale="fixed"가 기본
#free: 분포 형태가 목적일 때, #fixed: 값 비교가 목적일 떄

starbucks %>% ggplot(aes(x=Calories)) +
  geom_histogram(binwidth = 20, fill="orange")+
  facet_wrap(~Beverage_category)+
  labs(title="Calorie Distribution by Beverage Category")

#rating이라는 수치 변수를 “색”에 매핑(mapping)한다
#rating 이 y축으로 한번, 색으로도 한번 매핑
#연속형 변수 이므로 자동으로 범례(legend) 형성함

movies %>% ggplot(aes(x=votes,y=rating,color=rating))+
  geom_point(alpha=0.6,size=2)+
  scale_x_log10()+
  labs(title="Votes vs Rating")

#shape encoding: color말고 shape로 범주로 나눔
#당연히 ggplot단계에서 설정하고 들어가는 것

starbucks %>% 
  mutate(Beverage_category=case_when(
    str_detect(Beverage_category,'Coffee') ~ "Coffee",
    str_detect(Beverage_category,'Espresso') ~ "Espresso",
    T ~ "Else"
  )) %>% 
  ggplot(aes(x=Total.Fat..g.,y=Calories,shape=Beverage_category))+
  geom_point(size=3)+
  labs(title="Calories vs Fat by Beverage Category")

#labs에 제목 말고 x축이랑 y축에 대한 구체적인 명칭도 적을 수 있다!

movies %>% ggplot(aes(x=year))+
  geom_histogram(fill="darkred",color="white")+
  labs(
    title="Distribution of Movie Year",
    x="Release Year",
    y="Count"
  )

#theme을 뭘 설정하느냐에 따라 미세한 차이가 있음

movies %>% ggplot(aes(x=year))+
  geom_density(fill="lightblue",alpha=0.5)+
  theme_minimal()

movies %>% ggplot(aes(x=year))+
  geom_density(fill="lightblue",alpha=0.5)+
  theme_bw()


