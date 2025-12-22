##################################
####     통계소 연습장CH3     ####
##################################

##################################

###MATRIX란 무엇인가
#a vector with two additional attributes(row&column)

###ARRAY란 무엇인가
#a vector with three or more dimensions
#extension of matrices
#vector operations work
#2차원은 array이긴 하지만 보통 matrix라고 부름, 3차원 이상이 주로 array라고 불리는 것

#creating matrices
matrix(nrow=2,ncol=3)
x <- 1:12
matrix(x,3,4)             #기본 전제가 byrow=FALSE임을 알아야 새로로 채워지는 것 알지
matrix(x,3,4,byrow=TRUE)  #이렇게 하면 당근 가로로먼저 채워져

#dimension of a matrix
#length(): matrix에 있는 전체 숫자들의 개수
#dim(): matrix든 array든 둘다 구할 수 있음, 각 dimension의 원소가 몇 개인지 알려줌
#nrow, ncol: row가 몇개고, col이 몇개인지 알려줌

#examples
A <- matrix(1:6,2,3)
length(A)
dim(A)
nrow(A)
ncol(A)

?dim
###Matrix Operations
#Element-wise operations(원소 별로 계산되는 것들): +,-,*,/,^,sqrt(),log(),exp() 등은 동일하게 적용
##Matrix-specific operations(matrix여서 적용되는 다른 함수들?)
#%*%:matrix multiplication(*는 element-wise여서 구분되는 것 주의)
#solve(A): A의 inverse matrix를 구함(당연히 A는 square matrix전제)
#solve(A,b): Ax=b라는 linear system을 풀어냄]
#eigen(): Eigenvalues and eigenvectors (고유벡터를 보여준다고 생각각)
#t(): transpose구하는 거지

#examples
A <- matrix(1:4,2,2)
A

B <- matrix(2:5,2,2)
B
 
A*B    #각각의 원소들을 곱한다는 것 알 수 있음
A%*%B  #실제 matrix로서 곱하는 것
t(A)   #A의 tranpose
eig_A <- eigen(A)
eig_A$values
eig_A$vectors       #솔직히 eigen은 봐도봐도 모르겠으니 그냥 외우는게...

#filtering: 특정 조건을 만족하는 부분을 추출하는 것
A <- matrix(1:20,4,5)
A
A>7
A[,A[2,]>7]    #모든 행 오케이, 2행 중에서 아무 열 7보다 크게 되는 모든 행 추출
               #이런거 차근차근 해석하는 연습
A[A[,3]>=10&A[,3]<=11,1:2]
# 3열중에서 10~11 애들의 열의 행의의 전체 중에서 1~2열만뽑기기
A[,3]>=10&A[,3]<=11   #이건 값이 []밖에 logical 판단을 하니T/F의 결과로 나와야함  

x <- c(5,4,7,12)
x%%2==1
A[x%%2==1,]        #matrix지칭시 안에 계산값을 넣을 수도 있음
A[which(x%%2==1),] #which함수가 위치를 보여주는 거


###APPLY function
#형식?? apply(데이터 X, margin(차원,방향), function(함수)...)

#example
A <- matrix(c(1:3,9,7,8,7,1:8),3,5) 
A
apply(A,2,sum)           #A의 데이터를 2차원에서(열들을) 모두 더하는 함수
apply(A,1,mean,trim=0.2) #A의 데이터를 1차원에서(행들을) 평균을 구하고   
                         #trim함수는 상하 20를 잘라내고 평균을 구하는 함수,,,(FUN다음에 추가적으로 딸려오는애)
A[1,1] <- NA
apply(A,2,sum)    #이젠 1열에 NA값이 생겼으니 1열은 NA로 나올 수밖에
apply(A,2,sum,na.rm=TRUE)   #NA배제

###RBIND AND CBIND
#rbind(): row로 묶겠지
#cbind(): col로 묶겠지

x <- c(1,5,2)
x
y <- matrix(1:6,2,3)
rbind(x,y)
z <- c(1,5)
cbind(y,z)      #이런건 그냥 가시적으로 기억하자 rbind는 가로로 떄려넣기, cbind는 세로로

#matrix to vector
A <- matrix(1:6,2,3)
A
is.vector(A)
x <- A[1,]      #전제가 drop=TRUE이므로 vector로 나오겠지
is.vector(x)    #matrix는 2차원, vector는 1차원이지만 matrix의 row만/col만 뽑으면 1차원화

A[1,]             #1행만 선택 후 냅두면 전제 drop=TRUE로 알아서 vector가 됨
A[1,,drop=FALSE]  #1행만 선택해도 drop가 false면 vector로 drop시키지 않고 행렬형태 유지함


#transformation into vector or matrix
#as.vector(): matrix나 array를 vector로 만들어줌
#as.matrix(): vector나 array를 matrix로 만들어줌

x <- as.matrix(x)   #아까 drop시켜 놓은 거 다시 byrow=FALSE 전제로 matrix로 전환함
x
as.vector(x)        #다시 또 vector....왜 계속 이짓거리...

#name of matrix rows and columns
#rownames(): matrix row들의 이름을 붙여줌
#colnames(): col의 이름들을 붙여줌줌

A <- matrix(1:6,2,3)
rownames(A) <- c("K","J")
colnames(A) <- LETTERS[1:3]    #LETTER라는 거 자체가 대문자를 소화하는 애
A


#수많은 과정을 거쳐, 오차제곱합이 최소가 되도록하는 b_hat은 다음과 같은 공식으로 구함
#{t(X)X}-1 t(X)y

#computing in R
y <- c(1,3,3,2)
x1 <- c(1,2,3,4)
X <- cbind(1,x1)
X

XtX <- t(X)%*%X  
Xty <- t(X)%*%y
beta_hat <- solve(XtX)%*%Xty
beta_hat
#결과값은 회귀계수임!!



#####################################################
############   통계소 CH3 EXERCISE  #################
#####################################################

###PROBLEM1
A <- matrix(c(4,1,2,
              1,3,0,
              2,0,2),nrow=3,byrow=FALSE)
#1
eigen_A <- eigen(A)
ceigen_A
?eigen

P <- eigen_A$vectors
D <- diag(eigen_A$values)
  
?matrix

#2#
#PDP가 도대체 뭐지? 아 문제에 나와잇슴...
#D는 어떻게 구하는 것인가.......
A==P%*%D%*%solve(P)               ###같냐고 물어보기 위해서는 다른 방법 필요
reconstructed <- P%*%D%*%solve(P) 
all.equal(A, A_reconstructed)     ###all.equal이라는 함수도 존재하나봄....

#3
P%*%D%*%D%*%D%*%D%*%D%*%solve(P)

###이거 다른 방법으로 구해야돼!


##PROBLEM2
set.seed(123)
M <- matrix(sample(1:50,36,replace=TRUE),nrow=6)
M

#1
overall_mean <- mean(M)
row_means <- rowMeans(M)   #아니면 apply함수도 쓸 수 있잖아
apply(M,2,mean)
M_selected<- M[row_means>overall_mean,]   #그런 조건을 만족하는 '행'을 뽑으라했으니 조건이 행에 걸림!!
M_selected

#2
col_sums <- apply(M_selected,2,sum)
col_sd <- apply(M_selected,2,sd)
col_sums
col_sd

###PROBLEM3
A <- array(1:24,dim=c(3,4,2))
A
#1
B <- array(1:36,dim=c(3,3,4))
B

#2
row_sums <- apply(B,3,rowSums)
row_sums

#3
max_row_sum <- which.max(apply(B,3,sum))
B[,,max_row_sum]
