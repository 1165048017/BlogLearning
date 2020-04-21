function joint = xyzhumaneva2joint(pos,transf)

% XYZHUMANEVA2JOINT
%
% COPYRIGHT : Carl Henrik Ek and Neil Lawrence, 2008

% MOCAP


joint(:,1) = pos(1:3:end);
joint(:,2) = pos(2:3:end);
joint(:,3) = pos(3:3:end);

if(exist('transf','var'))
  joint = joint - repmat(transf.center,size(joint,1),1);
  M = rotationMatrix(transf.x,transf.y,transf.z);
  joint = joint*M;
  joint = joint + repmat(transf.center,size(joint,1),1);
end

return
