function [ jointquat ] = joint_euler2quat( skel,jointeuler )
%���ؽڵ�ŷ����ת��Ϊ��Ԫ��
euler96=channel62To96(jointeuler);
jointnum=length(skel.tree);
jointquat=zeros(jointnum,4);
for i=2:jointnum+1
    temp=deg2rad(euler96(1,i*3-2:i*3));
    q=eul2quat(temp,'zyx')';
    jointquat(i-1,:)=q./norm(q);
end

end

