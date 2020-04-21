function alpha = xyzhumanevaHeadingAngle(Z,display)

% XYZHUMANEVAHEADINGANGLE 
%
% COPYRIGHT : Carl Henrik Ek and Neil Lawrence, 2008

% MOCAP
  
  
if(nargin<2)
  display = false;
  if(nargin<1)
    error('Too Few Arguments');
  end
end

alpha = zeros(size(Z,1),1);
if(display)
  handle_waitbar = waitbar(0,'Computing Heading Angle');
end
for(i = 1:1:size(Z,1))
  joint = xyzhumaneva2joint(Z(i,:));
  x1 = joint(2,:);
  x2 = joint(6,:);
  
  v = x1-x2;
  w = cross(v,[0 0 1]); % pointing in heading direction
  
  % screen plane yz
  alpha(i) = acos(dot([0 1 0],w)/(norm([0 1 0],2)*norm(w,2)));
  
  % check direction
  if(dot(w,[1 0 0])>0)
    alpha(i) = -alpha(i);
  end
  
  if(display)
    waitbar(i/size(Z,1));
  end
  
end
if(display)
  close(handle_waitbar);
end

return
