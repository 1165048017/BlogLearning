%N是数据一共分多少类
%data是输入的不带分类标号的数据
%u是每一类的中心
%re是返回的带分类标号的数据
function [u re]=KMeans(data,N)   
    [m n]=size(data);   %m是数据个数，n是数据维数
    ma=zeros(n);        %每一维最大的数
    mi=zeros(n);        %每一维最小的数
    u=zeros(N,n);       %随机初始化，最终迭代到每一类的中心位置
    for i=1:n
       ma(i)=max(data(:,i));    %每一维最大的数
       mi(i)=min(data(:,i));    %每一维最小的数
       for j=1:N
            u(j,i)=ma(i)+(mi(i)-ma(i))*rand();  %随机初始化，不过还是在每一维[min max]中初始化好些
       end      
    end
    
    while 1
        pre_u=u;            %上一次求得的中心位置
        for i=1:N
            tmp{i}=[];      % 公式一中的x(i)-uj,为公式一实现做准备
            for j=1:m
                tmp{i}=[tmp{i};data(j,:)-u(i,:)];  %tmp存数的是每个数据减去每个聚类中心的结果，这是第i个聚类中心
            end
        end
        
        quan=zeros(m,N);
        for i=1:m        %公式一的实现
            c=[];
            for j=1:N
                c=[c norm(tmp{j}(i,:))];%返回二范数
            end
            [junk index]=min(c); %找每行得到的j个最小值的最终最小值，并返回其是那个聚类
            quan(i,index)=norm(tmp{index}(i,:));%得到当前行的对应最小二范数的值           
        end
        
        for i=1:N            %公式二的实现
           for j=1:n
                u(i,j)=sum(quan(:,i).*data(:,j))/sum(quan(:,i));%重新计算质心
           end           
        end
        
        if norm(pre_u-u)<0.1  %不断迭代直到位置不再变化
            break;
        end
    end
    
    re=[];
    %迭代不再发生变化，那就说明达到最后一步了，直接再计算一次二范数，去最小的那个，得到每一行所属的标签
    %可以看到与上面的步骤相同。
    for i=1:m
        tmp=[];
        for j=1:N
            tmp=[tmp norm(data(i,:)-u(j,:))];
        end
        [junk index]=min(tmp);
        re=[re;data(i,:) index];
    end
    
end