function [ jointeul ] = joint_quat2euler( jointquat )
%����Ԫ����ԭ��ŷ����
temp=[0 0 0 ];
for i=1:size(jointquat,1)
    temp=[temp quat2eul(jointquat(i,:),'zyx')];
end
jointeul=channel96To62(rad2deg(temp));
end

