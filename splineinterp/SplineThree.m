function f = SplineThree(x,y,dy1,dyn,x0)
%x，y为输入的已知点
%x0为待求插值点的横坐标
%dy1,dyn为约束条件，是端点处的一阶导数值
n=length(x);
for j=1:n-1
    h(j)=x(j+1)-x(j);
end

%得到式子右边的结果矩阵
d(1,1)=6*((y(2)-y(1))/h(1)-dy1)/h(1);   %等式(11)的结果矩阵的上端点值
d(n,1)=6*(dyn-(y(n)-y(n-1))/h(n-1))/h(n-1); %等式(11)的结果矩阵的下端点值
for i=2:n-1
    u(i)=h(i-1)/(h(i-1)+h(i));
    d(i,1)=6*((y(i+1)-y(i))/h(i)-(y(i)-y(i-1))/h(i-1))/(h(i-1)+h(i));
end

%得到系数矩阵
A(1,1)=2;
A(1,2)=1;
A(n,n-1)=1;
A(n,n)=2;
for i=2:n-1
    A(i,i-1)=u(i);
    A(i,i)=2;
    A(i,i+1)=1-u(i);
end

%解方程
M=A\d;

format long
syms t;
%得到每个区间的式子
for i=1:n-1
   a(i)=y(i+1)-M(i+1)*h(i)^2/6-((y(i+1)-y(i))/h(i)-(M(i+1)-M(i))*h(i)/6)*x(i+1);
   b(i)=((y(i+1)-y(i))/h(i)-(M(i+1)-M(i))*h(i)/6)*t;
   c(i)=(t-x(i))^3*M(i+1)/(6*h(i));
   e(i)=(x(i+1)-t)^3*M(i)/(6*h(i));
   f(i)=a(i)+b(i)+c(i)+e(i);
    %f(i)=M(i)*(x(i+1)-t)^3/(6*h(i))+M(i+1)*(t-x(i))^3/(6*h(i))+(y(i)-M(i)*h(i)^2/6)*(x(i+1)-t)/h(i)+(y(i+1)-x(i+1)*h(i)^2/6)*(t-x(i))/h(i);
    % f(i)=((x(j+1)-x)^3)*M(i)/(6*h(i))+((x-x(i))^3)*M(i+1)/(6*h(i))+(y(i)-M(i)*(h(i)^2)/6)*((x(i+1)-x)/h(i))+(y(i+1)-(M(i+1)*(h(i)^2)/6))*((x-x(i))/h(i));
end

%化简
 f=collect(f);
 f=vpa(f,6);

 
if(nargin==5)
   nn=length(x0);
for i=1:nn
    for j=1:n-1
        if(x0(i)>=x(j)&x0(i)<=x(j+1))
             yynum(i)=subs(f(j),'t',x0(i));   %计算插值点的函数值.subs是替换函数，把x0用t替换
        end
    end
end   
f=yynum;
else
    f=collect(f);          %将插值多项式展开
    f=vpa(f,6);            %将插值多项式的系数化成6位精度的小数
end
end