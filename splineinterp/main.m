%先生成样本点(x,y)序列
X=0:2*pi;
Y=sin(X);
xx=0:0.2:6;%需要被插值的点
%% 人工实现部分
dy1=1;%定义端点1的一阶导
dyn=1;%定义端点n的一阶导
yy=SplineThree(X,Y,dy1,dyn,xx); %计算

%% matlab自带函数
yy_new = spline(X,Y,xx);

%% 画图
plot(xx,yy,'r')%画图
hold on 
plot(xx,yy_new,'g')
plot(xx,yy,'ro')%画图
plot(xx,yy_new,'go')
hold off
legend('实现','自带')