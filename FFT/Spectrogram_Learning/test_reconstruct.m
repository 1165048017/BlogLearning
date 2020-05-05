%% 基于频谱图还原信号
%% 原始心好
clear
clc
close all
% Fs = 1000;            % Sampling frequency
% T = 1/Fs;             % Sampling period
% L = 1000;             % Length of signal
% t = (0:L-1)*T;        % Time vector
% S = 20*cos(100*2*pi*t)+40*cos(50*2*pi*t);%0.2-0.7*cos(2*pi*50*t+20/180*pi) + 0.2*cos(2*pi*100*t+70/180*pi) ;

[S, Fs] = audioread('track.wav'); 
S = S(:,1)';
T = 1/Fs;             % Sampling period
L = size(S,1);             % Length of signal
t = (0:L-1)*T;        % Time vector

figure
plot(t,S)
title('原始信号')

%% matlab自带转换频谱图的函数
nsc=100;%海明窗的长度,即每个窗口的长度
nov=0;%重叠率
nff=max(256,2^nextpow2(nsc));%N点采样长度
h=hamming(nsc, 'periodic');%计算海明窗的数值，给窗口内的信号加权重
[spec_X,spec_f,spec_t]=spectrogram(S,h,nov,nff,Fs);

coln = size(spec_X,2); % 总共被分解成了多少个片段

%% 还原信号
%对每个片段进行ifft变换
index=1;%当前片段第一个信号位置在原始信号中的索引
rec_S=zeros(1,size(S,2));
for i=1:coln
    temp_S = real(ifft(spec_X(:,i),nff));
    rec_S(index:index+nsc-1) = temp_S(1:nsc)./h *2;
    index=index+(nsc-nov);
end

figure
plot(rec_S-S)
title('误差')