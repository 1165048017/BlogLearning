function qM=quatMatrix(channels62)
channels96=channel62To96(channels62);
B=channels96(:,4:96)/180*pi;
frames=size(B,1);
C=zeros(frames,31*4);
for t=1:frames
    for i=1:31
        q=angle2quat(B(t,i*3-2),B(t,i*3-1),B(t,i*3),'xyz');
        q=q/norm(q);
        C(t,i*4-3:i*4)=q;
    end
end
qM=C;
end