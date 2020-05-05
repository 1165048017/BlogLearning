%% 创建信号：设置两个函数相加
clear
clc
close all
Fs = 1000;            % Sampling frequency
T = 1/Fs;             % Sampling period
L = 1000;             % Length of signal
t = (0:L-1)*T;        % Time vector
S = 0.2-0.7*cos(2*pi*50*t+20/180*pi) + 0.2*cos(2*pi*100*t+70/180*pi) ;

%% DFT变换
%                    N
%      X(k) =       sum  x(n)*exp(-j*2*pi*(k-1)*(n-1)/N), 1 <= k <= N.
%                   n=1
DFT_X=zeros(1,L);
N=L;
for k=1:L
    for n=1:N
        DFT_X(k)=DFT_X(k)+S(n)*exp(-1j*2*pi*(k-1)*(n-1)/N);
    end
end
P2=abs(DFT_X/L);
P1 = 2*P2(1:L/2+1);
f = Fs*(0:(L/2))/L;
figure
plot(f,P1)
xlabel('频率')
ylabel('振幅')
title('DFT变换')
%% IDFT变换
%                    N
%      x(n) = (1/N) sum  X(k)*exp( j*2*pi*(k-1)*(n-1)/N), 1 <= n <= N.
%                   k=1
DFT_rec_x=zeros(1,k);
for n=1:L
    for k=1:L
        DFT_rec_x(n)=DFT_rec_x(n)+DFT_X(k)*exp( 1j*2*pi*(k-1)*(n-1)/N);
    end
end
DFT_rec_x=DFT_rec_x./N;
rec_err=real(DFT_rec_x)-S;
figure
plot(rec_err)
title('IDFT数据重构误差')
%% FFT变换
FFT_X=fft(S);
figure
plot(abs(FFT_X-DFT_X))
title('DFT和FFT误差')
%% IFFT变换
FFT_rec_x=ifft(FFT_X);
figure
plot(abs(DFT_rec_x-FFT_rec_x))
title('IDFT和IFFT误差')