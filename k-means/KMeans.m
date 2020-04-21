%N������һ���ֶ�����
%data������Ĳ��������ŵ�����
%u��ÿһ�������
%re�Ƿ��صĴ������ŵ�����
function [u re]=KMeans(data,N)   
    [m n]=size(data);   %m�����ݸ�����n������ά��
    ma=zeros(n);        %ÿһά������
    mi=zeros(n);        %ÿһά��С����
    u=zeros(N,n);       %�����ʼ�������յ�����ÿһ�������λ��
    for i=1:n
       ma(i)=max(data(:,i));    %ÿһά������
       mi(i)=min(data(:,i));    %ÿһά��С����
       for j=1:N
            u(j,i)=ma(i)+(mi(i)-ma(i))*rand();  %�����ʼ��������������ÿһά[min max]�г�ʼ����Щ
       end      
    end
    
    while 1
        pre_u=u;            %��һ����õ�����λ��
        for i=1:N
            tmp{i}=[];      % ��ʽһ�е�x(i)-uj,Ϊ��ʽһʵ����׼��
            for j=1:m
                tmp{i}=[tmp{i};data(j,:)-u(i,:)];  %tmp��������ÿ�����ݼ�ȥÿ���������ĵĽ�������ǵ�i����������
            end
        end
        
        quan=zeros(m,N);
        for i=1:m        %��ʽһ��ʵ��
            c=[];
            for j=1:N
                c=[c norm(tmp{j}(i,:))];%���ض�����
            end
            [junk index]=min(c); %��ÿ�еõ���j����Сֵ��������Сֵ�������������Ǹ�����
            quan(i,index)=norm(tmp{index}(i,:));%�õ���ǰ�еĶ�Ӧ��С��������ֵ           
        end
        
        for i=1:N            %��ʽ����ʵ��
           for j=1:n
                u(i,j)=sum(quan(:,i).*data(:,j))/sum(quan(:,i));%���¼�������
           end           
        end
        
        if norm(pre_u-u)<0.1  %���ϵ���ֱ��λ�ò��ٱ仯
            break;
        end
    end
    
    re=[];
    %�������ٷ����仯���Ǿ�˵���ﵽ���һ���ˣ�ֱ���ټ���һ�ζ�������ȥ��С���Ǹ����õ�ÿһ�������ı�ǩ
    %���Կ���������Ĳ�����ͬ��
    for i=1:m
        tmp=[];
        for j=1:N
            tmp=[tmp norm(data(i,:)-u(j,:))];
        end
        [junk index]=min(tmp);
        re=[re;data(i,:) index];
    end
    
end