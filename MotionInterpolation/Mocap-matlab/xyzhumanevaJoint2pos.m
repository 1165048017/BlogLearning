function pos = xyzhumanevaJoint2pos(joint)

% XYZHUMANEVAJOINT2POS
%
% COPYRIGHT : Carl Henrik Ek and Neil Lawrence, 2008

% MOCAP


pos = zeros(1,prod(size(joint)));

pos(1:3:end) = joint(:,1);
pos(2:3:end) = joint(:,2);
pos(3:3:end) = joint(:,3);

return
