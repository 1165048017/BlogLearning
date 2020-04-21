function [ jointeul ] = joint_quat2euler( jointquat )
%将四元数还原成欧拉角
temp=[0 0 0 ];
for i=1:size(jointquat,1)
    temp=[temp quat2eul(jointquat(i,:),'zyx')];
end
jointeul=channel96To62(rad2deg(temp));
end

