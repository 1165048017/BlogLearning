%% ����Ƶ��ͼ��ԭ�ź�
%% ԭʼ�ĺ�
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
title('ԭʼ�ź�')

%% matlab�Դ�ת��Ƶ��ͼ�ĺ���
nsc=100;%�������ĳ���,��ÿ�����ڵĳ���
nov=0;%�ص���
nff=max(256,2^nextpow2(nsc));%N���������
h=hamming(nsc, 'periodic');%���㺣��������ֵ���������ڵ��źż�Ȩ��
[spec_X,spec_f,spec_t]=spectrogram(S,h,nov,nff,Fs);

coln = size(spec_X,2); % �ܹ����ֽ���˶��ٸ�Ƭ��

%% ��ԭ�ź�
%��ÿ��Ƭ�ν���ifft�任
index=1;%��ǰƬ�ε�һ���ź�λ����ԭʼ�ź��е�����
rec_S=zeros(1,size(S,2));
for i=1:coln
    temp_S = real(ifft(spec_X(:,i),nff));
    rec_S(index:index+nsc-1) = temp_S(1:nsc)./h *2;
    index=index+(nsc-nov);
end

figure
plot(rec_S-S)
title('���')