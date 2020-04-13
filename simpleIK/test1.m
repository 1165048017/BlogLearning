% ��֤�򵥵�IK�㷨
clear;clc;close all
format long
%% �����ؽ������Լ�Ŀ����λ��
% a=[1.25659, 45.2178, -3.38288];
% b=[-0.121869, 24.0376, -7.42323];
% c=[-0.254057, 1.71113, -9.4434];
% t=[0.254057, 11.71113, 9.4434];
a=[0, 45, 0];
b=[2, 24, 0];
c=[0, 2, 0];
t=[0, 12, 0];
% a=[0,0,0];
% b=[3,4,0];
% c=[3,5,0];
% t=[5,0,1];
%% ����IK
% �Ƚ�ԭʼ��̬��a��b�ؽڽǶȽ���Ϊ����̬�ĽǶ�
ac = c-a; ac_norm= ac/norm(ac);
ab = b-a; ab_norm= ab/norm(ab); lc = norm(ab);
ba = a-b; ba_norm= ba/norm(ba); 
bc = c-b; bc_norm= bc/norm(bc); la = norm(bc);
at = t-a; at_norm= at/norm(at);lt = norm(at);
if(la+lc<lt)
    warning('can not reach');
end

ac_ab_0 = acos(clamp(dot(ac_norm,ab_norm),-1,1)); % ԭʼ��̬��a�ؽڽǶ�
ba_bc_0 = acos(clamp(dot(ba_norm,bc_norm),-1,1)); % ԭʼ��̬��b�ؽڽǶ�

ac_ab_1 = acos(clamp((lc^2+lt^2-la^2)/(2*lc*lt),-1,1)); %����̬a�ĽǶ�
ba_bc_1 = acos(clamp((lc^2+la^2-lt^2)/(2*lc*la),-1,1)); %����̬b�ĽǶ�

a0 = cross(ab,ac);a0=a0/norm(a0); %ԭ��̬a�ؽڵ���ת������
temp_b = a + (axang2rotm([a0,ac_ab_1 - ac_ab_0])*ab')'; %b����λ��
% ����һ��a->temp_b ��ԭ����ac�ļн�
temp_ab = temp_b-a;temp_ab_norm=temp_ab/norm(temp_ab);
temp_ab_ac = acos(clamp(dot(temp_ab_norm,ac_norm),-1,1));
fprintf('target_angle:%f\t temp_angle:%f\n',rad2deg(ac_ab_1),rad2deg(temp_ab_ac));

temp_c = temp_b + (axang2rotm([a0,ba_bc_0-ba_bc_1])*bc')'; %c����λ��
% ����һ��a->temp_c ��ԭ����ac�ļн�
temp_ac = temp_c-a;temp_ac_norm=temp_ac/norm(temp_ac);
temp_ac_ac = acos(clamp(dot(temp_ac_norm,ac_norm),-1,1));
fprintf('target_angle:%f\t temp_angle:%f\n',rad2deg(temp_ac_ac),rad2deg(temp_ac_ac));

fprintf('at:%f\t new_ac:%f\n',lt,norm(temp_c-a));
% �������½ǶȵĹؽ���ת��Ŀ���
temp_ac = temp_c-a; temp_ac_norm = temp_ac/norm(temp_ac);
ac_at_0 = acos(clamp(dot(temp_ac_norm,at_norm),-1,1)); %a������ת����λ����Ҫ�ĽǶ�
a1 = cross(temp_ac,at);a1=a1/norm(a1); %ԭ��̬a�ؽڵ���ת������
new_b = a + (axang2rotm([a1,ac_at_0])*(temp_b-a)')';%����b��λ��
new_c = a + (axang2rotm([a1,ac_at_0])*(temp_c-a)')';%����c��λ��

fprintf('error:%f\n',sum(abs(t-new_c)));
%���ӻ�
%ԭʼֵ
plot3([a(1),b(1),c(1)],[a(2),b(2),c(2)],[a(3),b(3),c(3)],'r-')
hold on
plot3([a(1),b(1),c(1)],[a(2),b(2),c(2)],[a(3),b(3),c(3)],'ro')
plot3(t(1),t(2),t(3),'g^')
%tempֵ
plot3([a(1),temp_b(1),temp_c(1)],[a(2),temp_b(2),temp_c(2)],[a(3),temp_b(3),temp_c(3)],'b:')
%����ֵ
plot3([a(1),new_b(1),new_c(1)],[a(2),new_b(2),new_c(2)],[a(3),new_b(3),new_c(3)],'g-')

view(0,90)
xlabel('x')
ylabel('y')
zlabel('z')
axis equal