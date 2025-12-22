##################################
####     통계소 연습장CH2     ####
##################################

##################################

#Vectors

letters   #소문자 소환!
LETTERS   #대문자 소환!

#every vector has two properties!!
typeof(letters)  #이게 어떤 종류인지(숫자형 (numeric), 문자형 (character)논리형 (logical: TRUE/FALSE)정수형 (integer), 복소수형 (complex) 등도 가능)
length(letters)  #길이가 어느 정도인지

#adding and deleting vector elements
x <- c(88,5,12,13)       #x하나 만들어주고
x <- c(x[1:3],168,x[4])  #x에서 1부터 3자리, 168이랑, 네번쨰 자리 것들 나열로 새로 정의
x

#obtaining the length of a vector
x <- c(1,2,4)
length(x)

#creating vectors in various types
x <- 7
is.vector(x)    #x가 벡터냐??! 이걸 묻는 질문

x <- c("a","b","c")
typeof(x)
is.vector(x)

#logical vectors
x <- c(1,2,3,4,5)
x>2

sum(x>2)  #2보다 큰 수 0+0+1+1+1의 개수를 sum 한다는 뜻
mean(x>2) #2보다 큰 수 0+0+1+1+1의 개수의 mean 구하기
any(x>3)  #any는 어느 하나라도 3보다 큰 게 있냐는 질문
all(x>3)  #all은 모든 것들이 3보다 크냐는 질문

x <- c(1,3,5)
y <- c(2,3,5)
x==y      #같냐는 질문은 '=='로 하는 것

x <- sqrt(3)^2    #sqrt(3)은 3에 루트를 씌운 것->부동소수점으로 저장됨
x==3
abs(x-3)<1e-10    #abs는 absolute를 의미해서 x와 3d차이가 0.000000001보다 작은지를 묻는 질문!!
dplyr::near(x,3)

install.packages("dplyr")
dplyr::near(x,3)

y <- c(1.2,3.9,0.4,0.12)
y[c(3,1,3)]       #vector indexing

x <- c(-1,0,1,2)
y[x>0]            #y중에서 세번째, 네번째 값 가지고 오면됨


#creating useful vectors
1:3                           #콜론으로 숫자 나열
seq(from=-2, to=3, by=0.5)    #seq으로 숫자 나열

#seq(from=,to=,by=)           #어디서부터 어디까지 어느 간격으로 나열할지를 결정
y <- c(1.2,3.9,0.4,0.12)
seq_along(y)                  #벡터에 인덱스를 부여하는 함수

x <- seq(-5,5,by=2)
x
seq(5,5,by=x)


#repeating vector
rep(3,5)                      #rep(이것을, 몇번 반복)
rep(c(1,3),5)
rep(c(1,3),each=5)            #each를 하면 각각을 몇번 반복함

#vector operations
#a vector is returned after the element-wise operation
x <- c(1,4,9)
x^3
sqrt(x)        #x각각에 square루트를 씌워주는 것

#NA: NOT AVAILABLE!! denotes the missing data, NA가 있으면 대부분 R funct가 안됨.
x <- c(10,20,NA,30,40)
length(x)           #길이까지는 되는듯
mean(x)             #NA가 있는 상태에서 계산은 안됨
mean(x,na.rm=TRUE)  #NA의 remove를 하는 방법

#NULL: 그냥 없는 것, length로도 카운트 안됨, 약간 무시 받는 존재
x <- c(10,20,NULL,30,40)
length(x)
sum(x)              #NULL은 NA와 다르게 그냥 기본적으로 무시되는 애라서 sum 가능
mean(x)


#workspace
x <- stats::runif(20)
y <- list(a=1,b=TRUE,c="oops") 
save(x,y,file="xy.RData")  #x,y두 객체를 하나의 파일로 저장한것. 
save.image()               #creating '.RData' in current working directory
  #image를 save한다는 건 “지금 메모리에 있는 모든 객체(x, y, 그 외 변수들 전부)를 현재 폴더에 저장하라는 뜻뜻


#####################################################
############   통계소 CH2 EXERCISE  #################
#####################################################


###PROBLEM1
scores <- c(88,72,90,59,100,83,77,95)
#1
?median
x <- scores[scores>median(scores)]
x
length(x)
length(x)/length(scores)

#2
?seq_along
scores[seq_along(scores)%%2==0]


#3
new <- c(scores[2:3],68,scores[4:length(scores)])
new

#나의 그지같은 풀이..
scores[3]=68
scores[1] <- NA
scores(rm.NA)

###PROBLEM2
x <- c(sqrt(2)^2,3,NA,4.0,sqrt(3)^2,9,NA,3.0000000001)
#1
new <- x[x-3<1e-10]
new

#2
x[x>3]
y <- x[x>3]
y
mean(y,na.rm=TRUE)

#3
any(x==3)
all(x>0,na.rm=TRUE)

#4
##예를 들어 
sqrt(3)^2==3
##의 경우만 봐도 기대와 다르다는 것을 알 수 있다. 이느.....
##부동소수점 연산 결과는 3과 정확히 같지 않을 수 있다. 해결방법은 허용오차를 활용하는 것이다.....

###PROBLEM3
students <- data.frame(
  name=c("Kim","Lee","Park","Choi","Jung","Han","Seo","Yoon"),
  math=c(88,72,90,59,100,83,77,95),
  english=c(92,85,87,70,99,80,78,88)
)
students

#1  
##나의 그지같은 답안
avg <- c(mean(students$math),mean(students$english))
avg

##찐답안
avg <- (students$math+students$english)/2
avg

#2#
overall_mean <- mean(avg)
overall_mean
students$name[avg>=overall_mean]

#3
any(students$math>80&students$english>80)

#4
all(students$english>60)

#5
?order

students$name[(order(avg,decreasing=FALSE))]
students$name <- students$name[order(avg,decreasing=FALSE)]
students$name      
name <- students$name
avg <- avg[order(avg,decreasing=TRUE)]
avg
students_order <- data.frame(name,avg)
students_order

?data.frame

