# 분포의 그래프 그리기


# 정규분포의 pdf 그리기
# dnorm 은 그 지점의 pdf 값을 나타나기 떄문에 그냥 curve 로 그리면된다.
curve(dnorm(x),from=-3 , to=3)


# 정규분포의 cdf 그리기
# pnorm 은 cdf 를 알려주기 때문에 적절
curve(pnorm(x,mean=10,sd=2),from=4,to=16)
