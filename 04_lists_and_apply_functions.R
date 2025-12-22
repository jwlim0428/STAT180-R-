##################################
####     통계소 연습장CH4     ####
##################################

##################################

###LIST에 대해서 알아보자
#서로 다른 type의 object들을 묶어줄 수 있음
#list() 이렇게 하고 안에 data를 넣어주면됨
#vector(mode='list',length): 빈 리스트를 만드는 방법

#example
x <- list(name="Kim",salary=6000,union=FALSE)   #서로 다른 object여도 가능하자나
x

#extracting components from lists
x$salary
x$name
x[[2]]          #아니 이거 누가 봐도 자리로 시험낼 거 같음
x[['salary']]

x[2] 
#x[[2]]: 리스트의 내부값을 찾는 거[2]에 []하나가 더 있다고 생각해 salary의 값을 찾는 거
#x[2]: x의 리스트의 두 번째 대상인 salary!

x[1:2]

x <- list(a=1:2,b=c('a','b'))
x$c <- rep(3,5)      ##rep함수 복습
#repeating vector
rep(3,5)                      #rep(이것을, 몇번 반복)
rep(c(1,3),5)
rep(c(1,3),each=5)            #each를 하면 각각을 몇번 반복함

x

#이 리스트에 값 넣는게 되게 헷갈림

y <- list(1:2)         
c(y,list(c('a','b')))    #두 리스트를 combine한 것
#두개의 리스트가 출력되어 나오겠지 당연히


x[4] <- c(TRUE,FALSE,FALSE,TRUE)    #이렇게 적는 건 틀린 거지
x[[4]] <- c(TRUE,FALSE,FALSE,TRUE)  #네 번째 자리의 값 안에 넣는다는 의미이기 때문에 [[]]사용

x[[4]]
x[4]
x[5:6] <- c(7,3)     #다섯 번째 자리와 여섯번째 자리 각각에 따로 넣음
x

x$c <- NULL          #c부분에 있는 값을 다 없애고 하나씩 떙김
x

###list operations
#number of elements:length()
#names of components: names()
#세팅도 names() <- c() 이런 식으로 할 수 있음
#accessing values: use unlist()

?unlist

#####주의
c(y,list(c('a','b')))          #이건 벡터로 묶은 두 리스트들이고
x <- list(a=1:2,b=c('a','b'))  #이것 리스트로 묶은 두 벡터들


x <- list(a=1:2,b=c('a','b'))
x
length(x)
names(x)
unlist(x)     #list를 vector로 평평하게 만드는 역할 

###applying functions to lists
#lapply(list,function): applies a function to each component of a list, 결과물도 list
#sapply(list,function): " 리스트가 아니라 vector나 matrix가 결과물, 결과가 단순해짐

x <- list(a=1:10,b=c(5,8,1,7))
lapply(x,median)                #각각의 리스트에 median이라는 함수를 적용
sapply(x,median)                #결과가 리스트가 아니라 벡터로 나옴
#결과가 각 리스트 당 하나라면 벡터로 나오겠지
#두 개이상이면 그때 부터 행렬의 형태로 주고, 그보다 더 필요해지면 list도 활용할 수 있다.

lapply(x,range)    #range는 당연히 가장 작은 값부터 큰값까지를 의미
?range
sapply(x,range)    #이 경우에는 숫자가 두개 나오니까 행렬형태로...

#recursive lists   #재귀리스트는 리스트의 요소 중 하나이상이 또 리스트!!
x <- list(a=1:10,b=c(5,8,1,7))
y <- list(a=1:2,b=c('a','b'))
z <- list(x,y)
z

str(z)



#####################################################
############   통계소 CH4 EXERCISE  #################
#####################################################


##PROBLEM1
employees <- list(
  emp1=list(name="Kim",salary=6000,union=TRUE),
  emp2=list(name="Lee",salary=4500,union=FALSE),
  emp3=list(name="Park",salary=7000,union=TRUE)
)
#1#
employees$emp1$salary
employees$emp2$salary
employees$emp3$salary     #응 이렇게 구하는 거 아니야....
salaries <- sapply(employees,function(x) x$salary)
salaries
str(salaries)
typeof(salaries)

#2#
#평균급여보다 높은 급여를 받는 직원들의 이름만 출력
avg_salaries <- mean(salaries)
avg_salaries
salaries[salaries>avg_salaries]$name
high_salary_names <- sapply(employees[salaries>avg_salaries],function(x)x$name)
high_salary_names    #쉽지 않다...

#3#
sapply(employees)
union_members <- employees[sapply(employees,function(x) x$union)]  #[]에서 T/F를 인덱스로 인식하려고 하기 때문에 sapply를 써줘야함
union_members
##대괄호[] 안에 들어감 T,F는 그 밖으로 하여금 선택의 대상을 제공함


###PROBLEM2
x <- list(
  score=c(87,92,76,81,95),
  names=c("Kim","Lee","Choi","Park","Jung"),
  pass=c(TRUE,TRUE,FALSE,TRUE,TRUE)
)

#1
max(x$score)
min(x$score)
mean(x$score)

#2
x$names[x$pass]

#3
?paste
paste(x$names,x$score,sep=":")


###PROBLEM3
exam <- list(
  classA=list(scores=c(80,90,85),teacher="Kim"),
  classB=list(scores=c(70,88,95),teacher="Lee"),
  classC=list(scores=c(60,75,70),teacher="Park")
)

#1
?sapply
sapply(exam$classA$scores,mean)
### 이건 exam$classA$scores의 원소 각각각에 대한 mean을 구하기 때문에 결과가 제대로 나오지 않음

avg_scores <- sapply(exam,function(x) mean(x$scores))
#sapply는 각 요소에 대해 적용하는 함수 exam의 각각 classA,B,C에 적용
avg_scores       

#2
highest_class <-which.max(avg_scores)
typeof(highest_class)
exam$teacher[highest_class]###exam$teacher 사이에 또 list가 있으므로 $ 사용 불가


sapply(exam, function(x) x$teacher)[highest_class]    #class와 teacher 쭉 나열한 후 에 []로 위치 찾기

#3
exam$classA$avg <- mean(exam$classA$scores)
exam$classB$avg <- mean(exam$classB$scores)
exam$classC$avg <- mean(exam$classC$scores)
exam
