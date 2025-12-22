###LECTURE 8###
library(tidyverse)

mtcars %>% 
  as_tibble() %>% 
  filter(mpg>20) %>% 
  select(mpg,cyl,hp)

df <- as_tibble(mtcars)
df

glimpse(df)  #compact stucture view

getwd()
setwd("C:/Users/jwlim/OneDrive/Desktop/1-2/통계소")
wine <- read_csv("winequality-red.csv")

glimpse(wine)


####DPLYR CORE VERBS
#FILTER: keep the rows
df %>% 
  filter(mpg>20)    #df중에서 mpg가 20보다 큰 것 뽑아내기

df %>% 
  filter(mpg>20, cyl==4)   #,은 AND의 의미를 지님

df %>% 
  filter(mpg>20|cyl==4)

df %>% 
  filter(cyl %in% c(4,6))  #%in% = “왼쪽 값이 오른쪽 목록에 들어있으면 TRUE”

df %>% 
  filter(mpg>20|(cyl %in% c(4,6)))


#SELECT: choose the columns
df %>% 
  select(mpg,cyl,hp)

df %>% 
  select(starts_with("d"),ends_with("t"))  #Helpers

#MUTATE: add/transform columns
df %>% 
  mutate(power_to_weight=hp/wt)  #power_to_weight라는 변수를 새로 추가함..
df$power_to_weight               #영구적? 인것이 아님..
df <- df %>%                     #값은 따로 넣어야함. 
  mutate(power_to_weight=hp/wt) 
df$power_to_weight        

df %>% 
  mutate(
    kpl=mpg*0.425,
    hp_per_cyl=hp/cyl
  )

#TRANSMUTE: when you only want the new columns
df %>% 
  transmute(               
    kpl=mpg*0.425,
    hp_per_cyl=hp/cyl
  )

#ARRANGE: reorder the rows
df %>% arrange(desc(mpg))

df %>% arrange(cyl,desc(hp))   #cyl를 먼저 오름차순으로 정렬, 이후 그 안에서 hp는 desc order.

#요약된 값으로 만듦
#SUMMARISE:
#GROUP_BY:
df %>% 
  summarise(
    mean_mpg=mean(mpg),
    max_hp=max(hp)
  )

df %>% 
  group_by(cyl) %>% 
  summarise(
    n=n(),
    avg_mpg=mean(mpg),
    avg_hp=mean(hp),
    .groups="drop"  #ungroup after summarising(cyl로 그룹화되어 있던 것 해제)
  )


#JOINS: combining tables
employees <- tibble(
  emp_id=1:5,
  emp_name=c("Alice","Bob","Carol","David","Eve"),
  dept_id=c(10,20,10,30,20)
)

departments <- tibble(
  dept_id=c(10,20,30,40),
  dept_name=c("HR","Finance","IT","Marketing")
)
inner_join(employees,departments,by="dept_id")
employees %>% 
  inner_join(departments,by="dept_id")         # %>% 을 써도 join가능

left_join(employees,departments,by="dept_id")

right_join(employees,departments,by="dept_id")

full_join(employees,departments,by="dept_id")


###GGPLOT2 WORKFLOW
mtcars_tbl <- as_tibble(mtcars)
mtcars_tbl %>% ggplot(aes(x=wt,y=mpg))+
  geom_point()+
  labs(
    title="Scatter Plot: MPG vs Weight",
    x="Weight(10001bs)",
    y="Miles per Gallon(MPG)"
  )

mtcars_tbl %>%
  ggplot(aes(x=wt,y=mpg,color=factor(cyl)))+   #cyl을 범주형 변수로 취급해서 색깔달리함함
  geom_point(alpha=0.7)+
  labs(title="MPG vs Weight by Cylinders")+
  theme_minimal()
#ggplot() → geom_point() → labs()/theme() 순서는 유지해야 함!!!

###PUTTING IT TOGETHER: A TINY PIPELINE
as_tibble(mtcars) %>% 
  filter(mpg>20,cyl==4) %>% 
  mutate(power_to_weight=hp/wt) %>% 
  arrange(desc(power_to_weight)) %>% 
  select(mpg,cyl,hp,wt,power_to_weight)
  
