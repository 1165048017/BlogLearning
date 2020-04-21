%����һ��matlab�Դ�����slerp
clear
clc
close all
addpath(genpath('.'))

%��ȡ�����˶�����skel,A,B
load sample.mat
% skelPlayDataA(skel,[A;B])
%��ŷ����ת��Ϊ��Ԫ��
quatA=joint_euler2quat(skel,A);
quatB=joint_euler2quat(skel,B);
%ִ����Ԫ����ֵ����20֡
internum=20;
temp_quat=zeros(31,4);%31���ؽڣ�ÿ���ؽ�һ����Ԫ��
newMotion=zeros(internum,62);%20֡��ÿ֡62ά
for i=1:internum
    t=i/internum;
    %���ڽǶȲ�����Ԫ����ֵ
    for j=1:size(quatA,1)
        temp_quat(j,:)=slerp(quatA(j,:),quatB(j,:),t);        
    end
    temp_quat(find(isnan(temp_quat)))=0;
    temp_quat=real(temp_quat);
    newMotion(i,:)=joint_quat2euler(temp_quat);
    %����λ�ò������Բ�ֵ
    posA=A(1,1:3);posB=B(1,1:3);
    newMotion(i,1:3)=(1-t)*posA+t*posB;
end
newMotion(find(isnan(newMotion)))=0;
skelPlayDataA(skel,[A;newMotion;B])
