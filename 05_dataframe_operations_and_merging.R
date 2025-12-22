##################################
####     통계소 연습장CH5     ####
##################################

##################################

###DATAFRAME
#a data frame is simiar to a matrix, but each colum may have a different mode
#dataframe은 결국 list, 같은 길이의 vector를 가진 list들을 묶은 것. 
#stringsasFactors=F가 디폴트 값. 문자열에서 데이터를 자동으로 factor(범주)로 간주할 지 결정함
#요즘은 F가 디폴트

#example
name <- c('Kim','Park','Lee')
age <- c(25,23,21)
male <- c(T,F,T)
x <- data.frame(name,age,male,stringsAsFactors = F)
x

#str(): 데이터의 구조(structure)를 보여주는 함수
str(x)
y <- data.frame(name,age,male)
str(y)


##DATAFRAME ACCESSING
y[2]
y[[2]]  #이건 second column을 vector로 뽑아냄(약간 리스트 두 번째 꺼의 값들을 뽑는다고 생각해도됨)

y[2:3]
y$age
y[,2]


##OPERATIONS OF DATAFRAMES
x <- data.frame(x1=c(6,3,6,3,8),
                x2=1:5,
                x3=7:11)
#class(): 자료형이 뭔지 알려줌
x
x[1:3,]
class(x[1:3,])      
x[1:3,1]
class(x[1:3,1])
x[1:3,1,drop=FALSE]
class(x[1:3,1,drop=FALSE])
x[x$x1>=5,]                #x1의 값 중에서 5이상인 것들만 row로 뽑기
x[x[,1]>=5,]               #첫 번째 col중에서 5보다 큰 것에 해당하는 row


##REMOVING NAS
x <- data.frame(x1=c(6,3,NA,3,NA),
                x2=1:5,
                x3=7:11)
x
complete.cases(x)

x[complete.cases(x),]      #이러면 complete.case가 아닌, NA가 있는 애들 빼고 row들이 추출됨
na.omit(x)                 #저 complete.case와 동일한 결과가 나오도록 하는 함수. 말그대로 그 열을 omit시키는 역할

##ADDING OBSERVATIONS
#dataframe에 있는 각 열들의 모든 element들이 같은 mode(자료의 형태)같아야
#당연히 이름도 동일해야 합칠 수 있지 않겠나.....


x <- seq(-5,5,by=1)
x

y <- seq(-5,-5,10)
y


df_1 <- data.frame(name=c('Kim','Choi','Park','Lee'),
                   age=c(22,37,44,25))
df_2 <- data.frame(age=c(28,33),
                   name=c('Seo','Hwang'))             #name age 순서 정도는 바뀌어도 결과 나올 수 있다!
rbind(df_1,df_2)

df_1 <- data.frame(name=c('Kim','Choi','Park','Lee'),
                   age=c(22,37,44,25), stringsAsFactors = F) #애초에 각각을 factor취급하지 않기 때문에 합쳐질 수 있는 것
df_2 <- data.frame(age=c(28,33),
                   name=c('Seo','Hwang'))             #name age 순서 정도는 바뀌어도 결과 나올 수 있다!
rbind(df_1,df_2)


d1 <- data.frame(x1=c(1,4,3),x2=1:3)
d2 <- matrix(0,2,2)
colnames(d2) <- c('x1','x2')        #이전과는 다르게 d1과 같이 x1, x2로 지정했기 때문에 rbind도 가능한것
d3 <- rbind(d1,d2)  
class(d3)
d3

##ADDING VARIABLES
d <- data.frame(x1=c(1,4,3),x2=1:3)
cbind(d, matrix(1,nrow=3,ncol=2))
cbind(d,d$x1-d$x2)  #연산도 가능
d
d$dif <- d$x1-d$x2  #bind를 한 다음에 이름을 바꾸는 거ㅈ
d

d[[4]] <-1:3        #[4] column의 내용물에 1:3을 추가하는 것
d
d[4] <- 4:6
d
d[5:6] <- matrix(1,3,2)   


##MERGING DATAFRAMES
#merge(): combines two data frames according to the values of a comomon variable
#merge(...,all=F)
#merge(...,all=T)
#merge(...,all.x=T)
#merge(...,all.y=T)
d1 <- data.frame(name=c('Kim','Choi','Park'),age=c(22,27,24))
d2 <- data.frame(Sex=c("M","F","M"),
                 name=c('Park','Kim','Kang'))
merge(d1,d2,by='name')        #공통점이 name뿐... merge의 기본값이 NA없이 겹치는 것만 넣는 건가봄
merge(d1,d2,by='name',all=T)  #이렇게 하면 NA가 나오더라도 일단 있는 건 다 묶음
merge(d1,d2,by='name',all.x=T)#이건 먼저 있는 사람들의 대상에 대해서만 다 묶어줌줌
merge(d1,d2,by='name',all.y=T)


#MERGING WITH KEY STORED IN DIFFERENT NAMES
#여기에서 하나는 name으로 저장되고 하나는 last로 저장된 게 문제!!
#자꾸 x와 y가 사용되는 건 합치고픈 데이터프레임 1,2를 그렇게 지칭하려고 하는게 고정!!
d1 <- data.frame(name=c('Kim','Choi','Park'),age=c(22,27,24))
d2 <- data.frame(Sex=c("M","F","M"),
                 last=c('Park','Kim','Kang'))
merge(d1,d2,by.x='name',by.y='last')      #NA를 만들지 않는 선에서 겹치는 애들만 등장장

##APPLYING FUNCTIONS
#apply(): applies a function to each row or column of a dataframe, returning a vector or matrix
#lapply(): list를 반환함
#sapply(): lapply와 비슷하지만 vector나 matrix를 간단히 함. 

d <- data.frame(x1=2:5,x2=6:9,x3=c(5,8,1,5))
apply(d,1,mean)  #아마 행들의 평균을 구하지 않을까...
apply(d,2,mean)  #열들의 평균을 구할
d <- data.frame(name=c('Kim','Choi','Park'),
                age=c(22,27,24),
                stringsAsFactors=F)
apply(d,2,sort)  #열들이 sort하기 바람(sort함수는 오름차순으로 정렬하는 것)
lapply(d,sort)   #list 형식으로 나옴
as.data.frame(x) #dataframe이 아닌 것도 그렇게 바꿔줌
a <- matrix(0,2,2)
x <- as.data.frame(a)   #이건 matrix를 dataframe으로 바꿔줌
is.data.frame(x)        #이렇게 바꿨는데, dataframe이 맞냐???
