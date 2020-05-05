%% �����źţ����������������
clear
clc
close all
Fs = 1000;            % Sampling frequency
T = 1/Fs;             % Sampling period
L = 1000;             % Length of signal
t = (0:L-1)*T;        % Time vector
S = 0.2-0.7*cos(2*pi*50*t+20/180*pi) + 0.2*cos(2*pi*100*t+70/180*pi) ;
plot(1000*t(1:50),S(1:50))
title('�����ź�ͼ')
xlabel('t (milliseconds)')
ylabel('S(t)')
%% ѧϰmatlab�Դ���FFT��IFFT
% FFT
Y = fft(S);
P2 = abs(Y/L);
P1 = P2(1:L/2+1);
P1(2:end-1) = 2*P1(2:end-1);
f = Fs*(0:(L/2))/L;
% ��ͼ
figure
plot(f,P1,'linewidth',2)
title('FFT�任')
xlabel('Ƶ��(Hz)')
ylabel('��ֵ')
% IFFT
pred_X=ifft(Y);
figure
plot(pred_X,'r-')
hold on
plot(S,'b*')