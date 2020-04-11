clear
clc
close all
a=[8 9 1 9 6 1 3 5]';
b=[2 5 4 6 7 8 3 7 7 2]';
[Dist,D,k,w,rw,tw] = dtw(a,b,1);
fprintf('最短距离为%d\n',Dist)
fprintf('最优路径为')
w