function X = xyzhumanevaAlign(X,beta,display)

% XYZHUMANEVAALIGN
%
% COPYRIGHT : Carl Henrik Ek and Neil Lawrence, 2008

% MOCAP


if(nargin<3)
  display = false;
  if(nargin<2)
    beta = pi;
    if(nargin<1)
      error('Too Few Arguments');
    end
  end
end

if(display)
  handle_waitbar = waitbar(0,'Aligning');
end
for(i = 1:1:size(X,1))
  joint = xyzhumaneva2joint(X(i,:));
  alpha = xyzhumanevaHeadingAngle(X(i,:));
  M = rotationMatrix(0,0,beta-alpha);
  joint = joint*M;
  X(i,:) = xyzhumanevaJoint2pos(joint);
  if(display)
    waitbar(i/size(X,1))
  end
end
if(display)
  close(handle_waitbar);
end
