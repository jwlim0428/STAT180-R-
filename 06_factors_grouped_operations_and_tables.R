##################################
####     통계소 연습장CH6     ####
##################################

##################################

###FACTOR
#factor: a vector with additional information(levels)
#level: the unique(non-overlapping) values on a vector (주로 명목변수를 지칭)
#use factor(): to convert a vector in to a factor

  x <- c(5,10,5,8,10)
y <- factor(x)        #3,10,5를 다 하나의 levels을 가진 factor(범주..?) 마냥 취급해줌
str(y)

##Additional properties
#length(y): returns the number of elements
#levels(y): returns the distinct levels
#length(levels(y)) or nlevels(y) returns the number of levels

length(y)
levels(y)
length(levels(y))

nlevels(y)

z <- factor(x,levels=c(5,8,10,15))    #물론 x에는 15가 없지만 level자체는 존재함
z
z[5] <- 12   #z의 다섯 번째 자리에다가 12를 넣겠다는 의미

##Applying functions by factor
#tapply(x,f,g) applies a function g to vector  x for each level defined by factor f
#the result is typically a vector a matrix

score <- c(92,84,80,67,80,75,60,93,77,84)
dept <- c("a","b","b","c","a","c","a","b","c","a")
tapply(score,dept,mean)
#tapply(X,INDEX,FUN)
#위의 경우 score이라는 점수데이터를 dept라는 범주로 구분하여 mean을 구하는 방식

d <- data.frame(
  gender=c("M","F","M","F","F","M"),
  age=c(35,27,33,28,37,29),
  salary=c(5200,3500,4700,3100,4600,4800)
)

#ifelse(조건, 참일 때의 값, 거짓일 때의 값) 형식으로 다음과 같이 dataframe활용
d$age30 <- ifelse(d$age>30,1,0)
d

tapply(d$salary,d[,c("gender","age30")],mean)
#이건 tapply를 활용한 함수, salary의 data를 사용하는데, d[,]에서 모든행 중에서
#gender과 age30라는 두 열만 추출하는 것. tapply는 여러 열이면 자동으로 다차원 구조 만드는 규칙이 있음

#다른 방식으로는,
with(d, tapply(salary, list(gender,age30),mean))

#아니면 age30을 factor로 바꿔서 용이하게 만드는 방법도 존재
d$age30 <- factor(d$age30,levels=c(0,1),labels=c("<=30",">30"))
with(d,tapply(salary,list(gender,age30),mean))

##위에 거 돌릴 때 저장된 형태 주의!

d
d$age30 <- ifelse(d$age>30,1,0)
d$age30 <- factor(df$age,function(x){ifelse(x<=30,0,1)})
with(d,tapply(salary,list(gender,age30),mean))


##SPLITING DATA WITH SPLIT()

#split(x,f): vector나 dataframe x를 factor f에 따라서 split 해준다
split(d,d$gender)
split(d,list(d$gender,d$age30))   #이럴 경우 4가지의 경우의 수로 나뉨..


##USING by() TO APPLY FUNCTIONS

#by(x,f,g): 함수 g를 factor f로 정의된 matrix나 dataframe인 x에 실행, 
#calculate correlations for subsets of the iris set
?iris
matplot(iris)
str(iris)
head(iris)

by(iris[,1:2],iris$Species,cor)
#참고로 cor은 correlation, 상관관계를 분석하는 거

###TABLE

#creating a table from a data
x <- data.frame(
  vote=c('Y','Y','N','Y','N'),
  age20=c(0,1,1,0,0),
  party=c('D','R','D','D','R')
)
x
table(x)
#useNA: "ifany" includes NA counts    #NA가 있어도 count 한다는 의미
#dnn=c("vote","age20","party") sets dimension names

##TABLE OPERATIONS

#table objects behave similarly to matrices or dataframes
x <- list(
  vote=c('Y','Y','N','Y','N'),
  age20=c(0,1,1,0,0)
)
x
tb <- table(x)
tb
class(tb)

tb[1,]
tb/sum(tb)   #각 조합이 전체에서 차지하는 비율!

apply(tb,2,sum)   #tb의 데이터들의 열에 있는 값들을 다 sum하는 것

addmargins(tb)    #각 행과 열들을 다 더하는 것!

dimnames(tb)$age20 <- c("N","Y")  #age20의 비어있는 이름 값에 N과 Y를 적어줌

##aggregate()와 cut() 함수??
#aggregate()는 tapply()를 각각의 변수에 대해서 한 번씩 부름
#cut(x,i,labels=FALSE): x라는 데이터를 i라는 구간에 따라 나눴을 떄의 각각의 결과
                              
aggregate(iris[,-5],list(iris$Species),median)
iris$Species
#iris[,-5]는 다섯 번째 열을 제외하고 data를 다루는 것!
#aggregate는 tapply와 다르게 여러 열에 동시에 적용 가능하다.
#formula공식을 쓸 수도 있음
aggregate(.~Species,iris,median)

x <- c(2,5,10,15,19,3,17,11,8,6)
y <- seq(0,20,by=2)             
cut(x,breaks=y,labels=FALSE)        #x를 대상으로 y의 cut대로 갔을 때의 결과(그리고 label어차피 없음) 
#cut을 쓸 때 label을 언급해주지 않으면 그냥 구간으로 출력됨됨
cut(x,breaks=y,include.lowest=F)    #include.lowest는 가장 왼쪽의 0을 넣고 안 넣고의 차이



iris
by(iris[,1:2],iris$Species,cor)
