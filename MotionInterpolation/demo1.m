%方法一：matlab自带函数slerp
clear
clc
close all
addpath(genpath('.'))

%读取两个运动数据skel,A,B
load sample.mat
% skelPlayDataA(skel,[A;B])
%将欧拉角转换为四元数
quatA=joint_euler2quat(skel,A);
quatB=joint_euler2quat(skel,B);
%执行四元数插值，插20帧
internum=20;
temp_quat=zeros(31,4);%31个关节，每个关节一个四元数
newMotion=zeros(internum,62);%20帧，每帧62维
for i=1:internum
    t=i/internum;
    %对于角度采用四元数插值
    for j=1:size(quatA,1)
        temp_quat(j,:)=slerp(quatA(j,:),quatB(j,:),t);        
    end
    temp_quat(find(isnan(temp_quat)))=0;
    temp_quat=real(temp_quat);
    newMotion(i,:)=joint_quat2euler(temp_quat);
    %对于位置采用线性插值
    posA=A(1,1:3);posB=B(1,1:3);
    newMotion(i,1:3)=(1-t)*posA+t*posB;
end
newMotion(find(isnan(newMotion)))=0;
skelPlayDataA(skel,[A;newMotion;B])
