##################################
####     통계소 연습장CH7     ####
##################################

##################################

###FUNCTION
#built-in도 있고, user-defined도 존재


average<- function(x){
  value <- sum(x)/length(x)
  value
}
x <- c(3,6,2,7,7)
average(x)

#R에서는 last evaluated expression 만 출력되므로 return()이라는 함수를 다시 써줘야함.
average <- function(x){
  return(sum(x)/length(x))
}

###FOR LOOP
#for (k in x) {
    #do something
}
# x 가 data file 이름을 갖는다면 iterativaly read each file가능

#iterates over the elements in x(처음에는 k <- x[1], 다음엔 k <- x[2]...순서로 감)
#total iterations equal to length()
#useful when needed to use each element of x in statement
#break: early termination
#next: skip the current iteration

##WHILE LOOP
#while(condition){
   #do something
}

#condition이 TRUE이기만 하다면, 계속 repeat, break로 일찍 깨고 들어갈 수 있음

##REPEAT LOOP
#repeat{
   #do something
   #반드시 break를 써서 빠져나와야함
}

#loops examples
#1: 
x <- c(5,6,10,7,12)
z <- NULL
for (k in x){
  z <- c(z,k+3)       #비어 있는 z벡터에 k+3을 한 애들을 combine하는 함수
}
z

#2: for loop with break
z <- NULL
for(k in x){
  z <- c(z,k+3)
  if (k>=10) break
}
z                      #마지막 10까지는 돌리고 break

#3: for loop with next
z <- NULL
for (k in x){
  if (k>=10) next
  z <- c(z,k+3)
}
z

#4: while loop
x <- 0
while(x<5){
  x <- x+1
}
x

#5: while loop with break
x <- 0
while(x<5){
  x <- x+1
  if(x>3) break
}
x

#6: repeat loop
x <- 0
repeat{
  x <- x+1
  if(x>=5) break  
}
x


## x 가 data file 이름을 갖는다면 iterativaly read each file가능
getwd()
setwd("C:/Users/jwlim/OneDrive/Desktop/1-2/통계소/review of CH7")
x <- c('dat1.txt','dat')
z <- rep(NA,length(x))
z
for(k in seq_along(x))

