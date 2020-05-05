%��ʱ����Ҷ�任STFT
%����FFT�ֶ�ʵ��STFT
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
title('ԭʼ')
%% �������
%��Ҫ����:�źŷָ��(Ĭ�Ϸָ�8������)���������ڣ��ص��ʣ�N�����
%Ĭ�����ã�
% nsc=floor(L/4.5);%�������ĳ���
% nov=floor(nsc/2);%�ص���
% nff=max(256,2^nextpow2(nsc));%N���������
%Ҳ���ֶ�����
nsc=100;%�������ĳ���,��ÿ�����ڵĳ���
nov=0;%�ص���
nff=max(256,2^nextpow2(nsc));%N���������
%% �ֶ�ʵ��STFT
h=hamming(nsc, 'periodic');%���㺣��������ֵ���������ڵ��źż�Ȩ��
coln = 1+fix((L-nsc)/(nsc-nov));%�źű��ֳ��˶��ٸ�Ƭ��
%���nfftΪż������S������Ϊ(nfft/2+1)�����nfftΪ������������Ϊ(nfft+1)/2
%��Ϊmatlab��FFT����ǶԳƵģ�ֻ��Ҫһ��
rown=nff/2+1;
STFT_X=zeros(rown,coln);%��ʼ�����ս��
%��ÿ��Ƭ�ν���fft�任
index=1;%��ǰƬ�ε�һ���ź�λ����ԭʼ�ź��е�����
for i=1:coln
    %��ȡ��ǰƬ���ź�ֵ,���ú��������м�Ȩ
    temp_S=S(index:index+nsc-1).*h';
    %����N��FFT�任
    temp_X=fft(temp_S,nff);
    %ȡһ��
    STFT_X(:,i)=temp_X(1:rown)';
    %����������
    index=index+(nsc-nov);
end

%% matlab�Դ�����
[spec_X,spec_f,spec_t]=spectrogram(S,hamming(nsc, 'periodic'),nov,nff,Fs);
%�������������
figure
plot(abs(spec_X)-abs(STFT_X))
title('��˺���Դ��Ľ�����')

figure
spectrogram(S,hamming(nsc, 'periodic'),nov,nff,Fs);
title('spectrogram������ͼ')

%% ��Ƶ��ͼ
% �������ڵľ�ֵ
K = sum(hamming(nsc, 'periodic'))/nsc;
%��ȡ��ֵ(���Բ������ȼ��ɣ������پ����ļ�������2)�������ݴ��ڵĺ���ϵ������
STFT_X = abs(STFT_X)/nsc/K;
% correction of the DC & Nyquist component
if rem(nff, 2)                     % �����������˵����һ�����ο�˹�ص㣬ֻ���2:end�����ݳ���2
    STFT_X(2:end, :) = STFT_X(2:end, :).*2;
else                                % �����ż����˵����β���ο�˹�ص㣬ֻ���2:end-1�����ݳ���2
    STFT_X(2:end-1, :) = STFT_X(2:end-1, :).*2;
end

% convert amplitude spectrum to dB (min = -120 dB)
%����ֵת���ɷֱ��к�����ydb=mag2db(y)������ֱ����
STFT_X = 20*log10(STFT_X + 1e-6);
%ʱ����
STFT_t=(nsc/2:(nsc-nov):nsc/2+(coln-1)*(nsc-nov))/Fs;
%Ƶ����
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