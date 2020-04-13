% 验证简单的IK算法
clear;clc;close all
format long
%% 三个关节坐标以及目标点的位置
a=[1.25659, 45.2178, -3.38288];
b=[-0.121869, 24.0376, -7.42323];
c=[-0.254057, 1.71113, -9.4434];
t=[0.254057, 11.71113, 9.4434];
% a=[0, 45, 0];
% b=[2, 24, 0];
% c=[0, 2, 0];
% t=[5, 12, 0];
% a=[0,0,0];
% b=[3,4,0];
% c=[3,5,0];
% t=[5,0,1];
%% 计算IK
% 先将原始姿态的a、b关节角度矫正为新姿态的角度
ac = c-a; ac_norm= ac/norm(ac);
ab = b-a; ab_norm= ab/norm(ab); lc = norm(ab);
ba = a-b; ba_norm= ba/norm(ba); 
bc = c-b; bc_norm= bc/norm(bc); la = norm(bc);
at = t-a; at_norm= at/norm(at);lt = norm(at);
if(la+lc<lt)
    warning('can not reach');
end
ba_bc_0 = acos(clamp(dot(ba_norm,bc_norm),-1,1)); % 原始姿态的b关节角度
ba_bc_1 = acos(clamp((lc^2+la^2-lt^2)/(2*lc*la),-1,1)); %新姿态b的角度
rot_axis = cross(ba,bc);rot_axis=rot_axis/norm(rot_axis); %旋转轴
temp_c = b + (axang2rotm([rot_axis,ba_bc_1-ba_bc_0])*bc')'; %c的新位置

% 将具有新角度的关节旋转到目标点
temp_ac = temp_c-a; temp_ac_norm = temp_ac/norm(temp_ac);
ac_at_0 = acos(clamp(dot(temp_ac_norm,at_norm),-1,1)); %a顶点旋转到新位置需要的角度
a1 = cross(temp_ac,at);a1=a1/norm(a1); %原姿态a关节的旋转法向量
new_b = a + (axang2rotm([a1,ac_at_0])*(b-a)')';%最终b的位置
new_c = a + (axang2rotm([a1,ac_at_0])*(temp_c-a)')';%最终c的位置
fprintf('error:%f\n',sum(abs(t-new_c)));
%可视化
%原始值
plot3([a(1),b(1),c(1)],[a(2),b(2),c(2)],[a(3),b(3),c(3)],'r-')
hold on
plot3([a(1),b(1),c(1)],[a(2),b(2),c(2)],[a(3),b(3),c(3)],'ro')
plot3(t(1),t(2),t(3),'g^')
%temp值
plot3([a(1),b(1),temp_c(1)],[a(2),b(2),temp_c(2)],[a(3),b(3),temp_c(3)],'b:')
%最终值
plot3([a(1),new_b(1),new_c(1)],[a(2),new_b(2),new_c(2)],[a(3),new_b(3),new_c(3)],'g-')

view(0,90)
xlabel('x')
ylabel('y')
zlabel('z')
axis equal