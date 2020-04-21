function [ channel62 ] = channel96To62( channel96 )
frames=size(channel96,1);
channel62=zeros(frames,62);
channel62(:,1:6)=channel96(:,1:6);%root

channel62(:,7:9)=channel96(:,10:12);%lfemur
channel62(:,10)=channel96(:,13);%ltibia

channel62(:,11)=channel96(:,16);%lfoot
channel62(:,12)=channel96(:,18);%lfoot

channel62(:,13)=channel96(:,19);%ltoes

channel62(:,14:16)=channel96(:,25:27);%±àºÅ7

channel62(:,17)=channel96(:,28);

channel62(:,18)=channel96(:,31);%±àºÅ9
channel62(:,19)=channel96(:,33);

channel62(:,20)=channel96(:,34);%±àºÅ10

channel62(:,21:23)=channel96(:,37:39);
channel62(:,24:26)=channel96(:,40:42);

channel62(:,27:29)=channel96(:,43:45);
channel62(:,30:32)=channel96(:,46:48);
channel62(:,33:35)=channel96(:,49:51);
channel62(:,36:38)=channel96(:,52:54);
channel62(:,39:40)=channel96(:,56:57);
channel62(:,41:43)=channel96(:,58:60);

channel62(:,44)=channel96(:,61);
channel62(:,45)=channel96(:,65);
channel62(:,46)=channel96(:,67);
channel62(:,47)=channel96(:,69);


channel62(:,48)=channel96(:,70);
channel62(:,49)=channel96(:,73);
channel62(:,50)=channel96(:,75);


channel62(:,51:52)=channel96(:,77:78);

channel62(:,53:55)=channel96(:,79:81);

channel62(:,56)=channel96(:,82);

channel62(:,57)=channel96(:,86);
channel62(:,58)=channel96(:,88);
channel62(:,59)=channel96(:,90);

channel62(:,60)=channel96(:,91);
channel62(:,61)=channel96(:,94);
channel62(:,62)=channel96(:,96);

end

