function FFT_1(f)
[x,fs]=audioread(f,[1,2048]);            %��ȡ����
x1=reshape(x,1,2048);
% sound(x1,fs,bits);                           %���������ź�
y1=fft(x1);
N=length(x1);                             %������ȡ�źŵĵ���
t=(1:N)/fs;                                %�źŵ�ʱ�������
figure(1)
plot(t, x1);                                %���������������ʱ����
title('ԭ�����źŵ�ʱ����');               %��ͼ�μ�ע��ǩ˵��
xlabel('ʱ��/t');
ylabel('���/A');
grid ;                                    %�������

N=length(x);
M=log2(N);
if length(x1)<N 
    x1=[x1,zeros(1,N-length(x1))];            % ��x�ĳ��Ȳ���2���ݣ����㵽2�������� 
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
y=x1;                              % ��x����������Ϊy�ĳ�ʼֵ 
WN=exp(-1i.*2.*pi./N);                  %��������     
for L=1:M
    B=2^L/2;                       %��L���У�ÿ�����ε����������������B���㣬ÿ����B����ͬ����ת����
    for J=0:B-1                     % J�����˲�ͬ����ת����
        p=J*2^(M-L);   
        WNp=WN^p;
        for k=J+1:2^L:N             % ���ε�������Ŀ�Խ���Ϊ2^L
            kp=k+B;               % ����������������Ӷ�Ӧ��Ԫ�±�Ĺ�ϵ 
            t=y(kp)*WNp;           % ��������ĳ˻���   
            y(kp)=y(k)-t;            % �������㣬 ע������Ƚ��м������㣬Ȼ����мӷ����㣬����Ҫʹ���м����������y(k)
            y(k)=y(k)+t;             % ��������
        end 
    end 
end 
%y

figure(2)
[x2,w1]=freqz(x1,1) ;                  %����ԭʼ�����źŵ�Ƶ��ͼ
plot(w1/pi,20*log10(abs(x2)));
title('Ƶ������ͼ')
xlabel('��һ��Ƶ��');
ylabel('����/DB');
grid;      
figure(3)
subplot(2,1,1);                         %�ѻ�ͼ���򻮷�Ϊ2��1�У�ָ����1 ��ͼ
plot(abs(y1));                          %����ԭʼ�����źŵķ�Ƶ��Ӧͼ
title('ֱ������ �����ź�FFTƵ������');  %��ͼ�μ�ע��ǩ˵��
xlabel('n');
ylabel('��ֵ/A');
grid;                                  %�������

subplot(2,1,2);                          %�ѻ�ͼ���򻮷�Ϊ2��1�У�ָ����2��ͼ
plot(abs(y));
title('�������� �����ź�FFTƵ������');  
xlabel('n');
ylabel('��ֵ/A');
grid;                                  %�������

figure(4)
subplot(2,1,1)
if y~=0                                %�ж�ָ���Ƿ�Ϊ0
   plot(20*log10(abs(y1)));               %���ź�Ƶ�׵ķֱ�ͼ
end
xlabel('n');
ylabel('���/db');
title('ֱ������ �����ź�FFTƵ������');
grid ;                                  %�������







