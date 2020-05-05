%短时傅里叶变换STFT
%依据FFT手动实现STFT
clear
clc
close all
Fs = 1000;            % Sampling frequency
T = 1/Fs;             % Sampling period
L = 1000;             % Length of signal
t = (0:L-1)*T;        % Time vector
S = 20*cos(100*2*pi*t)+40*cos(50*2*pi*t);%0.2-0.7*cos(2*pi*50*t+20/180*pi) + 0.2*cos(2*pi*100*t+70/180*pi) ;
figure
plot(t,S)
title('原始')
%% 所需参数
%主要包含:信号分割长度(默认分割8个窗口)，海明窗口，重叠率，N点采样
%默认设置：
% nsc=floor(L/4.5);%海明窗的长度
% nov=floor(nsc/2);%重叠率
% nff=max(256,2^nextpow2(nsc));%N点采样长度
%也可手动设置
nsc=100;%海明窗的长度,即每个窗口的长度
nov=0;%重叠率
nff=max(256,2^nextpow2(nsc));%N点采样长度
%% 手动实现STFT
h=hamming(nsc, 'periodic');%计算海明窗的数值，给窗口内的信号加权重
coln = 1+fix((L-nsc)/(nsc-nov));%信号被分成了多少个片段
%如果nfft为偶数，则S的行数为(nfft/2+1)，如果nfft为奇数，则行数为(nfft+1)/2
%因为matlab的FFT结果是对称的，只需要一半
rown=nff/2+1;
STFT_X=zeros(rown,coln);%初始化最终结果
%对每个片段进行fft变换
index=1;%当前片段第一个信号位置在原始信号中的索引
for i=1:coln
    %提取当前片段信号值,并用海明窗进行加权
    temp_S=S(index:index+nsc-1).*h';
    %进行N点FFT变换
    temp_X=fft(temp_S,nff);
    %取一半
    STFT_X(:,i)=temp_X(1:rown)';
    %将索引后移
    index=index+(nsc-nov);
end

%% matlab自带函数
[spec_X,spec_f,spec_t]=spectrogram(S,hamming(nsc, 'periodic'),nov,nff,Fs);
%减法，看看差距
figure
plot(abs(spec_X)-abs(STFT_X))
title('手撕与自带的结果误差')

figure
spectrogram(S,hamming(nsc, 'periodic'),nov,nff,Fs);
title('spectrogram函数画图')

%% 画频谱图
% 海明窗口的均值
K = sum(hamming(nsc, 'periodic'))/nsc;
%获取幅值(除以采样长度即可，后面再决定哪几个乘以2)，并依据窗口的海明系数缩放
STFT_X = abs(STFT_X)/nsc/K;
% correction of the DC & Nyquist component
if rem(nff, 2)                     % 如果是奇数，说明第一个是奈奎斯特点，只需对2:end的数据乘以2
    STFT_X(2:end, :) = STFT_X(2:end, :).*2;
else                                % 如果是偶数，说明首尾是奈奎斯特点，只需对2:end-1的数据乘以2
    STFT_X(2:end-1, :) = STFT_X(2:end-1, :).*2;
end

% convert amplitude spectrum to dB (min = -120 dB)
%将幅值转换成分贝有函数是ydb=mag2db(y)，这里直接算
STFT_X = 20*log10(STFT_X + 1e-6);
%时间轴
STFT_t=(nsc/2:(nsc-nov):nsc/2+(coln-1)*(nsc-nov))/Fs;
%频率轴
STFT_f=(0:rown-1)*Fs./nff;
% plot the spectrogram
figure
surf(STFT_f, STFT_t,  STFT_X')
shading interp
axis tight
box on
view(0, 90)
set(gca, 'FontName', 'Times New Roman', 'FontSize', 14)
xlabel('Frequency, Hz')
ylabel('Time, s')
title('Amplitude spectrogram of the signal')

handl = colorbar;
set(handl, 'FontName', 'Times New Roman', 'FontSize', 14)
ylabel(handl, 'Magnitude, dB')