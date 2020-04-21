function CM=quatInterp(channelsA,channelsB,n);
frameA=size(channelsA,1);
frameB=size(channelsB,1);
qM1=quatMatrix(channelsA);
qM2=quatMatrix(channelsB);

everyN=1/(n+1);
cM=zeros(n,4*31);
y=zeros(n,4);
for i=1:31
    M1=qM1(frameA,i*4-3:i*4);
    M2=qM2(1,i*4-3:i*4);
    for j=1:n
        y(j,:)=slerp(M1,M2,everyN*j);
    end
    cM(:,i*4-3:i*4)=y;
end
rcM=real(cM);
for i=1:31
    [r1 r2 r3]=quat2angle(rcM(:,i*4-3:i*4),'xyz');
    Temp=[r1 r2 r3]/pi*180;
    D(:,i*3-2:i*3)=Temp;
end
 
%��ڵ��n֡
Root1=channelsA(frameA,1:3);
Root2=channelsB(1,1:3);
MRoot=interp1([1 n+2],[Root1; Root2],2:n+1,'spline');
D=[MRoot D];
%����ľ���?
CM=zeros(n,62);
CM(:,1:3)=MRoot;
CM(:,4:6)=D(:,4:6);
CM(:,7:9)=D(:,10:12);
r1=channelsA(frameA,10);
r2=channelsB(1,10);
CM(:,10)=interp1([1 n+2],[r1; r2],2:n+1,'spline');
CM(:,11:12)=D(:,[16,18]);
r1=channelsA(frameA,13);
r2=channelsB(1,13);
CM(:,13)=interp1([1 n+2],[r1; r2],2:n+1,'spline');
CM(:,14:16)=D(:,25:27);
r1=channelsA(frameA,17);
r2=channelsB(1,17);
CM(:,17)=interp1([1 n+2],[r1; r2],2:n+1,'spline');
CM(:,18:19)=D(:,[31 33]);
r1=channelsA(frameA,20);
r2=channelsB(1,20);
CM(:,20)=interp1([1 n+2],[r1; r2],2:n+1,'spline');
CM(:,21:38)=D(:,37:54);
CM(:,39:43)=D(:,56:60);
r1=channelsA(frameA,44);
r2=channelsB(1,44);
CM(:,44)=interp1([1 n+2],[r1; r2],2:n+1,'spline');
r1=channelsA(frameA,45);
r2=channelsB(1,45);
CM(:,45)=interp1([1 n+2],[r1; r2],2:n+1,'spline');
CM(:,46:47)=D(:,[67 69]);
r1=channelsA(frameA,48);
r2=channelsB(1,48);
CM(:,48)=interp1([1 n+2],[r1; r2],2:n+1,'spline');
CM(:,49:50)=D(:,[73 75]);
CM(:,51:55)=D(:,77:81);

r1=channelsA(frameA,56);
r2=channelsB(1,56);
CM(:,56)=interp1([1 n+2],[r1; r2],2:n+1,'spline');
r1=channelsA(frameA,57);
r2=channelsB(1,57);
CM(:,57)=interp1([1 n+2],[r1; r2],2:n+1,'spline');
CM(:,[58 59])=D(:,[88 90]);
r1=channelsA(frameA,60);
r2=channelsB(1,60);
CM(:,60)=interp1([1 n+2],[r1; r2],2:n+1,'spline');
CM(:,61:62)=D(:,[94 96]);  
% newChannels=[channelsA;CM; channelsB];
 