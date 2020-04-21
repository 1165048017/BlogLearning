function joint = xyzpoppe2joint(pos)

% XYZPOPPE2JOINT
%
% COPYRIGHT : Carl Henrik Ek and Neil Lawrence, 2008

% MOCAP

% convert angles to radians
pos = pos.*2*pi/360;

joint = zeros(15,3);

M_right_1 = rotationMatrix(pos(1),-pos(2),pos(3),'xyz');
M_right_2 = rotationMatrix(0,0,pos(7),'xyz');

M_left_1 = rotationMatrix(pos(4),-pos(5),pos(6),'xyz');
M_left_2 = rotationMatrix(0,0,pos(8),'xyz');

M_camera = rotationMatrix(0,0,pos(9),'xyz');

joint = zeros(11,3);
joint(1,:) = [0 0 0]; %head
joint(2,:) = [0 0 1]; %neck
joint(3,:) = [0 0 -1];%pelvis

joint(14,:) = [1/2 0 0]; %left shoulder
    
joint(4,:) = [1 0 0]; %left elbow
joint(5,:) = [2 0 0]; %left hand

joint(6,:) = [-1 0 0];%right elbow
joint(7,:) = [-2 0 0];%right hand

joint(15,:) = [-1/2 0 0];%right shoulder

joint(8,:) = [1/2 0 -1];%left hip
joint(9,:) = [1/2 0 -2];%left knee
joint(10,:) = [1/2 0 -3];%left foot 
joint(11,:) = [-1/2 0 -1];%right hip
joint(12,:) = [-1/2 0 -2];%right knee
joint(13,:) = [-1/2 0 -3];%right foot

% transform according to pos

joint(5,:) = joint(5,:)-joint(4,:);
joint(5,:) = joint(5,:)*M_left_2;
joint(5,:) = joint(5,:)+joint(4,:);
joint(5,:) = joint(5,:)-joint(14,:);
joint(4,:) = joint(4,:)-joint(14,:);
joint(5,:) = joint(5,:)*M_left_1;
joint(4,:) = joint(4,:)*M_left_1;
joint(5,:) = joint(5,:)+joint(14,:);
joint(4,:) = joint(4,:)+joint(14,:);

joint(7,:) = joint(7,:)-joint(6,:);
joint(7,:) = joint(7,:)*M_right_2;
joint(7,:) = joint(7,:)+joint(6,:);
joint(7,:) = joint(7,:)-joint(15,:);
joint(6,:) = joint(6,:)-joint(15,:);
joint(7,:) = joint(7,:)*M_right_1;
joint(6,:) = joint(6,:)*M_right_1;
joint(7,:) = joint(7,:)+joint(15,:);
joint(6,:) = joint(6,:)+joint(15,:);

joint = joint*M_camera;


return
