##################################
####     통계소 연습장CH1     ####
##################################

##################################

x <- 3
y <- 5
z <- x+y
x+y
z

ch <- "Hello World!"    #character string
#"" tells R that it is text

x <- c(1,3,5,6)   #벡터들을 combine한다는 의미
x+0.2


#access to elements using []
x[1]  #첫번째 꺼!
x[3]  #세번째(자리에 있는)
c     #'c'라는 함수는 이미 combine이라는 함수로 예약되어있으므로 함부로 쓰면 안됨!!
?q    #q는 quit로 사용되므로 이미 사용되는 함수, 건들X


#finding help in R
?c


#how to create a matrix

mat_items <- c(1,2,3,4)    #여러 값의 벡터를 하나로 combine
matrix(mat_items,nrow=2)   #(data,nrow,ncol,byrow=FALSE...)

A <- matrix(mat_items,nrow=2)
A
A[1,1]
A[1,]
A[,2]


#Reading data
wine <- read.csv('C:/Users/jwlim/OneDrive/Desktop/1-2/통계소/winequality-red.csv')
wine
head(wine)    #'head'니까, 앞의 6행까지만??? 보여준다는 기본 약속
setwd("C:/Users/jwlim/OneDrive/Desktop/1-2/통계소")  #working directory로 설정
setwd('C:/Users/jwlim/OneDrive/Desktop/1-2/통계소')  #working directory를 설정하면 그 폴더 안에서만 작동


##Paths in R
./file.csv   #current directory 의미, setwd가 미리 되어있어야 
../file.csv  #one level above
/file.csv    #it is in a subfolder


#Dataframes
data.frame(index=c(1,2,3),ch=c("A","B","C"))  #형식 기억, each columnn으로 들어감. 


#Accessing data from a data frame
wine[1,]       #access a certain row
wine$quality   #access a specific column using $
names(wine)    #has an atribute called names(colnames)
colnames(wine)
?names
?colnames

#Revisiting matrix
vec_mix <- c("A",1,3,"B") #원래 안되지만 "1"은 문자 취급되므로 All 문자됨
vec_num <- c(1,2,3)
vec_ch <- c("A","B","C")
rbind(vec_num,vec_ch)     #rbind? row bind이므로 모두 row로 묶어줌!
data.frame(index=vec_num,ch=vec_ch)


#TIDY VS MESSY


#

