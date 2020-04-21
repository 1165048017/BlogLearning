function handle = xyzhumanevaModify2(handle,pos)

% XYZHUMANEVAMODIFY2
%
% COPYRIGHT : Carl Henrik Ek and Neil Lawrence, 2008

% MOCAP


joint = xyzhumaneva2joint(pos);
xyzhumanevaDraw(joint,handle{1});
xyzhumanevaDraw(joint,handle{2});

return
