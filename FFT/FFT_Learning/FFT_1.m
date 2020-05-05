function FFT_1(f)
[x,fs]=audioread(f,[1,2048]);            %读取声音
x1=reshape(x,1,2048);
% sound(x1,fs,bits);                           %播放语音信号
y1=fft(x1);
N=length(x1);                             %计数读取信号的点数
t=(1:N)/fs;                                %信号的时域采样点
figure(1)
plot(t, x1);                                %画出声音采样后的时域波形
title('原声音信号的时域波形');               %给图形加注标签说明
xlabel('时间/t');
ylabel('振幅/A');
grid ;                                    %添加网格

N=length(x);
M=log2(N);
if length(x1)<N 
    x1=[x1,zeros(1,N-length(x1))];            % 若x的长度不是2的幂，补零到2的整数幂 
end 
NV2=N/2;
NM1=N-1;
I=0;
J=0;
while I<NM1
    if I<J
        T=x1(J+1);
        x1(J+1)=x1(I+1);
        x1(I+1)=T;
    end
    K=NV2; 
    while K<=J
J=J-K;
        K=K/2;
    end
    J=J+K;
    I=I+1;
end               
%x1; 
y=x1;                              % 将x倒序排列作为y的初始值 
WN=exp(-1i.*2.*pi./N);                  %蝶形运算     
for L=1:M
    B=2^L/2;                       %第L级中，每个蝶形的两个输入数据相距B个点，每级有B个不同的旋转因子
    for J=0:B-1                     % J代表了不同的旋转因子
        p=J*2^(M-L);   
        WNp=WN^p;
        for k=J+1:2^L:N             % 本次蝶形运算的跨越间隔为2^L
            kp=k+B;               % 蝶形运算的两个因子对应单元下标的关系 
            t=y(kp)*WNp;           % 蝶形运算的乘积项   
            y(kp)=y(k)-t;            % 蝶形运算， 注意必须先进行减法运算，然后进行加法运算，否则要使用中间变量来传递y(k)
            y(k)=y(k)+t;             % 蝶形运算
        end 
    end 
end 
%y

figure(2)
[x2,w1]=freqz(x1,1) ;                  %绘制原始语音信号的频率图
plot(w1/pi,20*log10(abs(x2)));
title('频率特性图')
xlabel('归一化频率');
ylabel('幅度/DB');
grid;      
figure(3)
subplot(2,1,1);                         %把画图区域划分为2行1列，指定第1 个图
plot(abs(y1));                          %绘制原始语音信号的幅频响应图
title('直接运算 语音信号FFT频谱特性');  %给图形加注标签说明
xlabel('n');
ylabel('幅值/A');
grid;                                  %添加网格

subplot(2,1,2);                          %把画图区域划分为2行1列，指定第2个图
plot(abs(y));
title('蝶形运算 语音信号FFT频谱特性');  
xlabel('n');
ylabel('幅值/A');
grid;                                  %添加网格

figure(4)
subplot(2,1,1)
if y~=0                                %判断指数是否为0
   plot(20*log10(abs(y1)));               %画信号频谱的分贝图
end
xlabel('n');
ylabel('振幅/db');
title('直接运算 语音信号FFT频谱特性');
grid ;                                  %添加网格







