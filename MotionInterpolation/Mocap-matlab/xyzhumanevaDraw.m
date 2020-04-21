function handle = xyzhumanevaDraw(joint,handle,type)

% XYZHUMANEVADRAW
%
% COPYRIGHT : Carl Henrik Ek and Neil Lawrence, 2008

% MOCAP


if(nargin<3)
  type = 'jon';
end

if(size(joint,1)==18)
  type = 'raquelS3';
end

% extract limbs
switch type
 case 'jon'
  limb{1} = [1 2;2 3;3 4;4 5]; % left leg
  limb{2} = [1 6;6 7;7 8;8 9]; % right leg
  limb{3} = [19 10;10 11;11 12;12 13]; % left arm
  limb{4} = [19 14;14 15;15 16;16 17]; % right arm
  limb{5} = [1 19;19 18]; % head
 case 'raquel'
  limb{1} = [1 2;2 3;3 4;4 5]; % left leg
  limb{2} = [1 6;6 7;7 8;8 9]; % right leg
  limb{3} = [19 10;10 11;11 12;12 13]; % left arm
  limb{4} = [19 14;14 15;15 16;16 17]; % right arm
  limb{5} = [1 19;19 18]; % head
 case 'raquelS3'
  limb{1} = [1 2;2 3;3 4;4 5]; % left leg
  limb{2} = [1 6;6 7;7 8;8 9]; % right leg
  limb{3} = [18 10;10 11;11 12;12 13]; % left arm
  limb{4} = [18 14;14 15;15 16;16 17]; % right arm
 otherwise
  error('Unkown parametrization');
end
  
if(nargin<2||isempty(handle))
  % draw figure
  k = 1;
  for(i = 1:1:length(limb))
    if(ismember(i,[1 3]))
      % left side
      linestyle = '-';
    end
    if(ismember(i,[2 4]))
      % right side
      linestyle = '-.';
    end
    for(j = 1:1:size(limb{i},1))
      handle(k) = line(joint(limb{i}(j,:),1),joint(limb{i}(j,:),2),joint(limb{i}(j,:),3),'LineWidth',3,'LineStyle',linestyle);
      k = k + 1;
    end
  end
else
  % modify figure
  k = 1;
  for(i = 1:1:length(limb))
    for(j = 1:1:size(limb{i},1))
      set(handle(k),'Xdata',joint(limb{i}(j,:),1),'Ydata',joint(limb{i}(j,:),2),'Zdata',joint(limb{i}(j,:),3));
      k = k+1;
    end
  end
end

return;
