function handle = xyzpoppeDraw(joint,handle)

% XYZPOPPEDRAW Helper function for drawing data from Poppe.
% 
% COPYRIGHT : Carl Henrik Ek, 2009
%
% SEEALSO xyzpoppeModify, xyzpoppeVisualise
%

% MOCAP

limb{1} = [2 1;1 3]; % spine
limb{2} = [1 14;14 4;4 5]; % left arm
limb{3} = [1 15;15 6;6 7]; % right arm
limb{4} = [3 8;8 9;9 10]; % left leg
limb{5} = [3 11;11 12;12 13]; % right leg


if(nargin<2)
  % draw figure
  k = 1;
  for(i = 1:1:length(limb))
    linestyle = '-';
    markersize = 20;
    marker = '.';
    for(j = 1:1:size(limb{i},1))
      if (i==3 && j>3) || (i==5 && j>3)
	markersize = 5;
	marker = 's';
      end
      handle(k) = line(joint(limb{i}(j,:),1),joint(limb{i}(j,:),2), ...
		       joint(limb{i}(j,:),3), 'LineWidth', 3, ...
		       'LineStyle', linestyle, ...
		       'Marker', marker, ...
		       'markersize', markersize);
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

view(3);

return;
